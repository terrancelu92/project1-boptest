# -*- coding: utf-8 -*-
"""
This module sets the zone air temperatures for testcase multizone_large_office_eplus.

"""
import pandas as pd

def compute_control(y, forecasts):
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
    
    try:
        TDryBul = forecasts['TDryBul'].values[-1]
        HGloHor = forecasts['HGloHor'].values[-1]
        PriceElectricPower = forecasts['PriceElectricPowerHighlyDynamic'].values[-1]

    except KeyError:
        raise KeyError("Temperature values ['TDryBul', 'HGloHor','PriceElectricPowerHighlyDynamic'] not in forecasts: {0}".format(forecasts.columns))
    
    
    
    HourOfDay = int((y['time']%86400)/3600)
    
    if (HourOfDay<=6)|(HourOfDay>21):
        if TDryBul>28:
            TZonAir = 273.15+26
        else:
            TZonAir = 273.15+25
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

def get_forecast_parameters():
    """Get forecast parameters within the controller.

    Returns
    -------
    forecast_parameters: dict
        {'point_names':[<string>],
         'horizon': <int>,
         'interval': <int>}

    """
        
    forecast_parameters = {'point_names':['TDryBul',
                                          'HGloHor',
                                          'PriceElectricPowerHighlyDynamic'],
                           'horizon': 3600,
                           'interval': 300}


    return forecast_parameters

def update_forecasts(forecast_data, forecasts):
    """Update forecast_store within the controller.

    This controller only uses the first timestep of the forecast for upper
    and lower temperature limits.


    Parameters
    ----------
    forecast_data: dict
        Dictionary of arrays with forecast data from BOPTEST
        {<point_name1: [<data>]}
    forecasts: DataFrame
        DataFrame of forecast values used over time.

    Returns
    -------
    forecasts: DataFrame
        Updated DataFrame of forcast values used over time.

    """

    forecast_config = get_forecast_parameters()['point_names']

    if forecasts is None:
        forecasts = pd.DataFrame(columns=forecast_config)
    for i in forecast_config:
        t = forecast_data['time'][0]
        forecasts.loc[t,i] = forecast_data[i][0]

    return forecasts



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
