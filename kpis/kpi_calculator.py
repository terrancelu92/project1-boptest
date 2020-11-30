'''
Created on Apr 25, 2019

@author: Javier Arroyo

This module contains the KPI_Calculator class with methods for processing 
the results of BOPTEST simulations and generating the corresponding key 
performance indicators.

'''

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
from scipy.integrate import trapz
from flask._compat import iteritems
from collections import OrderedDict
import scipy.interpolate as interpolate

class KPI_Calculator(object):
    '''This class calculates the KPIs as a post-process after 
    a test is complete. Upon deployment of the test case, 
    the module first uses the KPI JSON file to 
    associate model output names with the appropriate KPIs 
    through the specified KPI annotations. Upon called to 
    do so, the module is able to calculate and return the 
    KPIs using data stored from the test case run.
    The core KPIs are a subset of the KPIs that can be 
    obtained using this class and that are considered 
    essential for the comparison between two or more 
    test cases. This class also supports other methods for
    evaluation, plotting and post-processing of an already
    deployed test case.  
    
    ''' 

    def __init__(self, testcase):
        '''Initialize the KPI_Calculator class. One KPI_Calculator
        is associated with one test case.
        
        Parameters
        ----------
        testcase: BOPTEST TestCase object
            object of an already deployed test case that
            contains the data stored from the test case run
        
        '''
        
        # Point to the test case object
        self.case = testcase
        
        # Naming convention from the signal exchange package of IBPSA
        #Add EquipmentEfficiency, EquimentOnOff
        self.sources = ['AirZoneTemperature',
                        'RadiativeZoneTemperature',
                        'OperativeZoneTemperature',
                        'RelativeHumidity',
                        'CO2Concentration',
                        'ElectricPower',
                        'DistrictHeatingPower',
                        'GasPower',
                        'BiomassPower',
                        'SolarThermalPower', 
                        'FreshWaterFlowRate']
        
        # initialize the data buffer
        self.data_buff=None
        
        #Occupancy start hour and end hour
        self.start_Occ = 6
        self.end_Occ = 19
    
    def get_core_kpis(self, runtime_KPI=False, price_scenario='Constant'):
        '''Return the core KPIs of a test case.
        
        Parameters
        ----------
        price_scenario : str, optional
            Price scenario for cost kpi calculation.  
            'Constant' or 'Dynamic' or 'HighlyDynamic'.
            Default is 'Constant'.
            
        Returns 
        -------
        ckpi = dict
            Dictionary with the core KPIs, i.e., the KPIs
            that are considered essential for the comparison between
            two test cases
            
        '''
        ckpi = OrderedDict()
        if runtime_KPI:
            # Runtime KPIs
            ckpi['cost_tot'] = self.get_cost(runtime_KPI,scenario=price_scenario) 
        else:
            # Postprocessing KPIs
            ckpi['tdis_tot'] = self.get_thermal_discomfort(runtime_KPI)
            ckpi['timdis_tot']=self.get_unmet_hour(runtime_KPI)
            ckpi['dT_max_dict']=self.get_max_temperature_deviation(runtime_KPI)
            ckpi['idis_tot'] = self.get_iaq_discomfort(runtime_KPI)
            ckpi['ener_tot'] = self.get_energy(runtime_KPI)
            ckpi['cost_tot'] = self.get_cost(runtime_KPI,scenario=price_scenario)
            ckpi['emis_tot'] = self.get_emissions(runtime_KPI)        
            ckpi['pow_dvf'] = self.get_diversity_factor(runtime_KPI)
            ckpi['pow_peak'] = self.get_power_peaks(runtime_KPI)

        return ckpi

    def interp(self, t_old,x_old,t_new,columns):
        #Return the interpolated dataframe
        
    	intp = interpolate.interp1d(t_old, x_old, kind='linear')
    	x_new = intp(t_new)
    	x_new = pd.DataFrame(x_new, index=t_new, columns=columns)
    	return x_new

    def filter_Occ(self, index, narray):
        '''Return the array after filtering out the non-operation data
        
        Parameters
        ----------
        index: Original time array
        array: Original array of the variable 
        Returns 
        -------
        array_Occ: Filtered array of the variable
        '''
        index_Occ_remainder=np.array(index)/3600%24
        array_Occ=narray[np.logical_and(index_Occ_remainder>=self.start_Occ, \
                                       index_Occ_remainder<=self.end_Occ)]
        return array_Occ
        
    def get_thermal_discomfort(self, runtime_KPI=False, plot=False):
        '''The thermal discomfort is the integral of the deviation 
        of the temperature with respect to the predefined comfort 
        setpoint. Its units are of K*h.
        
        Parameters
        ----------
        plot: boolean, optional
            True to show a donut plot with the thermal discomfort metrics.
            Default is False.
            
        Returns
        -------
        tdis_tot: float
            total thermal discomfort accounted in this test case

        '''
        if runtime_KPI:
            self.data_buff=self.case.y_store_step
        else:
            self.data_buff=self.case.y_store
        
        index=self.data_buff['time']
        
        tdis_tot = 0
        tdis_dict = OrderedDict()
        
        for source in self.case.kpi_json.keys():
            if source.startswith('AirZoneTemperature') or \
               source.startswith('OperativeZoneTemperature'):
                # This is a potential source of thermal discomfort
                zone_id = source.split('[')[1][:-1]
                
                for signal in self.case.kpi_json[source]:
                    # Load temperature set points from test case data
                    LowerSetp = np.array(self.case.data_manager.get_data(index=index)
                                     ['LowerSetp[{0}]'.format(zone_id)])
                    UpperSetp = np.array(self.case.data_manager.get_data(index=index)
                                     ['UpperSetp[{0}]'.format(zone_id)])                     
                    data = np.array(self.data_buff[signal])
                    dT_lower = LowerSetp - data
                    dT_lower[dT_lower<0]=0
                    dT_upper = data - UpperSetp
                    dT_upper[dT_upper<0]=0
                    tdis_dict[signal[:-1]+'dTlower_y'] = \
                        trapz(dT_lower,self.data_buff['time'])/3600.
                    tdis_dict[signal[:-1]+'dTupper_y'] = \
                        trapz(dT_upper,self.data_buff['time'])/3600.
                    tdis_tot = tdis_tot + \
                              tdis_dict[signal[:-1]+'dTlower_y'] + \
                              tdis_dict[signal[:-1]+'dTupper_y']
        
        self.case.tdis_tot  = tdis_tot
        self.case.tdis_dict = tdis_dict
            
        if plot:
            self.case.tdis_tree = self.get_dict_tree(tdis_dict)
            self.plot_nested_pie(self.case.tdis_tree, metric='discomfort',
                                 units='Kh', breakdonut=False)
        
        return tdis_tot


    def get_max_temperature_deviation(self, runtime_KPI=False):
        '''The maximum deviation of temperature unmet in the operating hours 
       is maximum absolute value of the lower bound temperature deviation and
       the upper bound temperature deviation.Its units is of K. The occur time is in the unit of s.
        
        Parameters
        ----------
        plot: boolean, optional
            True to show a donut plot with the thermal discomfort metrics.
            Default is False.
            
        Returns
        -------
        dT_max_dict: dictionary 
            dictionary of the maximum deviation of temperature unmet for different signals
            each item is a tuple:(maximum temperature deviation, occur time)
        '''
        if runtime_KPI:
            self.data_buff=self.case.y_store_step
        else:
            self.data_buff=self.case.y_store
        
        index=self.data_buff['time']
        
        
        dT_max_dict = OrderedDict()
        

        for source in self.case.kpi_json.keys():
            if source.startswith('AirZoneTemperature') or \
               source.startswith('OperativeZoneTemperature'):
                # This is a potential source of thermal discomfort
                zone_id = source.split('[')[1][:-1]
                
                for signal in self.case.kpi_json[source]:
                    # Load temperature set points from test case data
                    LowerSetp = np.array(self.case.data_manager.get_data(index=index)
                                     ['LowerSetp[{0}]'.format(zone_id)])
                    UpperSetp = np.array(self.case.data_manager.get_data(index=index)
                                     ['UpperSetp[{0}]'.format(zone_id)])                     
                    data = np.array(self.data_buff[signal])
                    dT_lower = LowerSetp - data
                    dT_upper = data - UpperSetp

                    # Filter the temperature deviation dataframe to the occupancy hour
                    index_Occ=self.filter_Occ(index, np.array(index))
                    dT_lower_Occ=self.filter_Occ(index, dT_lower)
                    dT_upper_Occ=self.filter_Occ(index, dT_upper)
                    #Calculate the maximum lower bound temperature deviation and occur time
                    dT_lower_max=max(dT_lower_Occ)
                    tim_lower_max=index_Occ[dT_lower_Occ==max(dT_lower_Occ)].tolist()
                    #Calculate the maximum upper bound temperature deviation and occur time
                    dT_upper_max=max(dT_upper_Occ)
                    tim_upper_max=index_Occ[dT_upper_Occ==max(dT_upper_Occ)].tolist()
                    #Calculate the overall maximum temperature deviation and occur time
                    dT_max=max(dT_lower_max,dT_upper_max)
                    tim_dT_max=tim_lower_max if dT_lower_max>dT_upper_max else tim_upper_max
                    #Tuple of (maximum temperature deviation, occur time)
                    dT_max_dict[signal[:-1]+'[dT_max,tim_dT_max]']=(dT_max,tim_dT_max)
                    
        self.case.dT_max_dict = dT_max_dict
            
        return dT_max_dict    

    
    
    def get_unmet_hour(self, runtime_KPI=False, plot=False):
        '''The unmet hours are the sum of the operating hours 
        of which the temperature is outside the predefined comfort 
        setpoint. Its units are of h. This function can also give unmet fraction,
        that is the ratio of the unmet hours and the total operating hours
        
        Parameters
        ----------
        plot: boolean, optional
            True to show a donut plot with the thermal discomfort metrics.
            Default is False.
            
        Returns
        -------
        tim_unmet_tot: float
            total unmet hour accounted in this test case

        '''
        if runtime_KPI:
            self.data_buff=self.case.y_store_step
        else:
            self.data_buff=self.case.y_store
        
        index=self.data_buff['time']
        
        tim_unmet_tot = 0
        tim_unmet_dict = OrderedDict()
        

        for source in self.case.kpi_json.keys():
            if source.startswith('AirZoneTemperature') or \
               source.startswith('OperativeZoneTemperature'):
                # This is a potential source of thermal discomfort
                zone_id = source.split('[')[1][:-1]
                
                for signal in self.case.kpi_json[source]:
                    # Load temperature set points from test case data
                    LowerSetp = np.array(self.case.data_manager.get_data(index=index)
                                     ['LowerSetp[{0}]'.format(zone_id)])
                    UpperSetp = np.array(self.case.data_manager.get_data(index=index)
                                     ['UpperSetp[{0}]'.format(zone_id)])                     
                    data = np.array(self.data_buff[signal])
                    dT_lower = LowerSetp - data
                    dT_upper = data - UpperSetp

                    
                    # Filter the temperature deviation dataframe to the occupancy hour
                    index_Occ=self.filter_Occ(index, np.array(index))
                    dT_lower_Occ=self.filter_Occ(index, dT_lower)
                    dT_upper_Occ=self.filter_Occ(index, dT_upper)
                        
                    #Resample to 1-minute data
                    index_Occ_new=np.arange(index_Occ[0], index_Occ[-1]+1, 60)
                    index_Occ_new=self.filter_Occ(index_Occ_new, index_Occ_new)
                    df_dT_lower_Occ = self.interp(index_Occ, dT_lower_Occ, index_Occ_new,['dT_lower_Occ'])
                    df_dT_upper_Occ = self.interp(index_Occ, dT_upper_Occ, index_Occ_new,['dT_upper_Occ'])
                    
                    #Calculate the unmet hour for the outer-lower and outer-upper bounds
                    tim_unmet_dict[signal[:-1]+'timlower_y'] = \
                        float(df_dT_lower_Occ[df_dT_lower_Occ['dT_lower_Occ']>0].count())/60.
                    tim_unmet_dict[signal[:-1]+'timupper_y'] = \
                        float(df_dT_upper_Occ[df_dT_upper_Occ['dT_upper_Occ']>0].count())/60.
                    tim_Occ_tot =len(index_Occ_new)/60
                    tim_unmet_tot = tim_unmet_tot + \
                              tim_unmet_dict[signal[:-1]+'timlower_y'] + \
                              tim_unmet_dict[signal[:-1]+'timupper_y']
                              
        self.case.tim_Occ_tot=tim_Occ_tot                     
        self.case.tim_unmet_tot  = tim_unmet_tot
        self.case.unmet_fraction=round(tim_unmet_tot/tim_Occ_tot,3)
        self.case.tim_unmet_dict = tim_unmet_dict
            
        if plot:
            self.case.tim_unmet_tree = self.get_dict_tree(tim_unmet_dict)
            self.plot_nested_pie(self.case.tim_unmet_tree, metric='discomfort',
                                 units='hour', breakdonut=False)
        
        return tim_unmet_tot    
    
        
    def get_iaq_discomfort(self, runtime_KPI=False, plot=False):
        '''The IAQ discomfort is the integral of the deviation 
        of the CO2 concentration with respect to the predefined comfort 
        setpoint. Its units are of ppm*h.
        
        Parameters
        ----------
        plot: boolean, optional
            True to show a donut plot with the iaq discomfort metrics.
            Default is False.
            
        Returns
        -------
        idis_tot: float
            total IAQ discomfort accounted in this test case

        '''
        if runtime_KPI:
            self.data_buff=self.case.y_store_step
        else:
            self.data_buff=self.case.y_store
            
        index=self.data_buff['time']
        
        idis_tot = 0
        idis_dict = OrderedDict()
        
        for source in self.case.kpi_json.keys():
            if source.startswith('CO2Concentration'):
                # This is a potential source of iaq discomfort
                zone_id = source.replace('CO2Concentration[','')[:-1]
                
                for signal in self.case.kpi_json[source]:
                    # Load CO2 set points from test case data
                    UpperSetp = np.array(self.case.data_manager.get_data(index=index)
                                     ['UpperCO2[{0}]'.format(zone_id)])                     
                    data = np.array(self.data_buff[signal])
                    dI_upper = data - UpperSetp
                    dI_upper[dI_upper<0]=0
                    idis_dict[signal[:-1]+'dIupper_y'] = \
                        trapz(dI_upper,self.data_buff['time'])/3600.
                    idis_tot = idis_tot + \
                              idis_dict[signal[:-1]+'dIupper_y']
        
        self.case.idis_tot  = idis_tot
        self.case.idis_dict = idis_dict
            
        if plot:
            self.case.idis_tree = self.get_dict_tree(idis_dict)
            self.plot_nested_pie(self.case.idis_tree, metric='IAQ discomfort',
                                 units='ppmh', breakdonut=False)
        
        return idis_tot
    
    def get_energy(self,runtime_KPI=False,  plot=False, plot_by_source=False):
        '''This method returns the measure of the total building 
        energy use in kW*h when accounting for the sum of all 
        energy vectors present in the test case. 
        
        Parameters
        ----------
        plot: boolean, optional
            True to show a donut plot with the energy use 
            grouped by elements.
            Default is False.
        plot_by_source: boolean, optional
            True to show a donut plot with the energy use 
            grouped by sources.
            Default is False.
               
        Returns
        -------
        ener_tot: float
            total energy use
            
        '''
        if runtime_KPI:
            self.data_buff=self.case.y_store_step
        else:
            self.data_buff=self.case.y_store
            
        ener_tot = 0
        # Dictionary to store energy usage by element
        ener_dict = OrderedDict()
        # Dictionary to store energy usage by source 
        ener_dict_by_source = OrderedDict()
        
        # Calculate total energy from power 
        # [returns KWh - assumes power measured in Watts]
        for source in self.sources:
            if 'Power' in source  and \
            source in self.case.kpi_json.keys():            
                for signal in self.case.kpi_json[source]:
                    pow_data = np.array(self.data_buff[signal])
                    ener_dict[signal] = \
                        trapz(pow_data,
                              self.data_buff['time'])*2.77778e-7 # Convert to kWh
                    ener_dict_by_source[source+'_'+signal] = \
                        ener_dict[signal]
                    ener_tot = ener_tot + ener_dict[signal]
                    
        # Assign to case       
        self.case.ener_tot            = ener_tot
        self.case.ener_dict           = ener_dict
        self.case.ener_dict_by_source = ener_dict_by_source
           
        if plot:
            self.case.ener_tree = self.get_dict_tree(ener_dict) 
            self.plot_nested_pie(self.case.ener_tree, metric='energy use',
                                 units='kWh')
        if plot_by_source:
            self.case.ener_tree_by_source = self.get_dict_tree(ener_dict_by_source) 
            self.plot_nested_pie(self.case.ener_tree_by_source, 
                                 metric='energy use by source', units='kWh')
        
        return ener_tot
    
    def get_cost(self,runtime_KPI=False,  scenario='Constant', plot=False,
                 plot_by_source=False):
        '''This method returns the measure of the total building operational
        energy cost in euros when accounting for the sum of all energy
        vectors present in the test case as well as other sources of cost
        like water. 
        
        Parameters
        ----------
        scenario: string, optional
            There are three different scenarios considered for electricity:
            1. 'Constant': completely constant price
            2. 'Dynamic': day/night tariff
            3. 'HighlyDynamic': spot price changing every 15 minutes.
            Default is 'Constant'.
        plot: boolean, optional
            True to show a donut plot with the operational cost 
            grouped by elements.
            Default is False.
        plot_by_source: boolean, optional
            True to show a donut plot with the operational cost 
            grouped by sources.
            Default is False.
            
        Notes
        -----
        It is assumed that power is measured in Watts and water usage in m3
            
        '''
        if runtime_KPI:
            self.data_buff=self.case.y_store_step
        else:
            self.data_buff=self.case.y_store
            
        cost_tot = 0
        # Dictionary to store operational cost by element
        cost_dict = OrderedDict()
        # Dictionary to store operational cost by source 
        cost_dict_by_source = OrderedDict()
        # Define time index
        index=self.data_buff['time']
        
        for source in self.sources:
            
            # Calculate the operational cost from electricity in this scenario
            if 'ElectricPower' in source  and \
            source in self.case.kpi_json.keys(): 
                # Load the electricity price data of this scenario    
                electricity_price_data = \
                np.array(self.case.data_manager.get_data(index=index)\
                         ['Price'+source+scenario])       
                for signal in self.case.kpi_json[source]:
                    pow_data = np.array(self.data_buff[signal])
                    cost_dict[signal] = \
                        trapz(np.multiply(electricity_price_data,pow_data),
                              self.data_buff['time'])*2.77778e-7 # Convert to kWh
                    cost_dict_by_source[source+'_'+signal] = \
                        cost_dict[signal]
                    cost_tot = cost_tot + cost_dict[signal]
                    
            # Calculate the operational cost from other power sources        
            elif 'Power' in source  and \
            source in self.case.kpi_json.keys(): 
                # Load the source price data
                source_price_data = \
                np.array(self.case.data_manager.get_data(index=index)\
                         ['Price'+source])            
                for signal in self.case.kpi_json[source]:
                    pow_data = np.array(self.data_buff[signal])
                    cost_dict[signal] = \
                        trapz(np.multiply(source_price_data,pow_data),
                              self.data_buff['time'])*2.77778e-7 # Convert to kWh
                    cost_dict_by_source[source+'_'+signal] = \
                        cost_dict[signal]
                    cost_tot = cost_tot + cost_dict[signal]       
                    
            # Calculate the operational cost from other sources        
            elif 'FreshWater' in source  and \
            source in self.case.kpi_json.keys(): 
                # load the source price data
                source_price_data = \
                np.array(self.case.data_manager.get_data(index=index)\
                         ['Price'+source])            
                for signal in self.case.kpi_json[source]:
                    pow_data = np.array(self.data_buff[signal])
                    cost_dict[signal] = \
                        trapz(np.multiply(source_price_data,pow_data),
                              self.data_buff['time'])
                    cost_dict_by_source[source+'_'+signal] = \
                        cost_dict[signal]
                    cost_tot = cost_tot + cost_dict[signal]                      
                    
        # Assign to case       
        self.case.cost_tot            = cost_tot
        self.case.cost_dict           = cost_dict
        self.case.cost_dict_by_source = cost_dict_by_source
        
        if plot:
            self.case.cost_tree = self.get_dict_tree(cost_dict) 
            self.plot_nested_pie(self.case.cost_tree, metric='cost',
                                 units='euros')
        if plot_by_source:
            self.case.cost_tree_by_source = self.get_dict_tree(cost_dict_by_source) 
            self.plot_nested_pie(self.case.cost_tree_by_source, 
                                 metric='cost by source', units='euros')
         
        return cost_tot

    def get_emissions(self, runtime_KPI=False, plot=False, plot_by_source=False):
        '''This method returns the measure of the total building 
        emissions in kgCO2 when accounting for the sum of all 
        energy vectors present in the test case. 
        
        Parameters
        ----------
        plot: boolean, optional
            True if it it is desired to make plots related with
            the emission metric.
            Default is False.
        plot_by_source: boolean, optional
            True to show a donut plot with the operational cost 
            grouped by sources.
            Default is False.
            
        Notes
        -----
        It is assumed that power is measured in Watts 
            
        '''
        if runtime_KPI:
            self.data_buff=self.case.y_store_step
        else:
            self.data_buff=self.case.y_store
            
        emis_tot = 0
        # Dictionary to store emissions by element
        emis_dict = OrderedDict()
        # Dictionary to store emissions by source 
        emis_dict_by_source = OrderedDict()
        # Define time index
        index=self.data_buff['time']
        
        for source in self.sources:
            
            # Calculate the operational emissions from power sources        
            if 'Power' in source  and \
            source in self.case.kpi_json.keys(): 
                source_emissions_data = \
                np.array(self.case.data_manager.get_data(index=index)\
                         ['Emissions'+source])            
                for signal in self.case.kpi_json[source]:
                    pow_data = np.array(self.data_buff[signal])
                    emis_dict[signal] = \
                        trapz(np.multiply(source_emissions_data,pow_data),
                              self.data_buff['time'])*2.77778e-7 # Convert to kWh
                    emis_dict_by_source[source+'_'+signal] = \
                        emis_dict[signal]
                    emis_tot = emis_tot + emis_dict[signal]                           
                    
        # Assign to case       
        self.case.emis_tot            = emis_tot
        self.case.emis_dict           = emis_dict
        self.case.emis_dict_by_source = emis_dict_by_source
        
        if plot:
            self.case.emis_tree = self.get_dict_tree(emis_dict) 
            self.plot_nested_pie(self.case.emis_tree, metric='emissions',
                                 units='kgCO2')
        if plot_by_source:
            self.case.emis_tree_by_source = self.get_dict_tree(emis_dict_by_source) 
            self.plot_nested_pie(self.case.emis_tree_by_source, 
                                 metric='emissions by source', units='kgCO2')
         
        return emis_tot

    def get_computational_time_ratio(self,runtime_KPI=False,  plot=False):
        '''Obtain the computational time ratio as the ratio between 
        the average of the elapsed control time and the test case 
        sampling time. The elapsed control time is measured as the 
        time between two emulator simulations. A time counter starts
        at the end of the 'advance' test case method and finishes at 
        the beginning of the following call to the same method. 
        Notice that the accounted time includes not only the 
        controller computational time but also the signal exchange
        time with the controller through the RESTAPI interface. 
        
        Parameters
        ----------
        plot: boolean, optional
            True if it it is desired to make a plot of the elapsed 
            controller time.
            Default is False.
            
        Returns
        -------
        time_rat: float
            computational time ratio of this test case

        '''
        if runtime_KPI:
            self.data_buff=self.case.y_store_step
        else:
            self.data_buff=self.case.y_store
            
        elapsed_control_time = self.case.get_elapsed_control_time()
        elapsed_time_average = np.mean(np.asarray(elapsed_control_time))
        time_rat = elapsed_time_average/self.case.step
        
        self.case.time_rat = time_rat
        
        if plot:
            plt.figure()
            n=len(elapsed_control_time)
            bgn=int(self.case.step)
            end=int(self.case.step + n*self.case.step)
            plt.plot(range(bgn,end,int(self.case.step)),
                     elapsed_control_time)
            plt.show()
            
        return time_rat

    def get_load_factors(self, runtime_KPI=False):
        '''Calculate the load factor for every power signal
        
        '''
        if runtime_KPI:
            self.data_buff=self.case.y_store_step
        else:
            self.data_buff=self.case.y_store
            
        ldfs_dict = OrderedDict()
        
        for signal in self.case.kpi_json['ElectricPower']:
            pow_data = np.array(self.data_buff[signal])
            avg_pow = pow_data.mean()
            max_pow = pow_data.max()
            try:
                ldfs_dict[signal]=avg_pow/max_pow
            except ZeroDivisionError as err:
                print("Error: {0}".format(err))
                return
        
        self.case.ldfs_dict = ldfs_dict
    
        return ldfs_dict
    
    def get_diversity_factor(self, runtime_KPI=False):
        '''Calculate the diversity factor 
        
        '''
        if runtime_KPI:
            self.data_buff=self.case.y_store_step
        else:
            self.data_buff=self.case.y_store
            
        ppks = OrderedDict()
        power_data_tot=0
        
        for signal in self.case.kpi_json['ElectricPower']:
            pow_data = np.array(self.data_buff[signal])
            max_pow = pow_data.max()
            ppks[signal]=max_pow
            power_data_tot=power_data_tot+pow_data
        
        max_pow_tot=power_data_tot.max()
        max_pow=sum(ppks.values())
        try:
            dvf=max_pow/max_pow_tot
        except ZeroDivisionError as err:
            print("Error: {0}".format(err))
            return
        
        self.case.dvf = dvf
    
        return dvf
    
    
    def get_power_peaks(self, runtime_KPI=False):
        '''Calculate the power peak for all the equipment
        
        '''
        if runtime_KPI:
            self.data_buff=self.case.y_store_step
        else:
            self.data_buff=self.case.y_store
            
        power_data_tot=0
        
        for signal in self.case.kpi_json['ElectricPower']:
            pow_data = np.array(self.data_buff[signal])
            power_data_tot=power_data_tot+pow_data
            
        max_pow_tot=power_data_tot.max()
        
        self.case.max_pow_tot = max_pow_tot
            
        return max_pow_tot
    
    def get_equiment_operation_time(self, runtime_KPI=False,  plot=False):
        
        #Calculate the equiment operation time for each equipment. Its unit is h.
        
        if runtime_KPI:
            self.data_buff=self.case.y_store_step
        else:
            self.data_buff=self.case.y_store
            
        tim_equ_ope_dict = OrderedDict()
        
        for signal in self.case.kpi_json['EquipmentOnOff']:
            equ_onoff_data = np.array(self.data_buff[signal])
            tim_equ_ope_dict[signal] = \
                trapz(equ_onoff_data,self.data_buff['time'])/3600.
        
        # Assign to case 
        self.case.tim_equ_ope_dict = tim_equ_ope_dict
              
        if plot:
            self.case.tim_equ_tree = self.get_dict_tree(tim_equ_ope_dict) 
            self.plot_nested_pie(self.case.tim_equ_tree, metric='equipment operation time',
                                 units='hour')
    
        return tim_equ_ope_dict

    def get_maximum_capacity_percentage(self, runtime_KPI=False):
        #Calculate the maximum capacity percentage for each equipment. 
        #Read capacity for each equipment from test resourcedataset. 
        
        if runtime_KPI:
            self.data_buff=self.case.y_store_step
        else:
            self.data_buff=self.case.y_store
            
        # Define time index
        index=self.data_buff['time']            
        cap_per_dict = OrderedDict()
        
        for signal in self.case.kpi_json['ElectricPower']:        
        # Load equipment capacities from test case data
            capcity_data = np.array(self.case.data_manager.get_data(index=index) \
                 ['Capcity_'+signal[-5:-2]])
            pow_data = np.array(self.data_buff[signal])
            try:
                cap_per=pow_data/capcity_data
            except ZeroDivisionError as err:
                print("Error: {0}".format(err))
                return            
            cap_per_dict[signal]=cap_per.max()
            
        self.case.cap_per_dict = cap_per_dict
    
        return cap_per_dict                                    

    def get_average_capacity_percentage(self, runtime_KPI=False):
        #Calculate the average capacity percentage for each equipment. 
        #Read capacity for each equipment from test resourcedataset. 
        
        if runtime_KPI:
            self.data_buff=self.case.y_store_step
        else:
            self.data_buff=self.case.y_store
            
        # Define time index
        index=self.data_buff['time']            
        cap_per_dict = OrderedDict()
        
        for signal in self.case.kpi_json['ElectricPower']:        
        # Load equipment capacities from test case data
            capcity_data = np.array(self.case.data_manager.get_data(index=index) \
                 ['Capcity_'+signal[-5:-2]])
            pow_data = np.array(self.data_buff[signal])
            try:
                cap_per=pow_data/capcity_data
            except ZeroDivisionError as err:
                print("Error: {0}".format(err))
                return            
            cap_per_dict[signal]=cap_per.mean()
            
        self.case.cap_per_dict = cap_per_dict
    
        return cap_per_dict

    def get_average_efficiency_percentage(self, runtime_KPI=False):
        #Calculate the average efficiency for each equipment.  
        
        if runtime_KPI:
            self.data_buff=self.case.y_store_step
        else:
            self.data_buff=self.case.y_store
                     
        eff_dict = OrderedDict()
        
        for signal in self.case.kpi_json['EquipmentEfficiency']:        
        # Load equipment capacities from test case data
            eff_data = np.array(self.data_buff[signal])
            eff_dict[signal]=eff_data.mean()
            
        self.case.eff_dict = eff_dict
    
        return eff_dict
              
    def get_oar_hourly(self, runtime_KPI=False):
        '''The average hourly OAR is the mean of the outdoor air ratio, which is 
        the actual outdoor air volumn and required outdoor air volumn
    
            
        Returns
        -------
        oar_tot: float
            average hourly OAR in this test case

        '''
        if runtime_KPI:
            self.data_buff=self.case.y_store_step
        else:
            self.data_buff=self.case.y_store
        
        index=self.data_buff['time']
        
        oar_tot = 0
        
        # 'vot' and 'voa' are two signals in kpi source 'Ventilation'        
        vot = np.array(self.data_buff['vot'])
        voa = np.array(self.data_buff['voa'])

        # Filter the temperature deviation dataframe to the occupancy hour
        index_Occ=self.filter_Occ(index, np.array(index))
        vot_Occ=self.filter_Occ(index, vot)
        voa_Occ=self.filter_Occ(index, voa)
            
        #Resample to 1-minute data
        index_Occ_new=np.arange(index_Occ[0], index_Occ[-1]+1, 60)
        index_Occ_new=self.filter_Occ(index_Occ_new, index_Occ_new)
        df_vot_Occ = self.interp(index_Occ, vot_Occ, index_Occ_new,['vot_Occ'])
        df_voa_Occ = self.interp(index_Occ, voa_Occ, index_Occ_new,['voa_Occ'])
        
        #Calculate the OAR
        oar_tot = df_voa_Occ['voa_Occ']/df_vot_Occ['vot_Occ']
        #Drop the value where the vot is 0
        oar_tot.replace([np.inf, -np.inf], np.nan, inplace=True)
        oar_tot.dropna(inplace=True) 
        #Calculate the mean OAR        
        oar_tot = oar_tot.mean()
                              
        self.case.oar_tot=oar_tot                     
        
        return oar_tot

                            
    def get_dict_tree(self, dict_flat, sep='_',
                      remove_null=True, merge_branches=True):
        '''This method creates a dictionary tree from a 
        flat dictionary. A dictionary tree is a nested
        dictionary where each element contains other
        dictionaries which keys are the following 
        names of the strings in the keys of the 
        original dictionary and that are separated
        from each other with a 'sep' string case that
        can be specified.
        
        Parameters
        ----------
        dict_flat: dict
            dictionary containing only one layer of
            complexity. This means that the values of
            the dictionary do not contain any other
            dictionaries.
        sep: string, optioanl
            string that indicates different layers in 
            the keys of the original dictionary.
            Default is '_'.
        remove_null: Boolean, optional
            True if we don't want to include the null
            elements in the dictionary tree. These null
            elements create problems when plotting the 
            nested pie chart.
            Default is True.
        merge_branches: Boolean, optional
            Merge the branches where a key has only one value.
            This resolves the problem of getting a plain 
            dictionary with any key containing the 'sep'.
            Default is True.
            
        Returns
        -------
        dict_tree: dict
            nested dictionary with the different layers
            of complexity indicated by the 'sep' string
            in the keys of the original dictionary
            
        '''
        
        # Initialize the dictionary tree
        dict_tree = OrderedDict()
        # Remove the null elements from the flat dictionary
        if remove_null:
            dict_flat = self.remove_null_elements(dict_flat)
        # Each element of the flat dictionary is a branch of the tree
        for element in dict_flat.keys():
            # Create an auxiliary variable to go through the branches of the tree
            actual_layer = dict_tree
            # Read every component in the branch except the last '_y' term
            components = element.split(sep)[:-1]
            # Grow the branch with a new dictionary if not the last component
            for component in components[:-1]:
                # Check if this component is already in this layer
                if component not in actual_layer.keys():
                    # Create a dictionary in this layer to keep growing the branch
                    actual_layer[component]=OrderedDict()
                # Shift the actual layer by one component
                actual_layer = actual_layer[component]
            # If last component, assign the flat dictionary value
            actual_layer[components[-1]] = dict_flat[element]
        
        if merge_branches:
            dict_tree = self.merge_branches(dict_tree,sep=sep)
        
        return dict_tree
    
    def merge_branches(self, dictionary, sep='_'):
        '''Merge the branches where a key has only one value.
        This resolves the problem of getting a plain dictionary
        with any key containing the 'sep' element.
        
        Parameters
        ----------
        dictionary: dict
            dictionary for which we want to merge branches
        sep: string, optional
            string used to merge the key and the value of the
            elements of a dictionary in different layers.
            Default is '_'.
            
        Returns
        -------
        new_dict: dict
            a new dictionary with the branches merged

        '''
        
        for k,v in iteritems(dictionary):
            if isinstance(v, dict):
                if len(dictionary.keys())==1:
                    for vkey in v.keys():
                        dictionary[k+sep+vkey] = v[vkey]
                    dictionary.pop(k)
                 
                self.merge_branches(v)
                
        return dictionary 
    
    def sum_dict(self, dictionary):
        '''This method returns the sum of all values within a 
        nested dictionary that can contain float numbers 
        and/or other dictionaries containing the same type 
        of elements. It works in a recursive way.
        
        Parameters
        ----------
        dictionary: dict or float
            dictionary containing other dictionaries and/or
            float numbers. If it's a float it will return
            its value directly
            
        Returns
        -------    
        val: float
            value of the sum of all values within the 
            nested dictionary

        '''
        
        # Initialize the sum
        val=0.
        # If dictionary is a float we have arrived to an
        # end point and we want to return its value
        if isinstance(dictionary, float):
            
            return dictionary
        
        # If dictionary is still a dictionary we should 
        # keep searching for an end point with a float
        elif isinstance(dictionary, dict):
            for k in dictionary.keys():
                # Sum the values within this dictionary
                val += self.sum_dict(dictionary=dictionary[k])
                
            return val
    
    def count_elements(self, dictionary):
        '''This methods counts the number of end points in 
        a nested dictionary. An end point is considered
        to be a float number instead of a new dictionary
        layer.
        
        Parameters
        ----------
        dictionary: dict
            dictionary for which we want to count the 
            
        Returns
        -------
        n: integer
            number of total end points within the nested
            dictionary

        '''
        
        # Initialize the counter
        n=0
        # If dictionary is a float we have arrived to an
        # end point and we want to sum one element
        if isinstance(dictionary, float):
            
            return 1
        
        # If dictionary is still a dictionary we should 
        # keep searching for an end point 
        elif isinstance(dictionary, dict):
            for k in dictionary.keys():
                # Count the elements within this dictionary
                try:
                    n += self.count_elements(dictionary=dictionary[k])
                except:
                    pass
                
            return n
        
    def remove_null_elements(self, dictionary):
        '''This methods removes the null elements of a 
        plain dictionary
        
        Parameters
        ----------
        dictionary: dict
            dictionary for which we want to remove the null elements 
            
        Returns
        -------
        new_dict: dict
            a new dictionary without the null elements

        '''
        
        new_dict = OrderedDict()
        
        for k,v in iteritems(dictionary):
            if v!=0.: 
                new_dict[k] = dictionary[k]
        
        return new_dict
        
    def parse_color_indexes(self, dictionary, min_index=0, max_index=260):
        '''This method parses the color indexes for a nested pie chart
        and according to the number of elements within the dictionary
        that is going to be plotted. It will provide an equally 
        distributed range of color indexes between a minimum value
        and a maximum value. These indexes can then be used for a 
        matplotlib color map in order to provide an smooth color 
        variation within the chromatic circle. Notice that with 
        min_index and max_index it can be customized the color range
        to be used in the chart. These indexes must lay between the 
        minimum and maximum indexes of the color map used.
        
        Parameters
        ----------
        dictionary: dict
            dictionary for which the pie chart is going to be 
            plotted
        min_index: integer, optional
            minimum value of the index that is going to be used.
            Default is 0.
        max_index: integer, optional
            maximum value of the index that is going to be used.
            Default is 260.
        
        '''
        
        n = self.count_elements(dictionary)
        
        return np.linspace(min_index, max_index, n+1).astype(int)
        
    def plot_nested_pie(self, dictionary, ax=None, radius=1., delta=0.2,
                        dontlabel=None, breakdonut=True, 
                        metric = 'energy use', units = 'kW*h'):
        '''This method appends a pie plot from a nested dictionary
        to an axes of matplotlib object. If all the elements
        of the dictionary are float values it will make a simple
        pie plot with those values. If there are other nested
        dictionaries it will continue plotting them in a nested
        pie plot.
         
        Parameters
        ----------
        dictionary: dict
            dictionary containing other dictionaries and/or
            float numbers for which the pie plot is going to be
            created.
        ax: matplotlib axes object, optional
            axes object where the plot is going to be appended.
            Default is None.
        radius: float, optional
            radius of the outer layer of the pie plot.
            Default is 1.
        delta: float, optional
            desired difference between the radius of two 
            consecutive pie plot layers.
            Default is 0.2.
        dontlabel: list, optional
            list of items to not be labeled for more clarity.
            Default is None.
        breakdonut: boolean, optional
            if true it will not show the non labeled slices.
            Default is True.
        metric: string, optional
            indicates the metric that is being plotted. Notice that
            this is only used for the title of the plot.
            Default is 'energy use'.
        units: string, optional
            indicates the units used for the metric. Notice that
            this is only used for the title of the plot.
            Default is 'kW*h'.
            
        '''
        
        # Initialize the pie plot if not initialized yet
        if ax is None:
            _, ax = plt.subplots()
        if dontlabel is None:
            dontlabel = []
        # Get the color map to be used in this pie
        cmap = plt.get_cmap('rainbow')
        labels=[]
        # Parse the color indexes to be used in this pie
        color_indexes  = self.parse_color_indexes(dictionary)
        # Initialize the color indexes to be used in this layer
        cindexes_layer = [0]
        # Initialize the list of values to plot in this layer
        vals = []
        # Initialize a new dictionary for the next inner layer
        new_dict = OrderedDict()
        # Initialize the shifts for the required indices
        shift = np.zeros(len(dictionary.keys()))
        # Initialize a counter for the loop
        i=0
        # Go through every component in this layer
        for k_outer,v_outer in iteritems(dictionary):
            # Calculate the slice size of this component 
            vals.append(self.sum_dict(v_outer))
            # Append the new label if not end point (if not in dontlabel)
            last_key = k_outer.split('__')[-1]
            label = last_key if not any(k_outer.startswith(dntlbl) \
                                        for dntlbl in dontlabel) else ''
            labels.append(label)
            # Check if this component has nested dictionaries
            if isinstance(v_outer, dict):
                # If it has, add them to the new dictionary
                for k_inner,v_inner in iteritems(v_outer):
                    # Give a unique nested key name to it
                    new_dict[k_outer+'__'+k_inner] = v_inner
            # Check if this component is already a float end point 
            elif isinstance(v_outer, float):
                # If it is, add it to the new dictionary
                new_dict[k_outer] = v_outer
            # Count the number of elements in this component
            n = self.count_elements(v_outer)
            # Append the index of this component according to its
            # number of components in order to follow a progressive
            # chromatic circle
            cindexes_layer.append(cindexes_layer[-1]+n)
            # Make a shift if this is not an end point to do not use
            # the same color as the underlying end points. Make this
            # shift something characteristic of this layer by making
            # use of its radius 
            shift[i] = 0 if n==1 else 60*radius
            # Do not label this slice in the next layer if this was
            # already an end point or a null slice
            if n==1: 
                dontlabel.append(k_outer) 
            # Increase counter
            i+=1
        
        # Assign the colors to every component in this layer
        colors = cmap((color_indexes[[cindexes_layer[:-1]]] + \
                       shift).astype(int))
        
        # If breakdonut=True show a blank in the unlabeled items
        if breakdonut:
            for j,l in enumerate(labels):
                if l is '': colors[j]=[0., 0., 0., 0.]   
                
        # Append the obtained slice values of this layer to the axes
        ax.pie(np.array(vals), radius=radius, labels=labels, 
               labeldistance=radius, colors=colors,
               wedgeprops=dict(width=0.2, edgecolor='w', linewidth=0.3))
        
        # Keep nesting if there is still any dictionary between the values
        if not all(isinstance(v, float) for v in dictionary.values()):
            self.plot_nested_pie(new_dict, ax, radius=radius-delta,
                                 dontlabel=dontlabel, metric=metric, 
                                 units=units)
            
        # Don't continue nesting if all components were float end points 
        else:
            plt.title('Total {metric} = {value:.2f} {units}'.format(\
                metric=metric, value=self.sum_dict(dictionary), units=units))
            # Equal aspect ratio ensures that pie is drawn as a circle
            ax.axis('equal')
            plt.show()
            
if __name__ == "__main__":
    '''Nested pie chart example'''
    ene_dict = {'Heating_damper_y':50.,
                'Heating_HP_pump_y':160.,
                'Heating_pump_y':25.,
                'Cooling_fan_y':80.,
                'Heating_HP_fan_y':30.,
                'Heating_HP_prueba_y':0.,
                'Cooling_pump_y':80.,
                'Lighting_floor_1_zone1_lamp1_y':15.,
                'Lighting_floor_1_zone1_lamp2_y':23.,
                'Lighting_floor_1_zone2_y':87.,
                'Lighting_floor_2_y':37.}  
    
    cal = KPI_Calculator(testcase=None)
    ene_tree = cal.get_dict_tree(ene_dict)
    cal.plot_nested_pie(ene_tree)
    
