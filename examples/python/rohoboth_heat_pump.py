# -*- coding: utf-8 -*-
"""
This script demonstrates a minimalistic example of testing a feedback controller
with the prototype test case called "rohoboth_heat_pump".  It uses the testing
interface implemented in interface.py and the concrete controller implemented
in controllers/rohoboth_heat_pump.py.

"""

# GENERAL PACKAGE IMPORT
# ----------------------
import sys
import os
sys.path.insert(0, '/'.join((os.path.dirname(os.path.abspath(__file__))).split('/')[:-2]))
from examples.python.interface import control_test



def run(plot=False):
    """Run controller test.

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

    # CONFIGURATION FOR THE CONTROL TEST
    # ---------------------------------------
    control_module = 'examples.python.controllers.rohoboth_heat_pump'
    start_time = 180*24*3600
    warmup_period = 0
    length = 1*16*3600
    step = 300
    use_forecast = True
    # ---------------------------------------

    # RUN THE CONTROL TEST
    # --------------------
    kpi, df_res, custom_kpi_result, forecasts = control_test(control_module,
                                                             start_time=start_time,
                                                             warmup_period=warmup_period,
                                                             length=length,
                                                             step=step,
                                                             use_forecast=use_forecast)
    # POST-PROCESS RESULTS
    # --------------------
    time = df_res.index.values/3600  # convert s --> hr
    PCooCoi=df_res['pthp_PCooCoo_y'].values
    TZon=df_res['TZonMea_y'].values
    OccSch=df_res['OccSchMea_y'].values
    # Plot results if needed
    if plot:
        try:
            from matplotlib import pyplot as plt
            import numpy as np
            plt.figure(1)
            plt.title('Zone Temperature')
            plt.plot(time, TZon)
            plt.ylabel('Temperature [C]')
            plt.xlabel('Time [hr]')
            plt.figure(2)
            plt.title('Heat pump cooling power consumption')
            plt.plot(time, PCooCoi)
            plt.ylabel('Power [W]')
            plt.xlabel('Time [hr]')
            plt.show()
        except ImportError:
            print("Cannot import numpy or matplotlib for plot generation")
    # --------------------

    return kpi, df_res


if __name__ == "__main__":
    kpi, df_res = run()
    df_res.to_csv("df_res_rohoboth_heat_pump.csv")
