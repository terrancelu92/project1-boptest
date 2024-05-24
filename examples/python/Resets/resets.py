# -*- coding: utf-8 -*-
"""
This module is an example python-based testing interface.  It uses the
``requests`` package to make REST API calls to the test case container,
which mus already be running.  A controller is tested, which is 
imported from a different module.
  
"""

import os
import sys

import numpy as np
import json
import importlib
import csv
from datetime import datetime, timedelta


def bound(value, _min, _max):
    return max(_min, min(value, _max))

def get_respond(value1, value2):
    if value1 < 0 and value2 < 0:
        return max(value1, value2)
    else:
        return min(value1, value2)


def setup_resets(config, measurements):
    resets = []
    print(os.getcwd())
    # device_resets = config.get('resets')
    for name, config in config.items():
        path = config
        print(path)
        with open(path) as f:
            reset_config = json.load(f)
        #try:
        class_name = reset_config.pop("class")
        print(class_name)
        cls = factory(class_name)
        resets.append(cls(measurements, reset_config))
        # except KeyError:
        #     print("Missing class definition for {}".format(name))
        #     continue
    return resets


def setup_controller(config, measurements):
    controller = []
    print(os.getcwd())
    # device_resets = config.get('resets')
    for name, config in config.items():
        path = config
        print(path)
        with open(path) as f:
            control_config = json.load(f)
        #try:
        class_name = control_config.pop("class")
        print(class_name)
        cls = factory(class_name)
        controller.append(cls(control_config))
        # except KeyError:
        #     print("Missing class definition for {}".format(name))
        #     continue
    return controller

def factory(classname):
    base_module = "Resets.resets"
    module = importlib.import_module(base_module)
    cls = getattr(module, classname)
    return cls


class Reset:
    def __init__(self, config):
        self.validate_config(config)
        self.min_sp = config.pop("min_sp")
        self.max_sp = config.pop("max_sp")
        self.trim = config.pop("trim")
        self.respond = config.pop("respond")
        self.control = config.pop("control")
        self.activate = config.pop("activate")
        self.activate_value = 1.0
        try:
            self.max_respond = config.pop("max_respond")
        except KeyError:
            self.max_respond = 2*self.respond
        self.default_setpoint = config.pop("default_sp")
        try:
            self.ignored_requests = config.pop("ignored_requests")
        except KeyError:
            self.ignored_requests = 1
        self.current_sp = self.default_setpoint

    def validate_config(self, config):
        config_error = False
        config_keys = list(config.keys())
        if "min_sp" not in config_keys:
            print("Missing min_sp from config!")
            config_error = True
        if "max_sp" not in config_keys:
            print("Missing max_sp from config!")
            config_error = True
        if "trim" not in config_keys:
            print("Missing trim from config!")
            config_error = True
        if "respond" not in config_keys:
            print("Missing respond from config!")
            config_error = True
        if "default_sp" not in config_keys:
            print("Missing default_setpoint from config!")
            config_error = True

        if config_error:
            sys.exit()

    def reset(self, _requests):
        if not self.occupancy:
            self.current_sp = self.default_setpoint
            return

        if _requests > self.ignored_requests:
            sp = self.current_sp[0] + get_respond((_requests - self.ignored_requests) * self.respond, self.max_respond)
        else:
            sp = self.current_sp[0] + self.trim
        sp = bound(sp, self.min_sp, self.max_sp)
        self.current_sp = [sp]


class DatReset(Reset):
    def __init__(self, measurements, config):
        """
        Trim and respond DAT Reset
        """
        super().__init__(config)
        self.name = config.pop('name', "reset")
        try:
            oat_low = config.pop("oat_low")
        except KeyError:
            oat_low = 15.56
        try:
            oat_high = config.pop("oat_high")
        except KeyError:
            oat_high = 21.11
        try:
            self.request1 = config.pop("request1")
        except KeyError:
            self.request1 = 1.5
        try:
            self.request2 = config.pop("request2")
        except KeyError:
            self.request2 = 2.0
        try:
            self.clg_request_thr = config.pop("clg_request_thr")
        except KeyError:
            self.clg_request_thr = 0.95
        try:
            self.htg_request_thr = config.pop("htg_request_thr")
        except KeyError:
            self.htg_request_thr = 0.95
        try:
            self.oat_name = config.pop("oat_name")
        except KeyError:
            self.oat_name = 'loaEnePlu_weaSta_reaWeaTDryBul_y'
        try:
            self.occupancy_name = config.pop("occupancy_name")
        except KeyError:
            self.occupancy_name = 'hva_floor1_reaAhu_occ_y'

        self.csp = {}
        self.hsp = {}
        self.zt = {}
        self.zclg = {}
        self.zhtg = {}
        self.rated_htg_flow = {}
        self.zone_list = []
        self.zone_clg_req = {}
        self.zone_htg_req = {}
        self.validate(measurements, config)
        self.max_sat_bounds = np.linspace(self.max_sp, self.min_sp, 100)
        self.oat_bounds = np.linspace(oat_low, oat_high, 100)

    def validate(self, measurements, config):
        self.zone_list = list(config.keys())
        self.zone_clg_req = dict.fromkeys(self.zone_list, False)
        self.zone_htg_req = dict.fromkeys(self.zone_list, False)
        for zone, zone_info in config.items():
            for name, point in zone_info.items():
                if name == "temperature":
                    self.zt[zone] = point
                elif name == "cooling_setpoint":
                    self.csp[zone] = point
                elif name == "heating_setpoint":
                    self.hsp[zone] = point
                elif name == "cooling_signal":
                    self.zclg[zone] = point
                elif name == "heating_signal":
                    self.zhtg[zone] = point
                elif name == "rated_htg_flow":
                    print(point)
                    self.rated_htg_flow[zone] = point

    def generate_clg_request(self, zone_name, clg_signal, zt, csp):
        clg_requests = 0
        if zt - csp > self.request2:
            clg_requests = 3
        elif zt - csp > self.request1:
            clg_requests = 2
        elif clg_signal > self.clg_request_thr:
            clg_requests = 1
            self.zone_clg_req[zone_name] = True
        elif self.zone_clg_req[zone_name] and clg_signal > self.clg_request_thr - 0.1:
            clg_requests = 1
        else:
            self.zone_clg_req[zone_name] = False
        return clg_requests

    def generate_htg_request(self, zone_name, htg_signal, zt, hsp):
        htg_requests = 0
        if hsp - zt > self.request2:
            htg_requests = 3
        elif hsp - zt > self.request1:
            htg_requests = 2
        elif htg_signal > self.htg_request_thr:
            htg_requests = 1
            self.zone_htg_req[zone_name] = True
        elif self.zone_htg_req[zone_name] and htg_signal > self.htg_request_thr - 0.1:
            htg_requests = 1
        else:
            self.zone_htg_req[zone_name] = False
        return htg_requests

    def check_requests(self, measurements):
        clg_requests = 0
        htg_requests = 0

        for zone in self.zone_list:
            temp = 0
            zt = measurements[self.zt[zone]]
            csp = measurements[self.csp[zone]]
            hsp = measurements[self.hsp[zone]]
            clg_signal = measurements[self.zclg[zone]]
            htg_signal = measurements[self.zhtg[zone]]
            print("name: {} - zone {} -- occ {} -- max_sp: {} -- zt: {} -- cps: {} -- clg: {} -- htg: {}".format(self.name, zone, self.occupancy, self.max_sp, zt, csp, clg_signal, htg_signal))
            clg_temp = self.generate_clg_request(zone, clg_signal, zt, csp)
            htg_temp = self.generate_htg_request(zone, htg_signal, zt, hsp)

            clg_requests += clg_temp
            htg_requests += htg_temp
        _requests = max(0, clg_requests - htg_requests)
        print("SAT request: {}".format(_requests))
        return _requests

    def update(self, measurements):
        oat = measurements[self.oat_name]
        self.occupancy = int(measurements[self.occupancy_name])
        self.max_sp = np.interp(oat, self.oat_bounds, self.max_sat_bounds)


class ChwReset(Reset):
    def __init__(self, measurements, config):
        """
        Trim and respond DAT Reset
        """
        super().__init__(config)
        self.name = config.pop('name', "reset")
        try:
            self.request1 = config.pop("request1")
        except KeyError:
            self.request1 = 2.0
        try:
            self.request2 = config.pop("request2")
        except KeyError:
            self.request2 = 3.0
        try:
            self.clg_request_thr = config.pop("clg_request_thr")
        except KeyError:
            self.clg_request_thr = 0.95
        try:
            self.htg_request_thr = config.pop("htg_request_thr")
        except KeyError:
            self.htg_request_thr = 0.95
        try:
            self.oat_name = config.pop("oat_name")
        except KeyError:
            self.oat_name = 'TOutDryBul'
        try:
            self.occupancy_name = config.pop("occupancy_name")
        except KeyError:
            self.occupancy_name = 'hva_floor1_readAhu_occ_y'
        self.reset_sp = 100.0
        self.sat_sp = {}
        self.clg_signal = {}
        self.sat = {}
        self.device_list = []
        self.device_clg_req = {}
        self.validate(measurements, config)
        self.chw_bounds = np.linspace(self.max_sp[0], self.min_sp[0], 100)
        self.dp_bounds = np.linspace(self.min_sp[1], self.max_sp[1], 100)
        self.chw_reset = np.linspace(50, 100, 100)
        self.dp_reset = np.linspace(0, 50, 100)

    def validate(self, measurements, config):
        self.device_list = list(config.keys())
        self.device_clg_req = dict.fromkeys(self.device_list, False)
        for device, device_info in config.items():
            for name, point in device_info.items():
                if name == "cooling_signal":
                    self.clg_signal[device] = point
                elif name == "supply_temperature_setpoint":
                    self.sat_sp[device] = point
                elif name == "supply_temperature":
                    self.sat[device] = point

    def generate_clg_requests(self, device_name, clg_signal, sat, sat_sp):
        clg_requests = 0
        if sat - sat_sp > self.request2:
            clg_requests = 3
        elif sat - sat_sp > self.request1:
            clg_requests = 2
        elif clg_signal > self.clg_request_thr:
            clg_requests = 1
            self.device_clg_req[device_name] = True
        elif self.device_clg_req[device_name] and clg_signal > self.clg_request_thr - 0.1:
            clg_requests = 1
        else:
            self.device_clg_req[device_name] = False
        return clg_requests

    def check_requests(self, measurements):
        clg_requests = 0
        for device in self.device_list:
            sat = measurements[self.sat[device]]
            sat_sp = measurements[self.sat_sp[device]]
            clg_signal = measurements[self.clg_signal[device]]

            print("name: {} - device {} -- occ {} -- max_sp: {} -- sat: {} -- sat_sp: {} -- clg: {}".format(self.name, device, self.occupancy, self.max_sp, sat, sat_sp, clg_signal))
            clg_temp = self.generate_clg_requests(device, clg_signal, sat, sat_sp)
            print("AHU: {} -- sat requests: {}".format(device, clg_temp))
            clg_requests += clg_temp
        _requests = clg_requests
        print("CHW requests: {}".format(_requests))
        return _requests

    def update(self, measurements):
        self.occupancy = int(measurements[self.occupancy_name])

    def reset(self, _requests):
        if not self.occupancy:
            self.current_sp = self.default_setpoint
            self.reset_sp = 100.0
            return

        if _requests > self.ignored_requests:
            sp = self.reset_sp + min((_requests - self.ignored_requests) * self.respond, self.max_respond)
        else:
            sp = self.reset_sp + self.trim
        sp = bound(sp, 0, 100)
        self.reset_sp = sp
        chw_set = np.interp(sp, self.chw_reset, self.chw_bounds)
        dp_set = np.interp(sp, self.dp_reset, self.dp_bounds)
        print("Reset: {} -- CHWST SP: {} -- CHW DP SP: {}".format(sp, chw_set, dp_set))
        self.current_sp = [chw_set, dp_set]


class HwReset(Reset):
    def __init__(self, measurements, config):
        """
        Trim and respond DAT Reset
        """
        super().__init__(config)
        self.name = config.pop('name', "reset")
        try:
            self.request1 = config.pop("request1")
        except KeyError:
            self.request1 = 2.0
        try:
            self.request2 = config.pop("request2")
        except KeyError:
            self.request2 = 3.0
        try:
            self.htg_request_thr = config.pop("htg_request_thr")
        except KeyError:
            self.htg_request_thr = 0.95
        try:
            self.occupancy_name = config.pop("occupancy_name")
        except KeyError:
            self.occupancy_name = 'hva_floor1_readAhu_occ_y'
        self.sat_sp = {}
        self.htg_signal = {}
        self.sat = {}
        self.device_list = []
        self.device_htg_req = {}
        self.validate(measurements, config)

    def validate(self, measurements, config):
        self.device_list = list(config.keys())
        self.device_htg_req = dict.fromkeys(self.device_list, False)
        for device, device_info in config.items():
            for name, point in device_info.items():
                if name == "heating_signal":
                    self.htg_signal[device] = point
                elif name == "supply_temperature_setpoint":
                    self.sat_sp[device] = point
                elif name == "supply_temperature":
                    self.sat[device] = point

    def generate_clg_requests(self, device_name, htg_signal, sat, sat_sp):
        htg_requests = 0
        if (sat is not None and sat_sp is not None) and sat_sp - sat > self.request2:
            htg_requests = 3
        elif (sat is not None and sat_sp is not None) and sat_sp - sat > self.request1:
            htg_requests = 2
        elif htg_signal > self.htg_request_thr:
            htg_requests = 1
            self.device_htg_req[device_name] = True
        elif self.device_htg_req[device_name] and htg_signal > self.htg_request_thr - 0.1:
            htg_requests = 1
        else:
            self.device_htg_req[device_name] = False
        return htg_requests

    def check_requests(self, measurements):
        htg_requests = 0
        for device in self.device_list:
            if device in self.sat and device in self.sat_sp:
                sat = measurements[self.sat[device]]
                sat_sp = measurements[self.sat_sp[device]]
            else:
                sat = None
                sat_sp = None
            htg_signal = measurements[self.htg_signal[device]]

            print("name: {} - device {} -- occ {} -- max_sp: {} -- sat: {} -- sat_sp: {} -- htg: {}".format(self.name, device, self.occupancy, self.max_sp, sat, sat_sp, htg_signal))
            htg_temp = self.generate_clg_requests(device, htg_signal, sat, sat_sp)
            print("AHU: {} -- sat requests: {}".format(device, htg_temp))
            htg_requests += htg_temp
        _requests = htg_requests
        print("HW requests: {}".format(_requests))
        return _requests

    def update(self, measurements):
        self.occupancy = int(measurements[self.occupancy_name])


class StaticPressureReset(Reset):
    def __init__(self, measurements, config):
        """
        Trim and respond DAT Reset
        """
        super().__init__(config)
        self.name = config.pop('name', "reset")
        try:
            self.request1 = config.pop("request1")
        except KeyError:
            self.request1 = 0.7
        try:
            self.request2 = config.pop("request2")
        except KeyError:
            self.request2 = 0.5
        try:
            self.dmp_request_thr = config.pop("dmpr_request_thr")
        except KeyError:
            self.dmp_request_thr = 0.95
        try:
            self.occupancy_name = config.pop("occupancy_name")
        except KeyError:
            self.occupancy_name = 'hva_floor1_readAhu_occ_y'

        self.airflow_sp = {}
        self.airflow = {}
        self.dmpr = {}
        self.zone_list = []
        self.device_stcpr_req = {}
        self.validate(measurements, config)

    def validate(self, measurements, config):
        self.zone_list = list(config.keys())
        self.device_stcpr_req = dict.fromkeys(self.zone_list, False)
        for zone, zone_info in config.items():
            for name, point in zone_info.items():
                if name == "damper_command":
                    self.dmpr[zone] = point
                elif name == "airflow":
                    self.airflow[zone] = point
                elif name == "airflow_setpoint":
                    self.airflow_sp[zone] = point

    def generate_requests(self, device_name, dmpr, airflow_fraction):
        stcpr_requests = 0
        if dmpr >= self.dmp_request_thr:
            if airflow_fraction < self.request2:
                stcpr_requests = 3
            elif airflow_fraction < self.request1:
                stcpr_requests = 2
            else:
                stcpr_requests = 1
            self.device_stcpr_req[device_name] = True
        elif self.device_stcpr_req[device_name] and dmpr > self.dmp_request_thr - 0.1:
            stcpr_requests = 1
        else:
            self.device_stcpr_req[device_name] = False
        return stcpr_requests

    def check_requests(self, measurements):
        _requests = 0
        stcpr_requests = 0
        for device_name in self.zone_list:
            temp = 0
            dmpr = measurements[self.dmpr[device_name]]
            airflow = measurements[self.airflow[device_name]]
            airflow_sp = measurements[self.airflow_sp[device_name]]
            airflow_fraction = max(0., min(1., airflow/airflow_sp))
            print("name: {} - zone {} -- occ {} -- dmpr: {} -- airflow_fraction: {}".format(self.name, device_name, self.occupancy, dmpr, airflow_fraction))
            _requests = self.generate_requests(device_name, dmpr, airflow_fraction)
            print("AHU: {} -- stpr requests: {}".format(device_name, _requests))
            stcpr_requests += _requests
        print("Total stcpr requests: {}".format(stcpr_requests))
        return stcpr_requests

    def update(self, measurements):
        self.occupancy = int(measurements[self.occupancy_name])


class VentilationController:
    def __init__(self, config):
        self.zones = {}
        # need damper or OA fraction for zones
        self.controller = {}
        self.occupancy_name = config.get('occupancy_name', 'hva_floor1_readAhu_occ_y')
        self.control = config["control"]
        self.activate = config["activate"]
        self.oad_name = config.get("oad_name")
        self.max_oa = config.get("max_oa")
        self.oa_setpoint = 0.0
        zones = config.get("zones", {})
        for name, info in zones.items():
            self.zones[name] = Zone(info, name)

    def update(self, y):
        occ = y[self.occupancy_name]
        if occ:
            damper = y[self.oad_name]
            for zone, cls in self.zones.items():
                cls.update(y, damper)
            zp = max([cls.zp for cls in self.zones.values()])
            vps = sum([cls.vps for cls in self.zones.values()])
            vou = sum([cls.voa_required for cls in self.zones.values()])
            ev = 1.0 + (vou/vps) - zp
            self.oa_setpoint = min(vou/ev, self.max_oa)
            for zone, cls in self.zones.items():
                self.controller[cls.control] = cls.vcontrol
                self.controller[cls.activate] = 1
            self.controller[self.control] = self.oa_setpoint
            self.controller[self.activate] = 1
        else:
            for zone, cls in self.zones.items():
                self.controller[cls.control] = 0
                self.controller[cls.activate] = 0
            self.controller[self.control] = 0
            self.controller[self.activate] = 0


class Zone(object):
    def __init__(self, zone_info, name):
        self.name = name
        self.zp = 0.0
        self.vps = 0.0
        self.vou = 0.
        self.voz = 0.0
        self.vop_star = 0.0
        self.co2 = 0.0
        self.vcontrol = 0
        self.voa_required = 0.0
        self.control = zone_info["control"]
        self.activate = zone_info["activate"]
        co2_sp = zone_info.get("co2_setpoint", 1000.0)
        self.max_af = zone_info['max_airflow']
        self.af_name = zone_info['airflow']
        self.co2_name = zone_info['co2']
        self.voa_area = zone_info['voa_area']
        pid_low_sp = zone_info.get("co2_low_pid", -200)
        pid_high_sp = zone_info.get("co2_high_pid", 0.0)
        voa_p = zone_info['voa_people']
        self.voa_p = np.linspace(0.0, voa_p, 101)
        self.co2_bounds = np.linspace(co2_sp+pid_low_sp, co2_sp+pid_high_sp, 101)
        self.p = np.linspace(0, 100, 101)

    def update(self, y, damper):
        self.co2 = y[self.co2_name]
        self.vps = y[self.af_name]
        p = np.interp(self.co2, self.co2_bounds, self.p)
        self.vop_star = np.interp(p, self.p, self.voa_p)
        self.voz = self.voa_area + self.vop_star
        self.zp = self.voz/self.vps
        if damper < 1.0:
            self.voa_required = 1.5*self.voz
        else:
            self.voa_required = self.voz
        min_af = np.linspace(self.voa_required, self.max_af, 101)
        self.vcontrol = np.interp(p, self.p, min_af)
        print("Ventilation zone: {} -- co2: {} -- P: {} --voz: {} -- zp: {} -- voa: {} -- min_af: {} -- vcontrol: {}".format(self.name, self.co2, p, self.voz, self.zp, self.voa_required, min_af, self.vcontrol))



