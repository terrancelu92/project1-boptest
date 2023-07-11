# -*- coding: utf-8 -*-
"""
This module sets the zone air temperatures for testcase multizone_large_office_eplus.

"""


def compute_control(y, forecasts=None):
    """Compute the control input from the measurement.

    Parameters
    ----------
    y : dict
        Contains the current values of the measurements.
        {<measurement_name>:<measurement_value>}
    forecasts : structure depends on controller, optional
        Forecasts used to calculate control.
        Default is None.

    Returns
    -------
    u : dict
        Defines the control input to be used for the next step.
        {<input_name> : <input_value>}

    """
    HourOfDay = int((y['time']%86400)/3600)
    
    if (HourOfDay<=6)|(HourOfDay>21):
        TZonAir = 273.15+28
    elif (HourOfDay>=15) and (HourOfDay<18):
        TZonAir = 273.15+25
    else:
        TZonAir = 273.15+24
    
    # Compute control
    u = {
         'oveTZonCoo_u':TZonAir,
         'oveTZonCoo_activate':1,
         'oveTZonHea_u':273.15+21,
         'oveTZonHea_activate':1
    }

    return u


def initialize():
    """Initialize the control input u.

    Parameters
    ----------
    None

    Returns
    -------
    u : dict
        Defines the control input to be used for the next step.
        {<input_name> : <input_value>}

    """
    TZonAir = 273.15+28
    
    u = {
         'oveTZonCoo_u':TZonAir,
         'oveTZonCoo_activate':1,
         'oveTZonHea_u':273.15+21,
         'oveTZonHea_activate':1
    }

    return u
