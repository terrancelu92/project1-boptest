# -*- coding: utf-8 -*-
"""
This script demonstrates a minimalistic example of testing a feedback controller
using the scenario options with the prototype test case called "testcase1".

"""
"""
This script demonstrates a minimalistic example of testing a feedback controller
with the prototype test case called "testcase1".  It uses the testing
interface implemented in interface.py and the concrete controller implemented
in controllers/pid.py.

"""

# GENERAL PACKAGE IMPORT
# ----------------------
import sys
import os
sys.path.insert(0, os.path.sep.join(os.path.dirname(os.path.abspath(__file__)).split(os.path.sep)[:-2]))
from examples.python.interface import control_test


def run(plot=False):
    """Run test case.
    Parameters
    ----------
    plot : bool, optional
        True to plot timeseries results.
        Default is False.

    Returns
    -------
    kpi : dict
        Dictionary of core KPI names and values.
        {kpi_name : value}
    res : dict
        Dictionary of trajectories of inputs and outputs.
    custom_kpi_result: dict
        Dictionary of tracked custom KPI calculations.
        Empty if no customized KPI calculations defined.

    """

    # RUN THE CONTROL TEST
    # --------------------
    control_module = 'examples.python.controllers.baselines'
    scenario = {'time_period': 'peak_heat_day', 'electricity_price': 'dynamic'}
    step = 300
    # ---------------------------------------

    # RUN THE CONTROL TEST
    # --------------------
    kpi, df_res, custom_kpi_result, forecasts = control_test(control_module,
                                                             scenario=scenario,
                                                             step=step)



    return kpi, df_res


if __name__ == "__main__":
    kpi, df_res = run()