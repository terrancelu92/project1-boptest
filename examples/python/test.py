# -*- coding: utf-8 -*-
"""
This module is an example python-based testing interface.  It uses the
``requests`` package to make REST API calls to the test case container,
which mus already be running.  A controller is tested, which is 
imported from a different module.
  
"""
import requests
import os
import sys
import requests
import numpy as np
import importlib
import json, collections
import csv
from datetime import datetime, timedelta
import Resets.resets as reset
import time
import pandas as pd

class Simulate:
    def __init__(self, config):
        # SETUP TEST CASE
        # ---------------
        # Set URL for testcase
        self.url = 'http://127.0.0.1:5000'
        self.measurements = []
        self.u = {}
        self.resets = None
        self.writer = None
        self.init = None
        # Set simulation parameters
        reset_config = config.get("resets")
        controller = config.get("controller", {})
        self.controller = None
        start_day = config.get("start_day", 180)
        self.start_time = start_day * 86400
        length = config.get("simulation_duration_days", 1)
        self.end_time = (start_day + length) * 86400
        self.step = config.get("step", 60)
        self.reset_frequency = config.get("reset_frequency", 10)
        self.loop = int(length * 86400 / self.step)
        self.get_measurements()
        self.init_resets(reset_config)
        self.create_data_store()
        self.init_simulation()
        d = datetime(2018, 1, 1) + timedelta(seconds=self.start_time)
        print("Starting time: {}\n".format(d.strftime("%A %d. %B %Y %I:%M%p")))
        if controller:
            self.controller = reset.setup_controller(controller, self.measurements)

    def get_measurements(self):
        """
        Get available data from simulation.
        """
        measurements = requests.get('{0}/measurements'.format(self.url)).json()['payload']
        measurements = list(measurements.keys())
        measurements.append('time')
        inputs = requests.get('{0}/inputs'.format(self.url)).json()['payload']
        inputs = list(inputs.keys())
        measurements.extend(inputs)
        print('Measurements:\t\t\t{0}'.format(measurements))
        measurements_file = "measurementsList.csv"
        with open(measurements_file, "w", newline="") as outFile:
            writer = csv.writer(outFile)
            for line in sorted(measurements):
                writer.writerow([line])
        self.measurements = measurements

    def init_resets(self, reset_configs):
        if reset_configs:
            self.resets = reset.setup_resets(reset_configs, self.measurements)
            for cls in self.resets:
                print(cls.control)
                for point, activate, value in zip(cls.control, cls.activate, cls.default_setpoint):
                    self.u[point] = value
                    self.u[activate] = 0
        else:
            print("No resets configured!  Running baseline!")
            self.u = {}

    def init_simulation(self):
        """
        1.  Set step size for simulation.
        2.  Call advance to initialize the simulation.
        3.  Call reset to set the start and end time for the simulation.
        """
        # y = requests.post('{0}/advance'.format(self.url), json=json.dumps({})).json()
        self.init = requests.put('{0}/initialize'.format(self.url), data={'start_time': self.start_time, 'warmup_period': 0}).json()['payload']
        res = requests.put('{0}/step'.format(self.url), data={"step": self.step})

    def create_data_store(self):
        """
        Create results file for simulation.
        """
        dt_str = datetime.now().strftime("_%b%d%Y_%H%M")
        file_name = "results/results"+dt_str+".csv"

        if not os.path.exists('results'):
            os.makedirs('results')
        if os.path.exists(file_name):
            os.remove(file_name)
            out_file = open(file_name, "w", newline="")
            writer = csv.DictWriter(out_file, fieldnames=sorted(self.measurements))
            writer.writeheader()
        else:
            out_file = open(file_name, "w", newline="")
            writer = csv.DictWriter(out_file, fieldnames=sorted(self.measurements))
            writer.writeheader()
        self.writer = writer

    def run_loop(self):
        """
        Run loop
        """
        runtime_list = []
        y = self.init if self.init is not None else {}
        for i in range(int(self.loop)):
            # Advance simulation
            if self.resets is not None and not i % self.reset_frequency and y:
                for cls in self.resets:
                    cls.update(y)
                    r = cls.check_requests(y)
                    cls.reset(r)
                    for point, activate, value_pt in zip(cls.control, cls.activate, cls.current_sp):
                        self.u[point] = value_pt
                        self.u[activate] = cls.activate_value
            if self.controller is not None:
                for cls in self.controller:
                    cls.update(y)
                    self.u.update(cls.controller)
            print("Control: {} -- i: {}".format(self.u, i))
            starttime = time.time()
            y = requests.post('{0}/advance'.format(self.url), data=self.u).json()['payload']
            # y = {key: y[key] for key in self.measurements if key in y}
            # Calculate the runtime
            endtime = time.time()
            runtime_list.append(endtime - starttime)
            print("CPU runtime:", endtime - starttime, "seconds")
            self.writer.writerow(dict(sorted(y.items(), key=lambda x: x[0])))
            #print("Measurements at time {}: {}".format(y['time'], y))
        print('\nTest case complete.')
        df = pd.DataFrame({'Column1': runtime_list})
        # Save DataFrame to a CSV file
        df.to_csv('run_time.csv', index=False)


if __name__ == "__main__":
    working_dir = 'C:/Github/project1-boptest/examples/python'
    os.chdir(working_dir)
    with open("configs/config_summer1_baseline") as f:
        config = json.load(f)
    print(config)
    simulation = Simulate(config)
    simulation.run_loop()
    with open("configs/config_summer1_SAT_reset") as f:
        config = json.load(f)
    print(config)
    simulation = Simulate(config)
    simulation.run_loop()