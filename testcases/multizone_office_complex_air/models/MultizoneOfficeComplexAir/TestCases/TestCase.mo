﻿within MultizoneOfficeComplexAir.TestCases;
model TestCase "Complex HVAC systems include air side systems, water side systems, and five thermal zones on each floor. "
  extends Modelica.Icons.Example;

  MultizoneOfficeComplexAir.BaseClasses.LoadSide.LoadWrapper loaEPlus(wholebuilding(building(spawnExe="spawn-0.3.0-8d93151657")))
    "Load calculation in EnergyPlus using Spawn, note this version spawn-0.3.0-8d93151657 is specified for BOPTEST environment; 
    Use spawn-0.3.0-0fa49be497 for Buildings library version"
    annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));
  MultizoneOfficeComplexAir.BaseClasses.HVACSide.HVAC hvac(
    floor1(duaFanAirHanUnit(
        mixingBox(mixBox(
            valRet(riseTime=15, y_start=1),
            valExh(riseTime=15, y_start=0),
            valFre(riseTime=15, y_start=0))),
        retFan(VarSpeFloMov(use_inputFilter=true, y_start=0)),
        supFan(variableSpeed(variableSpeed(zerSpe(k=0))), withoutMotor(
              VarSpeFloMov(use_inputFilter=true, y_start=0))),
        cooCoil(val(use_inputFilter=true, y_start=0)))),
    floor2(duaFanAirHanUnit(
        mixingBox(mixBox(
            valRet(riseTime=15, y_start=1),
            valExh(riseTime=15, y_start=0),
            valFre(riseTime=15, y_start=0))),
        retFan(VarSpeFloMov(use_inputFilter=true, y_start=0)),
        supFan(variableSpeed(variableSpeed(zerSpe(k=0))), withoutMotor(
              VarSpeFloMov(use_inputFilter=true, y_start=0))),
        cooCoil(val(use_inputFilter=true, y_start=0)))),
    floor3(duaFanAirHanUnit(
        mixingBox(mixBox(
            valRet(riseTime=15, y_start=1),
            valExh(riseTime=15, y_start=0),
            valFre(riseTime=15, y_start=0))),
        retFan(VarSpeFloMov(use_inputFilter=true, y_start=0)),
        supFan(variableSpeed(variableSpeed(zerSpe(k=0))), withoutMotor(
              VarSpeFloMov(use_inputFilter=true, y_start=0))),
        cooCoil(val(use_inputFilter=true, y_start=0)))))
    "Full HVAC system that contains the plant side and air side"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}})));

equation
  connect(hvac.Occ, loaEPlus.Occ) annotation (Line(points={{11.4,8},{24,8},{24,-48.4},
          {11,-48.4}},           color={0,0,127}));
  connect(loaEPlus.Loa, hvac.loa) annotation (Line(points={{11,-42},{22,-42},{22,
          3},{11.4,3}},       color={0,0,127}));
  connect(loaEPlus.Drybulb, hvac.TDryBul) annotation (Line(points={{11,-34},{20,
          -34},{20,-2},{11.4,-2}}, color={0,0,127}));
  connect(loaEPlus.Wetbulb, hvac.TWetBul) annotation (Line(points={{11,-31},{18,
          -31},{18,-6.85},{11.35,-6.85}},   color={0,0,127}));

  connect(hvac.TZon, loaEPlus.Temp) annotation (Line(points={{-11,0},{-20,0},{-20,
          -40},{-12,-40}},     color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=864000,
      __Dymola_NumberOfIntervals=1440,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
    Documentation(info="<html>


<h3>General</h3>
<p>
    The multi zone office complex air emulator model emulating 
    a large office building with multi-zone VAV systems, chilled 
    water systems, and hot water systems. In the emulator, the 
    Spawn-of-EnergyPlus (Spawn) supports the cosimulation of EnergyPlus 
    and Modelica. EnergyPlus (V9.6) calculates the building’s 
    thermal loads with the boundary conditions. Modelica is responsible 
    for the airflow calculation (e.g., building infiltration) and HVAC system 
    and controls. Spawn integrated model is compiled into Functional Mockup 
    Unit (FMU) using Optimica (V1.40).
</p>
<p align=\\\"center\\\">
    <img alt=\\\"BuildingGeometry.\\\"
    src=\"modelica://MultiZoneOfficeComplexAir/../../doc/images/BuildingGeometry.png\" width=800>
</p>
<h3>Building Design and Use</h3>
<h4>Architecture</h4>
<p>
    The layout is representative of the large commercial office building 
    stock and is consistent with the building prototypes. The test case is 
    located in Chicago, IL and based on the DOE Reference Large Office Building
    Model (Constructed In or After 1980). The geometry of the building is shown
    in the Figure below. The original model has 12 floors with a basement. For 
    simplicity, the middle 10 floors are treated as identical. The ground floor is 
    assumed to be adiabatic with the basement.
</p>
<p>
    The represented floor has five zones, with four perimeter zones and one core zone. 
    Each perimeter zone has a window-to-wall ratio of about 0.38. The height of each 
    zone is 2.74 m and the areas are as follows:
    <ul>
        <li>
        North and South: 313.42 m<sup>2</sup>
        </li>
        <li>
        East and West: 201.98 m<sup>2</sup>
        </li>
        <li>
        Core: 2532.32 m<sup>2</sup>
        </li>
        </ul>
</p>
<p>
    The geometry of the floor is shown as the following figure:
</p>
<p align=\\\"center\\\">
    <img alt=\\\"Zones.\\\"
    src=\"modelica://MultiZoneOfficeComplexAir/../../doc/images/Zones.png\" width=800>
</p>
<h4>Constructions</h4>
<p>
    Opaque constructions: Mass walls; built-up flat roof (insulation above deck); 
    slab-on-grade floor.
</p>
<p>
    Windows: Window-to-wall ratio = 38.0%, equal distribution of windows.
</p>
<p>
    Infiltration: No infiltration.
</p>
<h4>Occupancy and internal loads schedules</h4>
<p>
    The design occupancy density is 0.05 people/m<sup>2</sup>. The number of occupants 
    present in each zone at any time coincides with the internal gain schedule. 
    The occupied time for the HVAC system is between 9:00 and 17:00  each day. 
    The unoccupied time is outside of this period.
</p>
<p>
  The design internal gains include lighting, plug loads, and people. The lighting load is 
  with a radiant-convective-visible split of 70%-10%-20%. The plug load is with a 
  radiant-convective-latent split of 50%-50%-0%. The people load is with a radiant-convective 
  split of 30%-70%. The occupancy and the internal gains are activated according to the 
  schedule in the figure below.
</p>
<p align=\\\"center\\\">
        <img alt=\\\"Schedules.\\\"
        src=\"modelica://MultiZoneOfficeComplexAir/../../doc/images/Schedules.png\" width=800>
</p>

<p>
    The power densities of the internal gains are listed in the following table.
</p>
<table>
    <tr>
    <th>Internal Gains</th>
    <th>Power Density [W/m<sup>2</sup>]</th>
    </tr>
    <tr>
    <td>Lighting</td>
    <td>16.14 </td>
    </tr>
    <tr>
    <td>Plug</td>
    <td>10.76</td>
    </tr>
    <tr>
    <td>People</td>
    <td>xxx</td>
    </tr>
</table>
<h4>Climate data</h4>
<p>
    The weather data is from TMY3 for Chicago O'Hare International Airport.
</p>
<h3>HVAC System Design</h3>
<p>
    The HVAC system of the test case can be categorized into the air-side systems 
    (i.e., variable air volume (VAV) systems) and water-side systems (i.e., a chilled 
    water systems and a hot water system).
</p>
<h4>Air-side system designs</h4>
<p>
    The air-side systems are VAV systems with terminal reheat. Each floor is served 
    by a dedicated AHU and each zone of the test case is served by a dedicated VAV box. 
    The following figure depicts how the VAVs, AHU, and zones are connected on each floor 
    in general. There are two fans (i.e., one supply fan, and one return fan) in the AHU 
    system. A mixing box carries out the economizer function of providing cooling and 
    ventilation. It is noted that no pre-heating coil is installed in the AHU and the 
    heating is provided by the reheat coils in the VAV terminals. 
</p>
<p align=\\\"center\\\">
        <img alt=\\\"AirSide.\\\"
        src=\"modelica://MultiZoneOfficeComplexAir/../../doc/images/AirSide.png\" width=800>
</p>
<h4>Water-side system designs</h4>
<p>
    The water-side systems of the test case include one chilled water system and one hot 
    water system. The chilled water systems composed of three chillers, three cooling 
    towers, a primary chilled water loop with three constant speed pumps, a secondary 
    chilled water loop with two variable speed pumps, and a condenser water loop with 
    three constant speed pumps  . The hot water system consists of two gas boilers and 
    two variable speed pumps. The figure below shows the schematics of the chilled water 
    and hot water systems.
</p>
<p align=\\\"center\\\">
    <img alt=\\\"ChilledWater.\\\"
    src=\"modelica://MultiZoneOfficeComplexAir/../../doc/images/ChilledWater.png\" width=800>
</p>
<p align=\\\"center\\\">
    <img alt=\\\"HotWater.\\\"
    src=\"modelica://MultiZoneOfficeComplexAir/../../doc/images/HotWater.png\" width=800>
</p>
<h4>Equipment specifications</h4>
<p>
    The HVAC sizing in Modelica is determined by the annual simulation results of 
    EnergyPlus. The pressure loop related sizing parameters are estimated using a 
    common HVAC design procedure. The following tables list all the sizing parameters 
    in detail.
</p>
<table>
    <thread>
    <tr>
      <th>VAV&nbsp;&nbsp;&nbsp;terminal with Reheat Coil</th>
      <th>Design Air Flow&nbsp;&nbsp;&nbsp;Rate [m3/s]</th>
      <th>Minimum Damper&nbsp;&nbsp;&nbsp;Position</th>
      <th>Design Reheat&nbsp;&nbsp;&nbsp;Coil Water Flow Rate [m3/s]</th>
      <th>Design Reheat&nbsp;&nbsp;&nbsp;Coil Capacity [W]</th>
      <th>Design Reheat&nbsp;&nbsp;&nbsp;Coil U-Factor Times Area Value [W/K]</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>Bot Floor Core Zone VAV</td>
      <td>10.58</td>
      <td>0.3</td>
      <td>0.000847</td>
      <td>38707</td>
      <td>739.84</td>
    </tr>
    <tr>
      <td>Mid Floor Core Zone VAV</td>
      <td>111.04</td>
      <td>0.3</td>
      <td>0.009274</td>
      <td>423571.79</td>
      <td>8147.27</td>
    </tr>
    <tr>
      <td>Top Floor Core Zone VAV</td>
      <td>10.26</td>
      <td>0.3</td>
      <td>0.003319</td>
      <td>151587.7</td>
      <td>3712.01</td>
    </tr>
    <tr>
      <td>Bot Floor South Zone VAV</td>
      <td>2.21</td>
      <td>0.3</td>
      <td>0.000873</td>
      <td>39859.31</td>
      <td>975.85</td>
    </tr>
    <tr>
      <td>Bot Floor East Zone VAV</td>
      <td>2.03</td>
      <td>0.3</td>
      <td>0.000582</td>
      <td>26573.59</td>
      <td>650.58</td>
    </tr>
    <tr>
      <td>Bot Floor North Zone VAV</td>
      <td>1.55</td>
      <td>0.3</td>
      <td>0.000873</td>
      <td>39858.23</td>
      <td>975.82</td>
    </tr>
    <tr>
      <td>Bot Floor West Zone VAV</td>
      <td>2.13</td>
      <td>0.3</td>
      <td>0.000581</td>
      <td>26544.93</td>
      <td>649.88</td>
    </tr>
    <tr>
      <td>Mid Floor South Zone VAV</td>
      <td>22.51</td>
      <td>0.3</td>
      <td>0.009457</td>
      <td>431922.88</td>
      <td>10574.57</td>
    </tr>
    <tr>
      <td>Mid Floor East Zone VAV</td>
      <td>20.96</td>
      <td>0.3</td>
      <td>0.006232</td>
      <td>284630.34</td>
      <td>6968.46</td>
    </tr>
    <tr>
      <td>Mid Floor North Zone VAV</td>
      <td>15.74</td>
      <td>0.3</td>
      <td>0.009457</td>
      <td>431921.97</td>
      <td>10574.55</td>
    </tr>
    <tr>
      <td>Mid Floor West Zone VAV</td>
      <td>22.22</td>
      <td>0.3</td>
      <td>0.006297</td>
      <td>287581</td>
      <td>7040.71</td>
    </tr>
    <tr>
      <td>Top Floor South Zone VAV</td>
      <td>2.2</td>
      <td>0.3</td>
      <td>0.001301</td>
      <td>59434.84</td>
      <td>1455.18</td>
    </tr>
    <tr>
      <td>Top Floor East Zone VAV</td>
      <td>2.01</td>
      <td>0.3</td>
      <td>0.00085</td>
      <td>38840.84</td>
      <td>950.96</td>
    </tr>
    <tr>
      <td>Top Floor North Zone VAV</td>
      <td>1.6</td>
      <td>0.3</td>
      <td>0.001301</td>
      <td>59434.42</td>
      <td>1455.17</td>
    </tr>
    <tr>
        <td>Top Floor West Zone VAV</td>
        <td>2.23</td>
        <td>0.3</td>
        <td>0.000859</td>
        <td>39244.52</td>
        <td>960.85</td>
      </tr>
  </tbody>
  </table>
  <table>
    <thead>
      <tr>
        <th>AHU&nbsp;&nbsp;&nbsp;Cooling Coils</th>
        <th>Design Inlet&nbsp;&nbsp;&nbsp;Water Temperature [C]</th>
        <th>Design Outlet&nbsp;&nbsp;&nbsp;Air Temperature [C]</th>
        <th>Design Coil&nbsp;&nbsp;&nbsp;Capacity [W]</th>
        <th>Design Water&nbsp;&nbsp;&nbsp;Flow Rate [m3/s]</th>
        <th>Design Air Flow&nbsp;&nbsp;&nbsp;Rate [m3/s]</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td>Bot Floor Cooling Coil</td>
        <td>6.67</td>
        <td>11.4</td>
        <td>360883.2</td>
        <td>0.01289</td>
        <td>18.51</td>
      </tr>
      <tr>
        <td>Mid Floor Cooling Coil</td>
        <td>6.67</td>
        <td>11.43</td>
        <td>3717218.05</td>
        <td>0.13277</td>
        <td>192.47</td>
      </tr>
      <tr>
        <td>Top Floor Cooling Coil</td>
        <td>6.67</td>
        <td>11.4</td>
        <td>361370.67</td>
        <td>0.012907</td>
        <td>18.3</td>
      </tr>
    </tbody>
    </table>
    <table>
        <thead>
          <tr>
            <th>Fans</th>
            <th>Type</th>
            <th>Design Size&nbsp;&nbsp;&nbsp;Supply Fan Flow Rate [m3/s]</th>
            <th>Design Size&nbsp;&nbsp;&nbsp;Supply Fan Pressure Head [Pa]</th>
            <th>Total&nbsp;&nbsp;&nbsp;Efficiency</th>
            <th>Design Power&nbsp;&nbsp;&nbsp;Consumption [W]</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td>Bot Floor Supply Fan</td>
            <td>Variable&nbsp;&nbsp;&nbsp;speed</td>
            <td>18.51</td>
            <td> </td>
            <td> </td>
            <td> </td>
          </tr>
          <tr>
            <td>Mid Floor Supply Fan</td>
            <td>Variable&nbsp;&nbsp;&nbsp;speed</td>
            <td>192.47</td>
            <td> </td>
            <td> </td>
            <td> </td>
          </tr>
          <tr>
            <td>Top Floor Supply Fan</td>
            <td>Variable&nbsp;&nbsp;&nbsp;speed</td>
            <td>18.3</td>
            <td> </td>
            <td> </td>
            <td> </td>
          </tr>
          <tr>
            <td>Bot Floor Return Fan</td>
            <td>Variable&nbsp;&nbsp;&nbsp;speed</td>
            <td> </td>
            <td> </td>
            <td> </td>
            <td> </td>
          </tr>
          <tr>
            <td>Mid Floor Return Fan</td>
            <td>Variable&nbsp;&nbsp;&nbsp;speed</td>
            <td> </td>
            <td> </td>
            <td> </td>
            <td> </td>
          </tr>
          <tr>
            <td>Top Floor Return Fan</td>
            <td>Variable&nbsp;&nbsp;&nbsp;speed</td>
            <td> </td>
            <td> </td>
            <td> </td>
            <td> </td>
          </tr>
        </tbody>
        </table>
        <table>
            <thead>
              <tr>
                <th>Pumps</th>
                <th>Type</th>
                <th>Design Flow&nbsp;&nbsp;&nbsp;Rate [m3/s]</th>
                <th>Design Size&nbsp;&nbsp;&nbsp;Supply Fan Pressure Head [Pa]</th>
                <th>Total&nbsp;&nbsp;&nbsp;Efficiency</th>
                <th>Design Power&nbsp;&nbsp;&nbsp;Consumption [W]</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>CHW Primary Pumps 1</td>
                <td>Constant&nbsp;&nbsp;&nbsp;speed</td>
                <td>0.131934</td>
                <td> </td>
                <td> </td>
                <td>33707.32</td>
              </tr>
              <tr>
                <td>CHW Primary Pumps 2</td>
                <td>Constant&nbsp;&nbsp;&nbsp;speed</td>
                <td>0.077086</td>
                <td> </td>
                <td> </td>
                <td>20257.15</td>
              </tr>
              <tr>
                <td>CHW Primary Pumps 3</td>
                <td>Constant&nbsp;&nbsp;&nbsp;speed</td>
                <td>0.000269</td>
                <td> </td>
                <td> </td>
                <td>72.71</td>
              </tr>
              <tr>
                <td>CHW Secondary  Pumps 1</td>
                <td>Variable&nbsp;&nbsp;&nbsp;speed</td>
                <td>0.186704</td>
                <td> </td>
                <td> </td>
                <td>49345.24</td>
              </tr>
              <tr>
                <td>CHW Secondary Pumps 2</td>
                <td>Variable&nbsp;&nbsp;&nbsp;speed</td>
                <td>0.186704</td>
                <td> </td>
                <td> </td>
                <td>49345.24</td>
              </tr>
              <tr>
                <td>CW Pump 1</td>
                <td>Variable&nbsp;&nbsp;&nbsp;speed</td>
                <td> </td>
                <td> </td>
                <td> </td>
                <td> </td>
              </tr>
              <tr>
                <td>CW Pump 2</td>
                <td>Variable&nbsp;&nbsp;&nbsp;speed</td>
                <td> </td>
                <td> </td>
                <td> </td>
                <td> </td>
              </tr>
              <tr>
                <td>HW Pump 1</td>
                <td>Variable&nbsp;&nbsp;&nbsp;speed</td>
                <td> </td>
                <td> </td>
                <td> </td>
                <td> </td>
              </tr>
              <tr>
                <td>HW Pump 2</td>
                <td>Variable&nbsp;&nbsp;&nbsp;speed</td>
                <td> </td>
                <td> </td>
                <td> </td>
                <td> </td>
              </tr>
            </tbody>
            </table>
            <table>
                <thead>
                  <tr>
                    <th>Chillers</th>
                    <th>Design Chilled&nbsp;&nbsp;&nbsp;Water Flow Rate [m3/s]</th>
                    <th>Design Capacity&nbsp;&nbsp;&nbsp;[W]</th>
                    <th>Design&nbsp;&nbsp;&nbsp;Condenser Water Flow Rate [m3/s]</th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td>Chiller 1</td>
                    <td>0.065967</td>
                    <td>1848765.65</td>
                    <td>0.093352</td>
                  </tr>
                  <tr>
                    <td>Chiller 2</td>
                    <td>0.065967</td>
                    <td>1848765.65</td>
                    <td>0.093352</td>
                  </tr>
                  <tr>
                    <td>Chiller 3</td>
                    <td>0.065967</td>
                    <td>1848765.65</td>
                    <td>0.093352</td>
                  </tr>
                </tbody>
                </table>
                <table>
                    <thead>
                      <tr>
                        <th>Boilers</th>
                        <th>Design Size&nbsp;&nbsp;&nbsp;Nominal Capacity [W]</th>
                        <th>Design Size&nbsp;&nbsp;&nbsp;Design Water Flow Rate [m3/s]</th>
                      </tr>
                    </thead>
                    <tbody>
                      <tr>
                        <td>Boiler 1</td>
                        <td>3520749.8</td>
                        <td>0.077086</td>
                      </tr>
                      <tr>
                        <td>Boiler 2</td>
                        <td>3520749.8</td>
                        <td>0.077086</td>
                      </tr>
                    </tbody>
                    </table>
                    <table>
                        <thead>
                          <tr>
                            <th>Cooling&nbsp;&nbsp;&nbsp;Towers</th>
                            <th>Design Water&nbsp;&nbsp;&nbsp;Flow Rate [m3/s]</th>
                            <th>Fan Power at&nbsp;&nbsp;&nbsp;Design Air Flow Rate [W]</th>
                            <th>Design Air Flow&nbsp;&nbsp;&nbsp;Rate [m3/s]</th>
                            <th>U-Factor Times&nbsp;&nbsp;&nbsp;Area Value at Design Air Flow Rate [W/C]</th>
                          </tr>
                        </thead>
                        <tbody>
                          <tr>
                            <td>Cooling Tower 1</td>
                            <td>0.186704</td>
                            <td>45882.78</td>
                            <td>123.66</td>
                            <td>264028.98</td>
                          </tr>
                          <tr>
                            <td>Cooling Tower 2</td>
                            <td>0.186704</td>
                            <td>45882.78</td>
                            <td>123.66</td>
                            <td>264028.98</td>
                          </tr>
                        </tbody>
                        </table>
                        <table>
                            <thead>
                              <tr>
                                <th>Ventilation</th>
                                <th>Maximum Outdoor&nbsp;&nbsp;&nbsp;Air Flow Rate [m3/s]</th>
                                <th>Minimum Outdoor&nbsp;&nbsp;&nbsp;Air Flow Rate [m3/s]</th>
                              </tr>
                            </thead>
                            <tbody>
                              <tr>
                                <td>Bot Floor Outdoor Air</td>
                                <td>18.51</td>
                                <td>2.4</td>
                              </tr>
                              <tr>
                                <td>Mid Floor Outdoor Air</td>
                                <td>192.47</td>
                                <td>23.97</td>
                              </tr>
                              <tr>
                                <td>Top Floor Outdoor Air</td>
                                <td>18.3</td>
                                <td>2.4</td>
                              </tr>
                            </tbody>
                            </table>
<h4>HVAC system control</h4>
<h4>Air-side system control</h4>
<p align=\\\"center\\\">
    <img alt=\\\"AirSideControl.\\\"
    src=\"modelica://MultiZoneOfficeComplexAir/../../doc/images/AirSideControl.png\" width=800>
</p>
<h4>VAV terminal control</h4>
<p>
    Controller for terminal VAV box with hot water reheat and damper. It is based on the 
    \"single maximum VAV reheat control logic\". 
</p>
<p>
    When the Zone State is cooling, the cooling-loop output shall be mapped to the active 
    airflow setpoint from the cooling minimum endpoint to the cooling maximum endpoint. 
    Heating coil is disabled. 
</p> 
<p>
    When the Zone State is deadband, the active airflow setpoint shall be the minimum 
    endpoint. Heating coil is disabled.
</p>
<p>
    When the Zone State is heating, the active airflow setpoint shall be the minimum endpoint. 
    The reheat valve position shall be mapped to the supply air temperature setpoint from the 
    heating minimum endpoint to the heating maximum endpoint.
</p>
<p align=\\\"center\\\">
    <img alt=\\\"SingleMax.\\\"
    src=\"modelica://MultiZoneOfficeComplexAir/../../doc/images/SingleMax.png\" width=800>
</p>
<p>
    Taylor, Steven T., et al. \"Dual maximum VAV box control logic.\" ASHRAE Journal, vol. 54, 
    no. 12, Dec. 2012.
</p>
<p>
    VAV air flow rate control
</p>
<p>
    VAV damper position is controlled by a PI controller to maintain the air flow rate at 
    setpoint. It takes the zone air flow rate measurements and setpoints as inputs. It takes
     the VAV damper position as the output. 
</p>
<p>
    VAV supply air temperature Control
</p>
<P>
    Heating coil valve position is controlled by a PI controller to maintain the supply air 
    temperature at setpoint. It takes the zone air temperature measurements and setpoint as 
    inputs. It takes the heating coil valve position as the output.    
</P>
<h4>
    AHU control
</h4>
<p>
    AHU duct static pressure control
</p>
<p>
    Supply fan speed is controlled by a PI controller to maintain duct static pressure 
    (DSP) at setpoint when the fan is proven ON. It takes the static pressure measurements 
    and setpoints as inputs. It takes the supply fan speed as the output. The AHU return 
    fan speed is set as a constant ratio (0.9) of the supply fan speed  .   
</p>
<p>
    AHU supply air temperature control
</p>
<p>
    Cooling coil valve position is controlled by a PI controller to maintain the AHU 
    supply air temperature at setpoint. It takes the supply air temperature measurements
     and setpoints as inputs. It takes the cooling coil valve position as the output.
</p>
<p>
    Mixing box damper and economizer control 
</p>
<p>
    In the mixing box of the AHU, an economizer is implemented to use the outdoor air 
    to meet the cooling load when outdoor conditions are favorable. 
</p>
<p>
    Outdoor air damper position is controlled by a PI controller to maintain the mixed air 
    temperature at setpoint. It takes the mixed and outdoor air temperature measurements, 
    as well as the mixed air temperature setpoints as inputs. It takes the outdoor air damper
     position as the output. The return air damper are interlocked with the outdoor air damper
      while exhausted air damper share the same opening position with the outdoor air damper. 
</p>
<p>
    On top of that, an economizer control based on the fixed dry-bulb outdoor air 
    temperature-based is adopted. The economizer higher temperature limit is set as 
    21 ℃ according to ASHRAE 90.1-2019 for Climate Zone 5A.
</p>
<h4>Water-side system control</h4>
<p align=\\\"center\\\">
  <img alt=\\\"ChillerControl.\\\"
  src=\"modelica://MultiZoneOfficeComplexAir/../../doc/images/ChillerControl.PNG\" width=800>
</p>
<p align=\\\"center\\\">
  <img alt=\\\"BoilerControl.\\\"
  src=\"modelica://MultiZoneOfficeComplexAir/../../doc/images/BoilerControl.PNG\" width=800>
</p>
<h4>
    Chiller control
</h4>
<p>
    Chiller plant staging control
</p>
<p>
    The number of operating chillers is determined via a state machine based on the thermal 
    load (Q, kW), rated chiller cooling capacity of chiller k (cc<sup>k</sup>, kW), 
    threshold to start chiller k+1 (ξ<sup>k</sup> = 0.9), and waiting time 
    (30 min). The maximum operating chiller number is N,  which is equal to 3.
    <ul>
        <li>
            One chiller is commanded on when the plant is on.
        </li>
        <li>
            Two chillers are commanded on when the calculated thermal load is higher 
            than ξ<sup>1</sup> * cc<sup>1</sup> during the waiting time, where 
            ξ<sup>1</sup> is the threshold of chiller 1, 
            cc<sup>1</sup> is the rated cooling capacity of chiller 1. 
        </li>
        <li>
            Three chillers are commanded on when the calculated thermal load is 
            higher than ξ<sup>2</sup> * (cc<sup>1</sup> + cc<sup>2</sup>) during the 
            waiting time, where ξ<sup>2</sup> is the 
            threshold of chiller 2, cc<sup>1</sup> is the rated cooling capacity of chiller 1, 
            cc<sup>2</sup> is the rated cooling capacity of chiller 2.
        </li>
        </ul> 
</p>
<p>
    The stage control logic is shown as the following figure.
</p>
<p align=\\\"center\\\">
    <img alt=\\\"ChillerStage.\\\"
    src=\"modelica://MultiZoneOfficeComplexAir/../../doc/images/ChillerStage.png\" width=800>
</p>
<p>
    Chilled water supply temperature control
</p>
<p>
    The model takes as an input the set point for the leaving chilled water temperature, 
    which is met if the chiller has sufficient capacity. Thus, the model has a built-in, 
    ideal temperature control.
</p>
<p>
    Secondary chilled water pump staging control
</p>
<p>
    The number of secondary chilled water pump is determined via a state machine based 
    on the pump speed (S, rpm) and waiting time (30 min). The maximum operating pump 
    number is M,  which is equal to 2.
    <ul>
        <li>
            One pump is commanded on when the plant is on.
        </li>
        <li>
            Two pumps are commanded on when the first pump speed is higher than 
            0.9 during the waiting time. 
        </li>
        </ul>
</p>
<p>
    The stage control logic is shown as the following figure.
</p>
<p align=\\\"center\\\">
    <img alt=\\\"ChillerPumpStage.\\\"
    src=\"modelica://MultiZoneOfficeComplexAir/../../doc/images/ChillerPumpStage.png\" width=800>
</p>
<p>
    Secondary chilled water loop static pressure control
</p>
<p>
    Secondary chilled water pump speed is controlled by a PI controller to maintain 
    the static pressure of the secondary chilled water loop at setpoint. It takes the 
    chilled water loop static pressure measurements and setpoints as inputs. It takes 
    the pump speed as the output. The operating secondary chilled water pumps share 
    the same speed.
</p>
<h4>Cooling tower control</h4>
<p>Cooling Tower supply water temperature control</p>
<p>
    Cooling tower fan speed is controlled by a PI controller to maintain the cooling 
    tower supply water temperature at setpoint. It takes the cooling tower supply water 
    temperature measurements and setpoints as inputs. It takes the cooling tower fan 
    speed as the output. All the operating cooling towers share the same fan speed.
</p>
<p>Minimum condenser supply water temperature control </p>
<p>
    Three-way valve position is controlled by a PI controller to maintain the temperature 
    of the condenser water leaving the condenser water loop to be larger than 15.56 ℃. 
    It takes the condenser supply water temperature measurements and setpoints as inputs. 
    It takes the three-way valve position as the output.
</p>
<h4>
    Boiler control
</h4>
<p>
    Boiler staging control
</p>
<p>
    The number of operating boilers is determined via a state machine based on the thermal 
    load(Q, kW), rated heating capacity of boiler k (hc<sup>k</sup>, kW), threshold to start boiler
     k+1 (ξ<sup>k</sup> = 0.9), and waiting time (30 min). The maximum operating boiler number is N,
       which is equal to 2.
    <ul>
        <li>
            One boiler is commanded on when the plant is on.
        </li>
        <li>
            Two boilers are commanded on when the calculated thermal load is higher 
            than ξ<sup>1</sup> * hc<sup>1</sup> during the waiting time, where ξ<sup>1</sup> 
            is the threshold of boiler 1, 
            hc<sup>1</sup> is the rated heating capacity of boiler 1.  
        </li>
        </ul>
</p>
<p>
    The stage control logic is shown as the following figure. 
</p>
<p align=\\\"center\\\">
    <img alt=\\\"BoilerStage.\\\"
    src=\"modelica://MultiZoneOfficeComplexAir/../../doc/images/BoilerStage.png\" width=800>
</p>
<p>Boiler water temperature control</p>
<p>
    Boiler heating power is controlled by a PI controller to maintain the temperature 
    of the hot water leaving each boiler to be 80 ℃. It takes the hot water measurements 
    and set points as inputs. It takes the heating power as the output.
</p>
<p>Boiler hot water loop static pressure control</p>
<p>
    Boiler pump speed   is controlled by a PI controller to maintain the static pressure 
    of the boiler water loop   at setpoint. It takes the heat water loop pressure drop 
    measurements and setpoints as inputs. It takes the pump speed as the output. All 
    the boiler pumps share the same speed.
</p>
<h3>Model IO's</h3>
<h4>Inputs</h4>
<p>
    The model inputs are:
    <ul>
        <li>
            <code>hvac_floor1_TSupAirSet_u</code> [K] [min=285.15, max=313.15]: Supply air temperature setpoint for AHU
            </li>
            <li>
            <code>hvac_floor1_dpSet_u</code> [Pa] [min=50.0, max=410.0]: Supply duct pressure setpoint for AHU
            </li>
            <li>
            <code>hvac_floor1_duaFanAirHanUnit_cooCoil_yCoo_u</code> [1] [min=0.0, max=1.0]: Cooling coil valve control signal for AHU
            </li>
            <li>
            <code>hvac_floor1_duaFanAirHanUnit_mixingBox_mixBox_yEA_u</code> [1] [min=0.0, max=1.0]: Exhaust air damper position setpoint for AHU
            </li>
            <li>
            <code>hvac_floor1_duaFanAirHanUnit_mixingBox_mixBox_yOA_u</code> [1] [min=0.0, max=1.0]: Outside air damper position setpoint for AHU
            </li>
            <li>
            <code>hvac_floor1_duaFanAirHanUnit_mixingBox_mixBox_yRet_u</code> [1] [min=0.0, max=1.0]: Return air damper position setpoint for AHU
            </li>
            <li>
            <code>hvac_floor1_duaFanAirHanUnit_oveSpeRetFan_u</code> [1] [min=0.0, max=1.0]: AHU return fan speed control signal
            </li>
            <li>
            <code>hvac_floor1_duaFanAirHanUnit_supFan_oveSpeSupFan_u</code> [1] [min=0.0, max=1.0]: AHU supply fan speed control signal
            </li>
            <li>
            <code>hvac_floor1_fivZonVAV_vAV1_oveZonLoc_yDam_u</code> [1] [min=0.0, max=1.0]: Damper position setpoint for zone cor
            </li>
            <li>
            <code>hvac_floor1_fivZonVAV_vAV1_oveZonLoc_yReaHea_u</code> [1] [min=0.0, ma"
           + "x=1.0]: Reheat control signal for zone cor
            </li>
            <li>
            <code>hvac_floor1_fivZonVAV_vAV2_oveZonLoc_yDam_u</code> [1] [min=0.0, max=1.0]: Damper position setpoint for zone sou
            </li>
            <li>
            <code>hvac_floor1_fivZonVAV_vAV2_oveZonLoc_yReaHea_u</code> [1] [min=0.0, max=1.0]: Reheat control signal for zone sou
            </li>
            <li>
            <code>hvac_floor1_fivZonVAV_vAV3_oveZonLoc_yDam_u</code> [1] [min=0.0, max=1.0]: Damper position setpoint for zone eas
            </li>
            <li>
            <code>hvac_floor1_fivZonVAV_vAV3_oveZonLoc_yReaHea_u</code> [1] [min=0.0, max=1.0]: Reheat control signal for zone eas
            </li>
            <li>
            <code>hvac_floor1_fivZonVAV_vAV4_oveZonLoc_yDam_u</code> [1] [min=0.0, max=1.0]: Damper position setpoint for zone nor
            </li>
            <li>
            <code>hvac_floor1_fivZonVAV_vAV4_oveZonLoc_yReaHea_u</code> [1] [min=0.0, max=1.0]: Reheat control signal for zone nor
            </li>
            <li>
            <code>hvac_floor1_fivZonVAV_vAV5_oveZonLoc_yDam_u</code> [1] [min=0.0, max=1.0]: Damper position setpoint for zone wes
            </li>
            <li>
            <code>hvac_floor1_fivZonVAV_vAV5_oveZonLoc_yReaHea_u</code> [1] [min=0.0, max=1.0]: Reheat control signal for zone wes
            </li>
            <li>
            <code>hvac_floor1_oveZonCor_TZonCooSet_u</code> [K] [min=285.15, max=313.15]: Zone air temperature cooling setpoint for zone bot_floor_cor
            </li>
            <li>
            <code>hvac_floor1_oveZonCor_TZonHeaSet_u</code> [K] [min=285.15, max=313.15]: Zone air temperature heating setpoint for zone bot_floor_cor
            </li>
            <li>
            <code>hvac_floor1_oveZonEas_TZonCooSet_u</code> [K] [min=285.15, max=313.15]: Zone air temperature cooling setpoint for zone bot_floor_eas
            </li>
            <li>
            <code>hvac_floor1_oveZonEas_TZonHeaSet_u</code> [K] [min=285.15, max=313.15]: Zone air temperature heating setpoint for zone bot_floor_eas
            </li>
            <li>
            <code>hvac_floor1_oveZonNor_TZonCooSet_u</code> [K] [min=285.15, max=313.15]: Zone air temperature cooling setpoint for zone bot_floor_nor
            </li>
            <li>
            <code>hvac_floor1_oveZonNor_TZonHeaSet_u</code> [K] [min=285.15, max=313.15]: Zone air temperature heating setpoint for zone bot_floor_nor
            </li>
            <li>
            <code>hvac_floor1_oveZonSou_TZonCooSet_u</code> [K] [min=285.15, max=313.15]: Zone air temperature cooling setpoint for zone bot_floor_sou
            </li>
            <li>
            <code>hvac_floor1_oveZonSou_TZonHeaSet_u</code> [K] [min=285.15, max=313.15]: Zone air temperature heating setpoint for zone bot_floor_sou
            </li>
            <li>
            <code>hvac_floor1_oveZonWes_TZonCooSet_u</code> [K] [min=285.15, max=313.15]: Zone air temperature cooling setpoint for zone bot_floor_wes
            </li>
            <li>
            <code>hvac_floor1_oveZonWes_TZonHeaSet_u</code> [K] [min=285.15, max=313.15]: Zone air temperature heating setpoint for zone bot_floor_wes
            </li>
            <li>
            <code>hvac_floor2_TSupAirSet_u</code> [K] [min=285.15, max=313.15]: Supply air temperature setpoint for AHU
            </li>
            <li>
            <code>hvac_floor2_dpSet_u</code> [Pa] [min=50.0, max=410.0]: Supply duct pressure setpoint for AHU
            </li>
            <li>
            <code>hvac_floor2_duaFanAirHanUnit_cooCoil_yCoo_u</code> [1] [min=0.0, max=1.0]: Cooling coil valve control signal for AHU
            </li>
            <li>
            <code>hvac_floor2_duaFanAirHanUnit_mixingBox_mixBox_yEA_u</code> [1] [min=0.0, max=1.0]: Exhaust air damper position setpoint for AHU
            </li>
            <li>
            <code>hvac_floor2_duaFanAirHanUnit_mixingBox_mixBox_yOA_u</code> [1] [min=0.0, max=1.0]: Outside air damper position setpoint for AHU
            </li>
            <li>
            <code>hvac_floor2_duaFanAirHanUnit_mixingBox_mixBox_yRet_u</code> [1] [min=0.0, max=1.0]: Return air damper position setpoint for AHU
            </li>
            <li>
            <code>hvac_floor2_duaFanAirHanUnit_oveSpeRetFan_u</code> [1] [min=0.0, max=1.0]: AHU return fan speed control signal
            </li>
            <li>
            <code>hvac_floor2_duaFanAirHanUnit_supFan_oveSpeSupFan_u</code> [1] [min=0.0, max=1.0]: AHU supply fan speed control signal
            </li>
            <li>
            <code>hvac_floor2_fivZonVAV_vAV1_oveZonLoc_yDam_u</code> [1] [min=0.0, max=1.0]: Damper position setpoint for zone cor
            </li>
            <li>
            <code>hvac_floor2_fivZonVAV_vAV1_oveZonLoc_yReaHea_u</code> [1] [min=0.0, max=1.0]: Reheat control signal for zone cor
            </li>
            <li>
            <code>hvac_floor2_fivZonVAV_vAV2_oveZonLoc_yDam_u</code> [1] [min=0.0, max=1.0]: Damper position setpoint for zone sou
            </li>
            <li>
            <code>hvac_floor2_fivZonVAV_vAV2_oveZonLoc_yReaHea_u</code> [1] [min=0.0, max=1.0]: Reheat control signal for zone sou
            </li>
            <li>
            <code>hvac_floor2_fivZonVAV_vAV3_oveZonLoc_yDam_u</code> [1] [min=0.0, max=1.0]: Damper position setpoint for zone eas
            </li>
            <li>
            <code>hvac_floor2_fivZonVAV_vAV3_oveZonLoc_yReaHea_u</code> [1] [min=0.0, max=1.0]: Reheat control signal for zone eas
            </li>
            <li>
            <code>hvac_floor2_fivZonVAV_vAV4_oveZonLoc_yDam_u</code> [1] [min=0.0, max=1.0]: Damper position setpoint for zone nor
            </li>
            <li>
            <code>hvac_floor2_fivZonVAV_vAV4_oveZonLoc_yReaHea_u</code> [1] [min=0.0, max=1.0]: Reheat control signal for zone nor
            </li>
            <li>
            <code>hvac_floor2_fivZonVAV_vAV5_oveZonLoc_yDam_u</code> [1] [min=0.0, max=1.0]: Damper position setpoint for zone wes
            </li>
            <li>
            <code>hvac_floor2_fivZonVAV_vAV5_oveZonLoc_yReaHea_u</code> [1] [min=0.0, max=1.0]: Reheat control signal for zone wes
            </li>
            <li>
            <code>hvac_floor2_oveZonCor_TZonCooSet_u</code> [K] [min=285.15, max=313.15]: Zone air temperature cooling setpoint for zone mid_floor_cor
            </li>
            <li>
            <code>hvac_floor2_oveZonCor_TZonHeaSet_u</code> [K] [min=285.15, max=313.15]: Zone air temperature heating setpoint for zone mid_floor_cor
            </li>
            <li>
            <code>hvac_floor2_oveZonEas_TZonCooSet_u</code> [K] [min=285.15, max=313.15]: Zone air temperature cooling setpoint for zone mid_floor_eas
            </li>
            <li>
            <code>hvac_floor2_oveZonEas_TZonHeaSet_u</code> [K] [min=285.15, max=313.15]: Zone air temperature heating setpoint for zone mid_floor_eas
            </li>
            <li>
            <code>hvac_floor2_oveZonNor_TZonCooSet_u</code> [K] [min=285.15, max=313.15]: Zone air temperature cooling setpoint for zone mid_floor_nor
            </li>
            <li>
            <code>hvac_floor2_oveZonNor_TZonHeaSet_u</code> [K] [min=285.15, max=313.15]: Zone air temperature heating setpoint for zone mid_floor_nor
            </li>
            <li>
            <code>hvac_floor2_oveZonSou_TZonCooSet_u</code> [K] [min=285.15, max=313.15]: Zone air temperature cooling setpoint for zone mid_floor_sou
            </li>
            <li>
            <code>hvac_floor2_oveZonSou_TZonHeaSet_u</code> [K] [min=285.15, max=313.15]: Zone air temperature heating setpoint for zone mid_floor_sou
            </li>
            <li>
            <code>hvac_floor2_oveZonWes_TZonCooSet_u</code> [K] [min=285.15, max=313.15]: Zone air temperature cooling setpoint for zone mid_floor_wes
            </li>
            <li>
            <code>hvac_floor2_oveZonWes_TZonHeaSet_u</code> [K] [min=285.15, max=313.15]: Zone air temperature heating setpoint for zone mid_floor_wes
            </li>
            <li>
            <code>hvac_floor3_TSupAirSet_u</code> [K] [min=285.15, max=313.15]: Supply air temperature setpoint for AHU
            </li>
            <li>
            <code>hvac_floor3_dpSet_u</code> [Pa] [min=50.0, max=410.0]: Supply duct pressure setpoint for AHU
            </li>
            <li>
            <code>hvac_floor3_duaFanAirHanUnit_cooCoil_yCoo_u</code> [1] [min=0.0, max=1.0]: Cooling coil valve control signal for AHU
            </li>
            <li>
            <code>hvac_floor3_duaFanAirHanUnit_mixingBox_mixBox_yEA_u</code> [1] [min=0.0, max=1.0]: Exhaust air damper position setpoint for AHU
            </li>
            <li>
            <code>hvac_floor3_duaFanAirHanUnit_mixingBox_mixBox_yOA_u</code> [1] [min=0.0, max=1.0]: Outside air damper position setpoint for AHU
            </li>
            <li>
            <code>hvac_floor3_duaFanAirHanUnit_mixingBox_mixBox_yRet_u</code> [1] [min=0.0, max=1.0]: Return air damper position setpoint for AHU
            </li>
            <li>
            <code>hvac_floor3_duaFanAirHanUnit_oveSpeRetFan_u</code> [1] [min=0.0, max=1.0]: AHU return fan speed control signal
            </li>
            <li>
            <code>hvac_floor3_duaFanAirHanUnit_supFan_oveSpeSupFan_u</code> [1] [min=0.0, max=1.0]: AHU supply fan speed control signal
            </li>
            <li>
            <code>hvac_floor3_fivZonVAV_vAV1_oveZonLoc_yDam_u</code> [1] [min=0.0, max=1.0]: Damper position setpoint for zone cor
            </li>
            <li>
            <code>hvac_floor3_fivZonVAV_vAV1_oveZonLoc_yReaHea_u</code> [1] [min=0.0, max=1.0]: Reheat control signal for zone cor
            </li>
            <li>
            <code>hvac_floor3_fivZonVAV_vAV2_oveZonLoc_yDam_u</code> [1] [min=0.0, max=1.0]: Damper position setpoint for zone sou
            </li>
            <li>
            <code>hvac_floor3_fivZonVAV_vAV2_oveZonLoc_yReaHea_u</code> [1] [min=0.0, max=1.0]: Reheat control signal for zone sou
            </li>
            <li>
            <code>hvac_floor3_fivZonVAV_vAV3_oveZonLoc_yDam_u</code> [1] [min=0.0, max=1.0]: Damper position setpoint for zone eas
            </li>
            <li>
            <code>hvac_floor3_fivZonVAV_vAV3_oveZonLoc_yReaHea_u</code> [1] [min=0.0, max=1.0]: Reheat control signal for zone eas
            </li>
            <li>
            <code>hvac_floor3_fivZonVAV_vAV4_oveZonLoc_yDam_u</code> [1] [min=0.0, max=1.0]: Damper position setpoint for zone nor
            </li>
            <li>
            <code>hvac_floor3_fivZonVAV_vAV4_oveZonLoc_yReaHea_u</code> [1] [min=0.0, max=1.0]: Reheat control signal for zone nor
            </li>
            <li>
            <code>hvac_floor3_fivZonVAV_vAV5_oveZonLoc_yDam_u</code> [1] [min=0.0, max=1.0]: Damper position setpoint for zone wes
            </li>
            <li>
            <code>hvac_floor3_fivZonVAV_vAV5_oveZonLoc_yReaHea_u</code> [1] [min=0.0, max=1.0]: Reheat control signal for zone wes
            </li>
            <li>
            <code>hvac_floor3_oveZonCor_TZonCooSet_u</code> [K] [min=285.15, max=313.15]: Zone air temperature cooling setpoint for zone top_floor_cor
            </li>
            <li>
            <code>hvac_floor3_oveZonCor_TZonHeaSet_u</code> [K] [min=285.15, max=313.15]: Zone air temperature heating setpoint for zone top_floor_cor
            </li>
            <li>
            <code>hvac_floor3_oveZonEas_TZonCooSet_u</code> [K] [min=285.15, max=313.15]: Zone air temperature cooling setpoint for zone top_floor_eas
            </li>
            <li>
            <code>hvac_floor3_oveZonEas_TZonHeaSet_u</code> [K] [min=285.15, max=313.15]: Zone air temperature heating setpoint for zone top_floor_eas
            </li>
            <li>
            <code>hvac_floor3_oveZonNor_TZonCooSet_u</code> [K] [min=285.15, max=313.15]: Zone air temperature cooling setpoint for zone top_floor_nor
            </li>
            <li>
            <code>hvac_floor3_oveZonNor_TZonHeaSet_u</code> [K] [min=285.15, max=313.15]: Zone air temperature heating setpoint for zone top_floor_nor
            </li>
            <li>
            <code>hvac_floor3_oveZonSou_TZonCooSet_u</code> [K] [min=285.15, max=313.15]: Zone air temperature cooling setpoint for zone top_floor_sou
            </li>
            <li>
            <code>hvac_floor3_oveZonSou_TZonHeaSet_u</code> [K] [min=285.15, max=313.15]: Zone air temperature heating setpoint for zone top_floor_sou
            </li>
            <li>
            <code>hvac_floor3_oveZonWes_TZonCooSet_u</code> [K] [min=285.15, max=313.15]: Zone air temperature cooling setpoint for zone top_floor_wes
            </li>
            <li>
            <code>hvac_floor3_oveZonWes_TZonHeaSet_u</code> [K] [min=285.15, max=313.15]: Zone air temperature heating setpoint for zone top_floor_wes
            </li>
            <li>
            <code>hvac_oveChiWatSys_TW_set_u</code> [K] [min=278.15, max=288.15]: Chilled/hot water supply setpoint
            </li>
            <li>
            <code>hvac_oveChiWatSys_dp_set_u</code> [Pa] [min=0.0, max=19130000.0]: Differential pressure setpoint
            </li>
            <li>
            <code>hvac_oveHotWatSys_TW_set_u</code> [K] [min=291.15, max=353.15]: Chilled/hot water supply setpoint
            </li>
            <li>
            <code>hvac_oveHotWatSys_dp_set_u</code> [Pa] [min=0.0, max=19130000.0]: Differential pressure setpoint
            </li>
    </ul>
</p>
<h4>Outputs</h4>
<p>
    The model outputs are:
    <ul>
        <li>
            <code>hvac_floor1_reaZonCor_TRoo_Coo_set_y</code> [K] [min=None, max=None]: Zone temperature cooling setpoint for zonebot_floor_cor
            </li>
            <li>
            <code>hvac_floor1_reaZonCor_TRoo_Hea_set_y</code> [K] [min=None, max=None]: Zone temperature heating setpoint for zone bot_floor_cor
            </li>
            <li>
            <code>hvac_floor1_reaZonCor_TSup_y</code> [K] [min=None, max=None]: Discharge air temperature to zone measurement for zone bot_floor_cor
            </li>
            <li>
            <code>hvac_floor1_reaZonCor_TZon_y</code> [K] [min=None, max=None]: Zone air temperature measurement for zone bot_floor_cor
            </li>
            <li>
            <code>hvac_floor1_reaZonCor_V_flow_set_y</code> [m3/s] [min=None, max=None]: Airflow setpointbot_floor_cor
            </li>
            <li>
            <code>hvac_floor1_reaZonCor_V_flow_y</code> [m3/s] [min=None, max=None]: Discharge air flowrate to zone measurement for zone bot_floor_cor
            </li>
            <li>
            <code>hvac_floor1_reaZonCor_yCoo_y</code> [1] [min=None, max=None]: Cooling PID signal measurement for zone bot_floor_cor
            </li>
            <li>
            <code>hvac_floor1_reaZonCor_yDam_y</code> [1] [min=None, max=None]: Damper position measurement for zone bot_floor_cor
            </li>
            <li>
            <code>hvac_floor1_reaZonCor_yHea_y</code> [1] [min=None, max=None]: Heating PID signal measurement for zone bot_floor_cor
            </li>
            <li>
            <code>hvac_floor1_reaZonCor_yReheaVal_y</code> [1] [min=None, max=None]: Reheat valve position measurement for zone bot_floor_cor
            </li>
            <li>
            <code>hvac_floor1_reaZonEas_TRoo_Coo_set_y</code> [K] [min=None, max=None]: Zone temperature cooling setpoint for zonebot_floor_eas
            </li>
            <li>
            <code>hvac_floor1_reaZonEas_TRoo_Hea_set_y</code> [K] [min=None, max=None]: Zone temperature heating setpoint for zone bot_floor_eas
            </li>
            <li>
            <code>hvac_floor1_reaZonEas_TSup_y</code> [K] [min=None, max=None]: Discharge air temperature to zone measurement for zone bot_floor_eas
            </li>
            <li>
            <code>hvac_floor1_reaZonEas_TZon_y</code> [K] [min=None, max=None]: Zone air temperature measurement for zone bot_floor_eas
            </li>
            <li>
            <code>hvac_floor1_reaZonEas_V_flow_set_y</code> [m3/s] [min=None, max=None]: Airflow setpointbot_floor_eas
            </li>
            <li>
            <code>hvac_floor1_reaZonEas_V_flow_y</code> [m3/s] [min=None, max=None]: Discharge air flowrate to zone measurement for zone bot_floor_eas
            </li>
            <li>
            <code>hvac_floor1_reaZonEas_yCoo_y</code> [1] [min=None, max=None]: Cooling PID signal measurement for zone bot_floor_eas
            </li>
            <li>
            <code>hvac_floor1_reaZonEas_yDam_y</code> [1] [min=None, max=None]: Damper position measurement for zone bot_floor_eas
            </li>
            <li>
            <code>hvac_floor1_reaZonEas_yHea_y</code> [1] [min=None, max=None]: Heating PID signal measurement for zone bot_floor_eas
            </li>
            <li>
            <code>hvac_floor1_reaZonEas_yReheaVal_y</code> [1] [min=None, max=None]: Reheat valve position measurement for zone bot_floor_eas
            </li>
            <li>
            <code>hvac_floor1_reaZonNor_TRoo_Coo_set_y</code> [K] [min=None, max=None]: Zone temperature cooling setpoint for zonebot_floor_nor
            </li>
            <li>
            <code>hvac_floor1_reaZonNor_TRoo_Hea_set_y</code> [K] [min=None, max=None]: Zone temperature heating setpoint for zone bot_floor_nor
            </li>
            <li>
            <code>hvac_floor1_reaZonNor_TSup_y</code> [K] [min=None, max=None]: Discharge air temperature to zone measurement for zone bot_floor_nor
            </li>
            <li>
            <code>hvac_floor1_reaZonNor_TZon_y</code> [K] [min=None, max=None]: Zone air temperature measurement for zone bot_floor_nor
            </li>
            <li>
            <code>hvac_floor1_reaZonNor_V_flow_set_y</code> [m3/s] [min=None, max=None]: Airflow setpointbot_floor_nor
            </li>
            <li>
            <code>hvac_floor1_reaZonNor_V_flow_y</code> [m3/s] [min=None, max=None]: Discharge air flowrate to zone measurement for zone bot_floor_nor
            </li>
            <li>
            <code>hvac_floor1_reaZonNor_yCoo_y</code> [1] [min=None, max=None]: Cooling PID signal measurement for zone bot_floor_nor
            </li>
            <li>
            <code>hvac_floor1_reaZonNor_yDam_y</code> [1] [min=None, max=None]: Damper position measurement for zone bot_floor_nor
            </li>
            <li>
            <code>hvac_floor1_reaZonNor_yHea_y</code> [1] [min=None, max=None]: Heating PID signal measurement for zone bot_floor_nor
            </li>
            <li>
            <code>hvac_floor1_reaZonNor_yReheaVal_y</code> [1] [min=None, max=None]: Reheat valve position measurement for zone bot_floor_nor
            </li>
            <li>
            <code>hvac_floor1_reaZonSou_TRoo_Coo_set_y</code> [K] [min=None, max=None]: Zone temperature cooling setpoint for zonebot_floor_sou
            </li>
            <li>
            <code>hvac_floor1_reaZonSou_TRoo_Hea_set_y</code> [K] [min=None, max=None]: Zone temperature heating setpoint for zone bot_floor_sou
            </li>
            <li>
            <code>hvac_floor1_reaZonSou_TSup_y</code> [K] [min=None, max=None]: Discharge air temperature to zone measurement for zone bot_floor_sou
            </li>
            <li>
            <code>hvac_floor1_reaZonSou_TZon_y</code> [K] [min=None, max=None]: Zone air temperature measurement for zone bot_floor_sou
            </li>
            <li>
            <code>hvac_floor1_reaZonSou_V_flow_set_y</code> [m3/s] [min=None, max=None]: Airflow setpointbot_floor_sou
            </li>
            <li>
            <code>hvac_floor1_reaZonSou_V_flow_y</code> [m3/s] [min=None, max=None]: Discharge air flowrate to zone measurement for zone bot_floor_sou
            </li>
            <li>
            <code>hvac_floor1_reaZonSou_yCoo_y</code> [1] [min=None, max=None]: Cooling PID signal measurement for zone bot_floor_sou
            </li>
            <li>
            <code>hvac_floor1_reaZonSou_yDam_y</code> [1] [min=None, max=None]: Damper position measurement for zone bot_floor_sou
            </li>
            <li>
            <code>hvac_floor1_reaZonSou_yHea_y</code> [1] [min=None, max=None]: Heating PID signal measurement for zone bot_floor_sou
            </li>
            <li>
            <code>hvac_floor1_reaZonSou_yReheaVal_y</code> [1] [min=None, max=None]: Reheat valve position measurement for zone bot_floor_sou
            </li>
            <li>
            <code>hvac_floor1_reaZonWes_TRoo_Coo_set_y</code> [K] [min=None, max=None]: Zone temperature cooling setpoint for zonebot_floor_wes
            </li>
            <li>
            <code>hvac_floor1_reaZonWes_TRoo_Hea_set_y</code> [K] [min=None, max=None]: Zone temperature heating setpoint for zone bot_floor_wes
            </li>
            <li>
            <code>hvac_floor1_reaZonWes_TSup_y</code> [K] [min=None, max=None]: Discharge air temperature to zone measurement for zone bot_floor_wes
            </li>
            <li>
            <code>hvac_floor1_reaZonWes_TZon_y</code> [K] [min=None, max=None]: Zone air temperature measurement for zone bot_floor_wes
            </li>
            <li>
            <code>hvac_floor1_reaZonWes_V_flow_set_y</code> [m3/s] [min=None, max=None]: Airflow setpointbot_floor_wes
            </li>
            <li>
            <code>hvac_floor1_reaZonWes_V_flow_y</code> [m3/s] [min=None, max=None]: Discharge air flowrate to zone measurement for zone bot_floor_wes
            </li>
            <li>
            <code>hvac_floor1_reaZonWes_yCoo_y</code> [1] [min=None, max=None]: Cooling PID signal measurement for zone bot_floor_wes
            </li>
            <li>
            <code>hvac_floor1_reaZonWes_yDam_y</code> [1] [min=None, max=None]: Damper position measurement for zone bot_floor_wes
            </li>
            <li>
            <code>hvac_floor1_reaZonWes_yHea_y</code> [1] [min=None, max=None]: Heating PID signal measurement for zone bot_floor_wes
            </li>
            <li>
            <code>hvac_floor1_reaZonWes_yReheaVal_y</code> [1] [min=None, max=None]: Reheat valve position measurement for zone bot_floor_wes
            </li>
            <li>
            <code>hvac_floor1_readAhu_PFanTot_y</code> [W] [min=None, max=None]: Total electrical power measurement of supply and return fans for AHU
            </li>
            <li>
            <code>hvac_floor1_readAhu_TCooCoiRet_y</code> [K] [min=None, max=None]: Cooling coil return water temperature measurement for AHU
            </li>
            <li>
            <code>hvac_floor1_readAhu_TCooCoiSup_y</code> [K] [min=None, max=None]: Cooling coil supply water temperature measurement for AHU
            </li>
            <li>
            <code>hvac_floor1_readAhu_TMix_y</code> [K] [min=None, max=None]: Mixed air temperature measurement for AHU
            </li>
            <li>
            <code>hvac_floor1_readAhu_TRet_y</code> [K] [min=None, max=None]: Return air temperature measurement for AHU
            </li>
            <li>
            <code>hvac_floor1_readAhu_TSup_set_y</code> [K] [min=None, max=None]: Supply air temperature setpoint measurement for AHU
            </li>
            <li>
            <code>hvac_floor1_readAhu_TSup_y</code> [K] [min=None, max=None]: Supply air temperature measurement for AHU
            </li>
            <li>
            <code>hvac_floor1_readAhu_V_flow_OA_y</code> [m3/s] [min=None, max=None]: Supply outdoor airflow rate measurement for AHU
            </li>
            <li>
            <code>hvac_floor1_readAhu_V_flow_ret_y</code> [m3/s] [min=None, max=None]: Return air flowrate measurement for AHU
            </li>
            <li>
            <code>hvac_floor1_readAhu_V_flow_sup_y</code> [m3/s] [min=None, max=None]: Supply air flowrate measurement for AHU
            </li>
            <li>
            <code>hvac_floor1_readAhu_dp_sup_y</code> [Pa] [min=None, max=None]: Discharge pressure of supply fan for AHU
            </li>
            <li>
            <code>hvac_floor1_readAhu_occ_y</code> [1] [min=None, max=None]: Occupancy status (1 occupied, 0 unoccupied)
            </li>
            <li>
            <code>hvac_floor1_readAhu_yCooVal_y</code> [1] [min=None, max=None]: AHU cooling coil valve position measurement
            </li>
            <li>
            <code>hvac_floor1_readAhu_yOA_y</code> [1] [min=None, max=None]: AHU cooling coil valve position measurement
            </li>
            <li>
            <code>hvac_floor2_reaZonCor_TRoo_Coo_set_y</code> [K] [min=None, max=None]: Zone temperature cooling setpoint for zonemid_floor_cor
            </li>
            <li>
            <code>hvac_floor2_reaZonCor_TRoo_Hea_set_y</code> [K] [min=None, max=None]: Zone temperature heating setpoint for zone mid_floor_cor
            </li>
            <li>
            <code>hvac_floor2_reaZonCor_TSup_y</code> [K] [min=None, max=None]: Discharge air temperature to zone measurement for zone mid_floor_cor
            </li>
            <li>
            <code>hvac_floor2_reaZonCor_TZon_y</code> [K] [min=None, max=None]: Zone air temperature measurement for zone mid_floor_cor
            </li>
            <li>
            <code>hvac_floor2_reaZonCor_V_flow_set_y</code> [m3/s] [min=None, max=None]: Airflow setpointmid_floor_cor
            </li>
            <li>
            <code>hvac_floor2_reaZonCor_V_flow_y</code> [m3/s] [min=None, max=None]: Discharge air flowrate to zone measurement for zone mid_floor_cor
            </li>
            <li>
            <code>hvac_floor2_reaZonCor_yCoo_y</code> [1] [min=None, max=None]: Cooling PID signal measurement for zone mid_floor_cor
            </li>
            <li>
            <code>hvac_floor2_reaZonCor_yDam_y</code> [1] [min=None, max=None]: Damper position measurement for zone mid_floor_cor
            </li>
            <li>
            <code>hvac_floor2_reaZonCor_yHea_y</code> [1] [min=None, max=None]: Heating PID signal measurement for zone mid_floor_cor
            </li>
            <li>
            <code>hvac_floor2_reaZonCor_yReheaVal_y</code> [1] [min=None, max=None]: Reheat valve position measurement for zone mid_floor_cor
            </li>
            <li>
            <code>hvac_floor2_reaZonEas_TRoo_Coo_set_y</code> [K] [min=None, max=None]: Zone temperature cooling setpoint for zonemid_floor_eas
            </li>
            <li>
            <code>hvac_floor2_reaZonEas_TRoo_Hea_set_y</code> [K] [min=None, max=None]: Zone temperature heating setpoint for zone mid_floor_eas
            </li>
            <li>
            <code>hvac_floor2_reaZonEas_TSup_y</code> [K] [min=None, max=None]: Discharge air temperature to zone measurement for zone mid_floor_eas
            </li>
            <li>
            <code>hvac_floor2_reaZonEas_TZon_y</code> [K] [min=None, max=None]: Zone air temperature measurement for zone mid_floor_eas
            </li>
            <li>
            <code>hvac_floor2_reaZonEas_V_flow_set_y</code> [m3/s] [min=None, max=None]: Airflow setpointmid_floor_eas
            </li>
            <li>
            <code>hvac_floor2_reaZonEas_V_flow_y</code> [m3/s] [min=None, max=None]: Discharge air flowrate to zone measurement for zone mid_floor_eas
            </li>
            <li>
            <code>hvac_floor2_reaZonEas_yCoo_y</code> [1] [min=None, max=None]: Cooling PID signal measurement for zone mid_floor_eas
            </li>
            <li>
            <code>hvac_floor2_reaZonEas_yDam_y</code> [1] [min=None, max=None]: Damper position measurement for zone mid_floor_eas
            </li>
            <li>
            <code>hvac_floor2_reaZonEas_yHea_y</code> [1] [min=None, max=None]: Heating PID signal measurement for zone mid_floor_eas
            </li>
            <li>
            <code>hvac_floor2_reaZonEas_yReheaVal_y</code> [1] [min=None, max=None]: Reheat valve position measurement for zone mid_floor_eas
            </li>
            <li>
            <code>hvac_floor2_reaZonNor_TRoo_Coo_set_y</code> [K] [min=None, max=None]: Zone temperature cooling setpoint for zonemid_floor_nor
            </li>
            <li>
            <code>hvac_floor2_reaZonNor_TRoo_Hea_set_y</code> [K] [min=None, max=None]: Zone temperature heating setpoint for zone mid_floor_nor
            </li>
            <li>
            <code>hvac_floor2_reaZonNor_TSup_y</code> [K] [min=None, max=None]: Discharge air temperature to zone measurement for zone mid_floor_nor
            </li>
            <li>
            <code>hvac_floor2_reaZonNor_TZon_y</code> [K] [min=None, max=None]: Zone air temperature measurement for zone mid_floor_nor
            </li>
            <li>
            <code>hvac_floor2_reaZonNor_V_flow_set_y</code> [m3/s] [min=None, max=None]: Airflow setpointmid_floor_nor
            </li>
            <li>
            <code>hvac_floor2_reaZonNor_V_flow_y</code> [m3/s] [min=None, max=None]: Discharge air flowrate to zone measurement for zone mid_floor_nor
            </li>
            <li>
            <code>hvac_floor2_reaZonNor_yCoo_y</code> [1] [min=None, max=None]: Cooling PID signal measurement for zone mid_floor_nor
            </li>
            <li>
            <code>hvac_floor2_reaZonNor_yDam_y</code> [1] [min=None, max=None]: Damper position measurement for zone mid_floor_nor
            </li>
            <li>
            <code>hvac_floor2_reaZonNor_yHea_y</code> [1] [min=None, max=None]: Heating PID signal measurement for zone mid_floor_nor
            </li>
            <li>
            <code>hvac_floor2_reaZonNor_yReheaVal_y</code> [1] [min=None, max=None]: Reheat valve position measurement for zone mid_floor_nor
            </li>
            <li>
            <code>hvac_floor2_reaZonSou_TRoo_Coo_set_y</code> [K] [min=None, max=None]: Zone temperature cooling setpoint for zonemid_floor_sou
     "
     + "       </li>
            <li>
            <code>hvac_floor2_reaZonSou_TRoo_Hea_set_y</code> [K] [min=None, max=None]: Zone temperature heating setpoint for zone mid_floor_sou
            </li>
            <li>
            <code>hvac_floor2_reaZonSou_TSup_y</code> [K] [min=None, max=None]: Discharge air temperature to zone measurement for zone mid_floor_sou
            </li>
            <li>
            <code>hvac_floor2_reaZonSou_TZon_y</code> [K] [min=None, max=None]: Zone air temperature measurement for zone mid_floor_sou
            </li>
            <li>
            <code>hvac_floor2_reaZonSou_V_flow_set_y</code> [m3/s] [min=None, max=None]: Airflow setpointmid_floor_sou
            </li>
            <li>
            <code>hvac_floor2_reaZonSou_V_flow_y</code> [m3/s] [min=None, max=None]: Discharge air flowrate to zone measurement for zone mid_floor_sou
            </li>
            <li>
            <code>hvac_floor2_reaZonSou_yCoo_y</code> [1] [min=None, max=None]: Cooling PID signal measurement for zone mid_floor_sou
            </li>
            <li>
            <code>hvac_floor2_reaZonSou_yDam_y</code> [1] [min=None, max=None]: Damper position measurement for zone mid_floor_sou
            </li>
            <li>
            <code>hvac_floor2_reaZonSou_yHea_y</code> [1] [min=None, max=None]: Heating PID signal measurement for zone mid_floor_sou
            </li>
            <li>
            <code>hvac_floor2_reaZonSou_yReheaVal_y</code> [1] [min=None, max=None]: Reheat valve position measurement for zone mid_floor_sou
            </li>
            <li>
            <code>hvac_floor2_reaZonWes_TRoo_Coo_set_y</code> [K] [min=None, max=None]: Zone temperature cooling setpoint for zonemid_floor_wes
            </li>
            <li>
            <code>hvac_floor2_reaZonWes_TRoo_Hea_set_y</code> [K] [min=None, max=None]: Zone temperature heating setpoint for zone mid_floor_wes
            </li>
            <li>
            <code>hvac_floor2_reaZonWes_TSup_y</code> [K] [min=None, max=None]: Discharge air temperature to zone measurement for zone mid_floor_wes
            </li>
            <li>
            <code>hvac_floor2_reaZonWes_TZon_y</code> [K] [min=None, max=None]: Zone air temperature measurement for zone mid_floor_wes
            </li>
            <li>
            <code>hvac_floor2_reaZonWes_V_flow_set_y</code> [m3/s] [min=None, max=None]: Airflow setpointmid_floor_wes
            </li>
            <li>
            <code>hvac_floor2_reaZonWes_V_flow_y</code> [m3/s] [min=None, max=None]: Discharge air flowrate to zone measurement for zone mid_floor_wes
            </li>
            <li>
            <code>hvac_floor2_reaZonWes_yCoo_y</code> [1] [min=None, max=None]: Cooling PID signal measurement for zone mid_floor_wes
            </li>
            <li>
            <code>hvac_floor2_reaZonWes_yDam_y</code> [1] [min=None, max=None]: Damper position measurement for zone mid_floor_wes
            </li>
            <li>
            <code>hvac_floor2_reaZonWes_yHea_y</code> [1] [min=None, max=None]: Heating PID signal measurement for zone mid_floor_wes
            </li>
            <li>
            <code>hvac_floor2_reaZonWes_yReheaVal_y</code> [1] [min=None, max=None]: Reheat valve position measurement for zone mid_floor_wes
            </li>
            <li>
            <code>hvac_floor2_readAhu_PFanTot_y</code> [W] [min=None, max=None]: Total electrical power measurement of supply and return fans for AHU
            </li>
            <li>
            <code>hvac_floor2_readAhu_TCooCoiRet_y</code> [K] [min=None, max=None]: Cooling coil return water temperature measurement for AHU
            </li>
            <li>
            <code>hvac_floor2_readAhu_TCooCoiSup_y</code> [K] [min=None, max=None]: Cooling coil supply water temperature measurement for AHU
            </li>
            <li>
            <code>hvac_floor2_readAhu_TMix_y</code> [K] [min=None, max=None]: Mixed air temperature measurement for AHU
            </li>
            <li>
            <code>hvac_floor2_readAhu_TRet_y</code> [K] [min=None, max=None]: Return air temperature measurement for AHU
            </li>
            <li>
            <code>hvac_floor2_readAhu_TSup_set_y</code> [K] [min=None, max=None]: Supply air temperature setpoint measurement for AHU
            </li>
            <li>
            <code>hvac_floor2_readAhu_TSup_y</code> [K] [min=None, max=None]: Supply air temperature measurement for AHU
            </li>
            <li>
            <code>hvac_floor2_readAhu_V_flow_OA_y</code> [m3/s] [min=None, max=None]: Supply outdoor airflow rate measurement for AHU
            </li>
            <li>
            <code>hvac_floor2_readAhu_V_flow_ret_y</code> [m3/s] [min=None, max=None]: Return air flowrate measurement for AHU
            </li>
            <li>
            <code>hvac_floor2_readAhu_V_flow_sup_y</code> [m3/s] [min=None, max=None]: Supply air flowrate measurement for AHU
            </li>
            <li>
            <code>hvac_floor2_readAhu_dp_sup_y</code> [Pa] [min=None, max=None]: Discharge pressure of supply fan for AHU
            </li>
            <li>
            <code>hvac_floor2_readAhu_occ_y</code> [1] [min=None, max=None]: Occupancy status (1 occupied, 0 unoccupied)
            </li>
            <li>
            <code>hvac_floor2_readAhu_yCooVal_y</code> [1] [min=None, max=None]: AHU cooling coil valve position measurement
            </li>
            <li>
            <code>hvac_floor2_readAhu_yOA_y</code> [1] [min=None, max=None]: AHU cooling coil valve position measurement
            </li>
            <li>
            <code>hvac_floor3_reaZonCor_TRoo_Coo_set_y</code> [K] [min=None, max=None]: Zone temperature cooling setpoint for zonetop_floor_cor
            </li>
            <li>
            <code>hvac_floor3_reaZonCor_TRoo_Hea_set_y</code> [K] [min=None, max=None]: Zone temperature heating setpoint for zone top_floor_cor
            </li>
            <li>
            <code>hvac_floor3_reaZonCor_TSup_y</code> [K] [min=None, max=None]: Discharge air temperature to zone measurement for zone top_floor_cor
            </li>
            <li>
            <code>hvac_floor3_reaZonCor_TZon_y</code> [K] [min=None, max=None]: Zone air temperature measurement for zone top_floor_cor
            </li>
            <li>
            <code>hvac_floor3_reaZonCor_V_flow_set_y</code> [m3/s] [min=None, max=None]: Airflow setpointtop_floor_cor
            </li>
            <li>
            <code>hvac_floor3_reaZonCor_V_flow_y</code> [m3/s] [min=None, max=None]: Discharge air flowrate to zone measurement for zone top_floor_cor
            </li>
            <li>
            <code>hvac_floor3_reaZonCor_yCoo_y</code> [1] [min=None, max=None]: Cooling PID signal measurement for zone top_floor_cor
            </li>
            <li>
            <code>hvac_floor3_reaZonCor_yDam_y</code> [1] [min=None, max=None]: Damper position measurement for zone top_floor_cor
            </li>
            <li>
            <code>hvac_floor3_reaZonCor_yHea_y</code> [1] [min=None, max=None]: Heating PID signal measurement for zone top_floor_cor
            </li>
            <li>
            <code>hvac_floor3_reaZonCor_yReheaVal_y</code> [1] [min=None, max=None]: Reheat valve position measurement for zone top_floor_cor
            </li>
            <li>
            <code>hvac_floor3_reaZonEas_TRoo_Coo_set_y</code> [K] [min=None, max=None]: Zone temperature cooling setpoint for zonetop_floor_eas
            </li>
            <li>
            <code>hvac_floor3_reaZonEas_TRoo_Hea_set_y</code> [K] [min=None, max=None]: Zone temperature heating setpoint for zone top_floor_eas
            </li>
            <li>
            <code>hvac_floor3_reaZonEas_TSup_y</code> [K] [min=None, max=None]: Discharge air temperature to zone measurement for zone top_floor_eas
            </li>
            <li>
            <code>hvac_floor3_reaZonEas_TZon_y</code> [K] [min=None, max=None]: Zone air temperature measurement for zone top_floor_eas
            </li>
            <li>
            <code>hvac_floor3_reaZonEas_V_flow_set_y</code> [m3/s] [min=None, max=None]: Airflow setpointtop_floor_eas
            </li>
            <li>
            <code>hvac_floor3_reaZonEas_V_flow_y</code> [m3/s] [min=None, max=None]: Discharge air flowrate to zone measurement for zone top_floor_eas
            </li>
            <li>
            <code>hvac_floor3_reaZonEas_yCoo_y</code> [1] [min=None, max=None]: Cooling PID signal measurement for zone top_floor_eas
            </li>
            <li>
            <code>hvac_floor3_reaZonEas_yDam_y</code> [1] [min=None, max=None]: Damper position measurement for zone top_floor_eas
            </li>
            <li>
            <code>hvac_floor3_reaZonEas_yHea_y</code> [1] [min=None, max=None]: Heating PID signal measurement for zone top_floor_eas
            </li>
            <li>
            <code>hvac_floor3_reaZonEas_yReheaVal_y</code> [1] [min=None, max=None]: Reheat valve position measurement for zone top_floor_eas
            </li>
            <li>
            <code>hvac_floor3_reaZonNor_TRoo_Coo_set_y</code> [K] [min=None, max=None]: Zone temperature cooling setpoint for zonetop_floor_nor
            </li>
            <li>
            <code>hvac_floor3_reaZonNor_TRoo_Hea_set_y</code> [K] [min=None, max=None]: Zone temperature heating setpoint for zone top_floor_nor
            </li>
            <li>
            <code>hvac_floor3_reaZonNor_TSup_y</code> [K] [min=None, max=None]: Discharge air temperature to zone measurement for zone top_floor_nor
            </li>
            <li>
            <code>hvac_floor3_reaZonNor_TZon_y</code> [K] [min=None, max=None]: Zone air temperature measurement for zone top_floor_nor
            </li>
            <li>
            <code>hvac_floor3_reaZonNor_V_flow_set_y</code> [m3/s] [min=None, max=None]: Airflow setpointtop_floor_nor
            </li>
            <li>
            <code>hvac_floor3_reaZonNor_V_flow_y</code> [m3/s] [min=None, max=None]: Discharge air flowrate to zone measurement for zone top_floor_nor
            </li>
            <li>
            <code>hvac_floor3_reaZonNor_yCoo_y</code> [1] [min=None, max=None]: Cooling PID signal measurement for zone top_floor_nor
            </li>
            <li>
            <code>hvac_floor3_reaZonNor_yDam_y</code> [1] [min=None, max=None]: Damper position measurement for zone top_floor_nor
            </li>
            <li>
            <code>hvac_floor3_reaZonNor_yHea_y</code> [1] [min=None, max=None]: Heating PID signal measurement for zone top_floor_nor
            </li>
            <li>
            <code>hvac_floor3_reaZonNor_yReheaVal_y</code> [1] [min=None, max=None]: Reheat valve position measurement for zone top_floor_nor
            </li>
            <li>
            <code>hvac_floor3_reaZonSou_TRoo_Coo_set_y</code> [K] [min=None, max=None]: Zone temperature cooling setpoint for zonetop_floor_sou
            </li>
            <li>
            <code>hvac_floor3_reaZonSou_TRoo_Hea_set_y</code> [K] [min=None, max=None]: Zone temperature heating setpoint for zone top_floor_sou
            </li>
            <li>
            <code>hvac_floor3_reaZonSou_TSup_y</code> [K] [min=None, max=None]: Discharge air temperature to zone measurement for zone top_floor_sou
            </li>
            <li>
            <code>hvac_floor3_reaZonSou_TZon_y</code> [K] [min=None, max=None]: Zone air temperature measurement for zone top_floor_sou
            </li>
            <li>
            <code>hvac_floor3_reaZonSou_V_flow_set_y</code> [m3/s] [min=None, max=None]: Airflow setpointtop_floor_sou
            </li>
            <li>
            <code>hvac_floor3_reaZonSou_V_flow_y</code> [m3/s] [min=None, max=None]: Discharge air flowrate to zone measurement for zone top_floor_sou
            </li>
            <li>
            <code>hvac_floor3_reaZonSou_yCoo_y</code> [1] [min=None, max=None]: Cooling PID signal measurement for zone top_floor_sou
            </li>
            <li>
            <code>hvac_floor3_reaZonSou_yDam_y</code> [1] [min=None, max=None]: Damper position measurement for zone top_floor_sou
            </li>
            <li>
            <code>hvac_floor3_reaZonSou_yHea_y</code> [1] [min=None, max=None]: Heating PID signal measurement for zone top_floor_sou
            </li>
            <li>
            <code>hvac_floor3_reaZonSou_yReheaVal_y</code> [1] [min=None, max=None]: Reheat valve position measurement for zone top_floor_sou
            </li>
            <li>
            <code>hvac_floor3_reaZonWes_TRoo_Coo_set_y</code> [K] [min=None, max=None]: Zone temperature cooling setpoint for zonetop_floor_wes
            </li>
            <li>
            <code>hvac_floor3_reaZonWes_TRoo_Hea_set_y</code> [K] [min=None, max=None]: Zone temperature heating setpoint for zone top_floor_wes
            </li>
            <li>
            <code>hvac_floor3_reaZonWes_TSup_y</code> [K] [min=None, max=None]: Discharge air temperature to zone measurement for zone top_floor_wes
            </li>
            <li>
            <code>hvac_floor3_reaZonWes_TZon_y</code> [K] [min=None, max=None]: Zone air temperature measurement for zone top_floor_wes
            </li>
            <li>
            <code>hvac_floor3_reaZonWes_V_flow_set_y</code> [m3/s] [min=None, max=None]: Airflow setpointtop_floor_wes
            </li>
            <li>
            <code>hvac_floor3_reaZonWes_V_flow_y</code> [m3/s] [min=None, max=None]: Discharge air flowrate to zone measurement for zone top_floor_wes
            </li>
            <li>
            <code>hvac_floor3_reaZonWes_yCoo_y</code> [1] [min=None, max=None]: Cooling PID signal measurement for zone top_floor_wes
            </li>
            <li>
            <code>hvac_floor3_reaZonWes_yDam_y</code> [1] [min=None, max=None]: Damper position measurement for zone top_floor_wes
            </li>
            <li>
            <code>hvac_floor3_reaZonWes_yHea_y</code> [1] [min=None, max=None]: Heating PID signal measurement for zone top_floor_wes
            </li>
            <li>
            <code>hvac_floor3_reaZonWes_yReheaVal_y</code> [1] [min=None, max=None]: Reheat valve position measurement for zone top_floor_wes
            </li>
            <li>
            <code>hvac_floor3_readAhu_PFanTot_y</code> [W] [min=None, max=None]: Total electrical power measurement of supply and return fans for AHU
            </li>
            <li>
            <code>hvac_floor3_readAhu_TCooCoiRet_y</code> [K] [min=None, max=None]: Cooling coil return water temperature measurement for AHU
            </li>
            <li>
            <code>hvac_floor3_readAhu_TCooCoiSup_y</code> [K] [min=None, max=None]: Cooling coil supply water temperature measurement for AHU
            </li>
            <li>
            <code>hvac_floor3_readAhu_TMix_y</code> [K] [min=None, max=None]: Mixed air temperature measurement for AHU
            </li>
            <li>
            <code>hvac_floor3_readAhu_TRet_y</code> [K] [min=None, max=None]: Return air temperature measurement for AHU
            </li>
            <li>
            <code>hvac_floor3_readAhu_TSup_set_y</code> [K] [min=None, max=None]: Supply air temperature setpoint measurement for AHU
            </li>
            <li>
            <code>hvac_floor3_readAhu_TSup_y</code> [K] [min=None, max=None]: Supply air temperature measurement for AHU
            </li>
            <li>
            <code>hvac_floor3_readAhu_V_flow_OA_y</code> [m3/s] [min=None, max=None]: Supply outdoor airflow rate measurement for AHU
            </li>
            <li>
            <code>hvac_floor3_readAhu_V_flow_ret_y</code> [m3/s] [min=None, max=None]: Return air flowrate measurement for AHU
            </li>
            <li>
            <code>hvac_floor3_readAhu_V_flow_sup_y</code> [m3/s] [min=None, max=None]: Supply air flowrate measurement for AHU
            </li>
            <li>
            <code>hvac_floor3_readAhu_dp_sup_y</code> [Pa] [min=None, max=None]: Discharge pressure of supply fan for AHU
            </li>
            <li>
            <code>hvac_floor3_readAhu_occ_y</code> [1] [min=None, max=None]: Occupancy status (1 occupied, 0 unoccupied)
            </li>
            <li>
            <code>hvac_floor3_readAhu_yCooVal_y</code> [1] [min=None, max=None]: AHU cooling coil valve position measurement
            </li>
            <li>
            <code>hvac_floor3_readAhu_yOA_y</code> [1] [min=None, max=None]: AHU cooling coil valve position measurement
            </li>
            <li>
            <code>hvac_reaChiWatSys_TW_y</code> [K] [min=None, max=None]: Chilled water temperature measurement
            </li>
            <li>
            <code>hvac_reaChiWatSys_dp_y</code> [K] [min=None, max=None]: Differential pressure of chilled/hot water measurement
            </li>
            <li>
            <code>hvac_reaChiWatSys_reaPChi_y</code> [W] [min=None, max=None]: Multiple chiller power consumption
            </li>
            <li>
            <code>hvac_reaChiWatSys_reaPCooTow_y</code> [W] [min=None, max=None]: Multiple cooling tower power consumption
            </li>
            <li>
            <code>hvac_reaChiWatSys_reaPPum_y</code> [W] [min=None, max=None]: Chilled water plant pump power consumption
            </li>
            <li>
            <code>hvac_reaHotWatSys_TW_y</code> [K] [min=None, max=None]: Chilled water temperature measurement
            </li>
            <li>
            <code>hvac_reaHotWatSys_dp_y</code> [K] [min=None, max=None]: Differential pressure of chilled/hot water measurement
            </li>
            <li>
            <code>hvac_reaHotWatSys_reaPBoi_y</code> [W] [min=None, max=None]: Multiple gas power consumption
            </li>
            <li>
            <code>hvac_reaHotWatSys_reaPPum_y</code> [W] [min=None, max=None]: Chilled water plant pump power consumption
            </li>
            <li>
            <code>loaEPlus_weatherStation_reaWeaCeiHei_y</code> [m] [min=None, max=None]: Cloud cover ceiling height measurement
            </li>
            <li>
            <code>loaEPlus_weatherStation_reaWeaCloTim_y</code> [s] [min=None, max=None]: Day number with units of seconds
            </li>
            <li>
            <code>loaEPlus_weatherStation_reaWeaHDifHor_y</code> [W/m2] [min=None, max=None]: Horizontal diffuse solar radiation measurement
            </li>
            <li>
            <code>loaEPlus_weatherStation_reaWeaHDirNor_y</code> [W/m2] [min=None, max=None]: Direct normal radiation measurement
            </li>
            <li>
            <code>loaEPlus_weatherStation_reaWeaHGloHor_y</code> [W/m2] [min=None, max=None]: Global horizontal solar irradiation measurement
            </li>
            <li>
            <code>loaEPlus_weatherStation_reaWeaHHorIR_y</code> [W/m2] [min=None, max=None]: Horizontal infrared irradiation measurement
            </li>
            <li>
            <code>loaEPlus_weatherStation_reaWeaLat_y</code> [rad] [min=None, max=None]: Latitude of the location
            </li>
            <li>
            <code>loaEPlus_weatherStation_reaWeaLon_y</code> [rad] [min=None, max=None]: Longitude of the location
            </li>
            <li>
            <code>loaEPlus_weatherStation_reaWeaNOpa_y</code> [1] [min=None, max=None]: Opaque sky cover measurement
            </li>
            <li>
            <code>loaEPlus_weatherStation_reaWeaNTot_y</code> [1] [min=None, max=None]: Sky cover measurement
            </li>
            <li>
            <code>loaEPlus_weatherStation_reaWeaPAtm_y</code> [Pa] [min=None, max=None]: Atmospheric pressure measurement
            </li>
            <li>
            <code>loaEPlus_weatherStation_reaWeaRelHum_y</code> [1] [min=None, max=None]: Outside relative humidity measurement
            </li>
            <li>
            <code>loaEPlus_weatherStation_reaWeaSolAlt_y</code> [rad] [min=None, max=None]: Solar altitude angle measurement
            </li>
            <li>
            <code>loaEPlus_weatherStation_reaWeaSolDec_y</code> [rad] [min=None, max=None]: Solar declination angle measurement
            </li>
            <li>
            <code>loaEPlus_weatherStation_reaWeaSolHouAng_y</code> [rad] [min=None, max=None]: Solar hour angle measurement
            </li>
            <li>
            <code>loaEPlus_weatherStation_reaWeaSolTim_y</code> [s] [min=None, max=None]: Solar time
            </li>
            <li>
            <code>loaEPlus_weatherStation_reaWeaSolZen_y</code> [rad] [min=None, max=None]: Solar zenith angle measurement
            </li>
            <li>
            <code>loaEPlus_weatherStation_reaWeaTBlaSky_y</code> [K] [min=None, max=None]: Black-body sky temperature measurement
            </li>
            <li>
            <code>loaEPlus_weatherStation_reaWeaTDewPoi_y</code> [K] [min=None, max=None]: Dew point temperature measurement
            </li>
            <li>
            <code>loaEPlus_weatherStation_reaWeaTDryBul_y</code> [K] [min=None, max=None]: Outside drybulb temperature measurement
            </li>
            <li>
            <code>loaEPlus_weatherStation_reaWeaTWetBul_y</code> [K] [min=None, max=None]: Wet bulb temperature measurement
            </li>
            <li>
            <code>loaEPlus_weatherStation_reaWeaWinDir_y</code> [rad] [min=None, max=None]: Wind direction measurement
            </li>
            <li>
            <code>loaEPlus_weatherStation_reaWeaWinSpe_y</code> [m/s] [min=None, max=None]: Wind speed measurement
            </li>
            
    </ul>
</p>
<h4>Forecasts</h4>
<p>
    The model forecasts are:
    <ul>
        <li>
            <code>EmissionsElectricPower</code> [kgCO2/kWh]: Kilograms of carbon dioxide to produce 1 kWh of electricity
            </li>
            <li>
            <code>EmissionsGasPower</code> [kgCO2/kWh]: Kilograms of carbon dioxide to produce 1 kWh thermal from gas
            </li>
            <li>
            <code>HDifHor</code> [W/m2]: Horizontal diffuse solar radiation
            </li>
            <li>
            <code>HDirNor</code> [W/m2]: Direct normal radiation
            </li>
            <li>
            <code>HGloHor</code> [W/m2]: Horizontal global radiation
            </li>
            <li>
            <code>HHorIR</code> [W/m2]: Horizontal infrared irradiation
            </li>
            <li>
            <code>InternalGainsCon[bot_floor_cor]</code> [W]: Convective internal gains of zone
            </li>
            <li>
            <code>InternalGainsCon[bot_floor_eas]</code> [W]: Convective internal gains of zone
            </li>
            <li>
            <code>InternalGainsCon[bot_floor_nor]</code> [W]: Convective internal gains of zone
            </li>
            <li>
            <code>InternalGainsCon[bot_floor_sou]</code> [W]: Convective internal gains of zone
            </li>
            <li>
            <code>InternalGainsCon[bot_floor_wes]</code> [W]: Convective internal gains of zone
            </li>
            <li>
            <code>InternalGainsCon[mid_floor_cor]</code> [W]: Convective internal gains of zone
            </li>
            <li>
            <code>InternalGainsCon[mid_floor_eas]</code> [W]: Convective internal gains of zone
            </li>
            <li>
            <code>InternalGainsCon[mid_floor_nor]</code> [W]: Convective internal gains of zone
            </li>
            <li>
            <code>InternalGainsCon[mid_floor_sou]</code> [W]: Convective internal gains of zone
            </li>
            <li>
            <code>InternalGainsCon[mid_floor_wes]</code> [W]: Convective internal gains of zone
            </li>
            <li>
            <code>InternalGainsCon[top_floor_cor]</code> [W]: Convective internal gains of zone
            </li>
            <li>
            <code>InternalGainsCon[top_floor_eas]</code> [W]: Convective internal gains of zone
            </li>
            <li>
            <code>InternalGainsCon[top_floor_nor]</code> [W]: Convective internal gains of zone
            </li>
            <li>
            <code>InternalGainsCon[top_floor_sou]</code> [W]: Convective internal gains of zone
            </li>
            <li>
            <code>InternalGainsCon[top_floor_wes]</code> [W]: Convective internal gains of zone
            </li>
            <li>
            <code>InternalGainsLat[bot_floor_cor]</code> [W]: Latent internal gains of zone
            </li>
            <li>
            <code>InternalGainsLat[bot_floor_eas]</code> [W]: Latent internal gains of zone
            </li>
            <li>
            <code>InternalGainsLat[bot_floor_nor]</code> [W]: Latent internal gains of zone
            </li>
            <li>
            <code>InternalGainsLat[bot_floor_sou]</code> [W]: Latent internal gains of zone
            </li>
            <li>
            <code>InternalGainsLat[bot_floor_wes]</code> [W]: Latent internal gains of zone
            </li>
            <li>
            <code>InternalGainsLat[mid_floor_cor]</code> [W]: Latent internal gains of zone
            </li>
            <li>
            <code>InternalGainsLat[mid_floor_eas]</code> [W]: Latent internal gains of zone
            </li>
            <li>
            <code>InternalGainsLat[mid_floor_nor]</code> [W]: Latent internal gains of zone
            </li>
            <li>
            <code>InternalGainsLat[mid_floor_sou]</code> [W]: Latent internal gains of zone
            </li>
            <li>
            <code>InternalGainsLat[mid_floor_wes]</code> [W]: Latent internal gains of zone
            </li>
            <li>
            <code>InternalGainsLat[top_floor_cor]</code> [W]: Latent internal gains of zone
            </li>
            <li>
            <code>InternalGainsLat[top_floor_eas]</code> [W]: Latent internal gains of zone
            </li>
            <li>
            <code>InternalGainsLat[top_floor_nor]</code> [W]: Latent internal gains of zone
            </li>
            <li>
            <code>InternalGainsLat[top_floor_sou]</code> [W]: Latent internal gains of zone
            </li>
            <li>
            <code>InternalGainsLat[top_floor_wes]</code> [W]: Latent internal gains of zone
            </li>
            <li>
            <code>InternalGainsRad[bot_floor_cor]</code> [W]: Radiative internal gains of zone
            </li>
            <li>
            <code>InternalGainsRad[bot_floor_eas]</code> [W]: Radiative internal gains of zone
            </li>
            <li>
            <code>InternalGainsRad[bot_floor_nor]</code> [W]: Radiative internal gains of zone
            </li>
            <li>
            <code>InternalGainsRad[bot_floor_sou]</code> [W]: Radiative internal gains of zone
            </li>
            <li>
            <code>InternalGainsRad[bot_floor_wes]</code> [W]: Radiative internal gains of zone
            </li>
            <li>
            <code>InternalGainsRad[mid_floor_cor]</code> [W]: Radiative internal gains of zone
            </li>
            <li>
            <code>InternalGainsRad[mid_floor_eas]</code> [W]: Radiative internal gains of zone
            </li>
            <li>
            <code>InternalGainsRad[mid_floor_nor]</code> [W]: Radiative internal gains of zone
            </li>
            <li>
            <code>InternalGainsRad[mid_floor_sou]</code> [W]: Radiative internal gains of zone
            </li>
            <li>
            <code>InternalGainsRad[mid_floor_wes]</code> [W]: Radiative internal gains of zone
            </li>
            <li>
            <code>InternalGainsRad[top_floor_cor]</code> [W]: Radiative internal gains of zone
            </li>
            <li>
            <code>InternalGainsRad[top_floor_eas]</code> [W]: Radiative internal gains of zone
            </li>
            <li>
            <code>InternalGainsRad[top_floor_nor]</code> [W]: Radiative internal gains of zone
            </li>
            <li>
            <code>InternalGainsRad[top_floor_sou]</code> [W]: Radiative internal gains of zone
            </li>
            <li>
            <code>InternalGainsRad[top_floor_wes]</code> [W]: Radiative internal gains of zone
            </li>
            <li>
            <code>LowerSetp[bot_floor_cor]</code> [K]: Lower temperature set point for thermal comfort of zone
            </li>
            <li>
            <code>LowerSetp[bot_floor_eas]</code> [K]: Lower temperature set point for thermal comfort of zone
            </li>
            <li>
            <code>LowerSetp[bot_floor_nor]</code> [K]: Lower temperature set point for thermal comfort of zone
            </li>
            <li>
            <code>LowerSetp[bot_floor_sou]</code> [K]: Lower temperature set point for thermal comfort of zone
            </li>
            <li>
            <code>LowerSetp[bot_floor_wes]</code> [K]: Lower temperature set point for thermal comfort of zone
            </li>
            <li>
            <code>LowerSetp[mid_floor_cor]</code> [K]: Lower temperature set point for thermal comfort of zone
            </li>
            <li>
            <code>LowerSetp[mid_floor_eas]</code> [K]: Lower temperature set point for thermal comfort of zone
            </li>
            <li>
            <code>LowerSetp[mid_floor_nor]</code> [K]: Lower temperature set point for thermal comfort of zone
            </li>
            <li>
            <code>LowerSetp[mid_floor_sou]</code> [K]: Lower temperature set point for thermal comfort of zone
            </li>
            <li>
            <code>LowerSetp[mid_floor_wes]</code> [K]: Lower temperature set point for thermal comfort of zone
            </li>
            <li>
            <code>LowerSetp[top_floor_cor]</code> [K]: Lower temperature set point for thermal comfort of zone
            </li>
            <li>
            <code>LowerSetp[top_floor_eas]</code> [K]: Lower temperature set point for thermal comfort of zone
           "
           + " </li>
            <li>
            <code>LowerSetp[top_floor_nor]</code> [K]: Lower temperature set point for thermal comfort of zone
            </li>
            <li>
            <code>LowerSetp[top_floor_sou]</code> [K]: Lower temperature set point for thermal comfort of zone
            </li>
            <li>
            <code>LowerSetp[top_floor_wes]</code> [K]: Lower temperature set point for thermal comfort of zone
            </li>
            <li>
            <code>Occupancy[bot_floor_cor]</code> [number of people]: Number of occupants of zone
            </li>
            <li>
            <code>Occupancy[bot_floor_eas]</code> [number of people]: Number of occupants of zone
            </li>
            <li>
            <code>Occupancy[bot_floor_nor]</code> [number of people]: Number of occupants of zone
            </li>
            <li>
            <code>Occupancy[bot_floor_sou]</code> [number of people]: Number of occupants of zone
            </li>
            <li>
            <code>Occupancy[bot_floor_wes]</code> [number of people]: Number of occupants of zone
            </li>
            <li>
            <code>Occupancy[mid_floor_cor]</code> [number of people]: Number of occupants of zone
            </li>
            <li>
            <code>Occupancy[mid_floor_eas]</code> [number of people]: Number of occupants of zone
            </li>
            <li>
            <code>Occupancy[mid_floor_nor]</code> [number of people]: Number of occupants of zone
            </li>
            <li>
            <code>Occupancy[mid_floor_sou]</code> [number of people]: Number of occupants of zone
            </li>
            <li>
            <code>Occupancy[mid_floor_wes]</code> [number of people]: Number of occupants of zone
            </li>
            <li>
            <code>Occupancy[top_floor_cor]</code> [number of people]: Number of occupants of zone
            </li>
            <li>
            <code>Occupancy[top_floor_eas]</code> [number of people]: Number of occupants of zone
            </li>
            <li>
            <code>Occupancy[top_floor_nor]</code> [number of people]: Number of occupants of zone
            </li>
            <li>
            <code>Occupancy[top_floor_sou]</code> [number of people]: Number of occupants of zone
            </li>
            <li>
            <code>Occupancy[top_floor_wes]</code> [number of people]: Number of occupants of zone
            </li>
            <li>
            <code>PriceElectricPowerConstant</code> [($/Euro)/kWh]: Completely constant electricity price
            </li>
            <li>
            <code>PriceElectricPowerDynamic</code> [($/Euro)/kWh]: Electricity price for a day/night tariff
            </li>
            <li>
            <code>PriceElectricPowerHighlyDynamic</code> [($/Euro)/kWh]: Spot electricity price
            </li>
            <li>
            <code>PriceGasPower</code> [($/Euro)/kWh]: Price to produce 1 kWh thermal from gas
            </li>
            <li>
            <code>TBlaSky</code> [K]: Black Sky temperature
            </li>
            <li>
            <code>TDewPoi</code> [K]: Dew point temperature
            </li>
            <li>
            <code>TDryBul</code> [K]: Dry bulb temperature at ground level
            </li>
            <li>
            <code>TWetBul</code> [K]: Wet bulb temperature
            </li>
            <li>
            <code>UpperCO2[bot_floor_cor]</code> [ppm]: Upper CO2 set point for indoor air quality of zone
            </li>
            <li>
            <code>UpperCO2[bot_floor_eas]</code> [ppm]: Upper CO2 set point for indoor air quality of zone
            </li>
            <li>
            <code>UpperCO2[bot_floor_nor]</code> [ppm]: Upper CO2 set point for indoor air quality of zone
            </li>
            <li>
            <code>UpperCO2[bot_floor_sou]</code> [ppm]: Upper CO2 set point for indoor air quality of zone
            </li>
            <li>
            <code>UpperCO2[bot_floor_wes]</code> [ppm]: Upper CO2 set point for indoor air quality of zone
            </li>
            <li>
            <code>UpperCO2[mid_floor_cor]</code> [ppm]: Upper CO2 set point for indoor air quality of zone
            </li>
            <li>
            <code>UpperCO2[mid_floor_eas]</code> [ppm]: Upper CO2 set point for indoor air quality of zone
            </li>
            <li>
            <code>UpperCO2[mid_floor_nor]</code> [ppm]: Upper CO2 set point for indoor air quality of zone
            </li>
            <li>
            <code>UpperCO2[mid_floor_sou]</code> [ppm]: Upper CO2 set point for indoor air quality of zone
            </li>
            <li>
            <code>UpperCO2[mid_floor_wes]</code> [ppm]: Upper CO2 set point for indoor air quality of zone
            </li>
            <li>
            <code>UpperCO2[top_floor_cor]</code> [ppm]: Upper CO2 set point for indoor air quality of zone
            </li>
            <li>
            <code>UpperCO2[top_floor_eas]</code> [ppm]: Upper CO2 set point for indoor air quality of zone
            </li>
            <li>
            <code>UpperCO2[top_floor_nor]</code> [ppm]: Upper CO2 set point for indoor air quality of zone
            </li>
            <li>
            <code>UpperCO2[top_floor_sou]</code> [ppm]: Upper CO2 set point for indoor air quality of zone
            </li>
            <li>
            <code>UpperCO2[top_floor_wes]</code> [ppm]: Upper CO2 set point for indoor air quality of zone
            </li>
            <li>
            <code>UpperSetp[bot_floor_cor]</code> [K]: Upper temperature set point for thermal comfort of zone
            </li>
            <li>
            <code>UpperSetp[bot_floor_eas]</code> [K]: Upper temperature set point for thermal comfort of zone
            </li>
            <li>
            <code>UpperSetp[bot_floor_nor]</code> [K]: Upper temperature set point for thermal comfort of zone
            </li>
            <li>
            <code>UpperSetp[bot_floor_sou]</code> [K]: Upper temperature set point for thermal comfort of zone
            </li>
            <li>
            <code>UpperSetp[bot_floor_wes]</code> [K]: Upper temperature set point for thermal comfort of zone
            </li>
            <li>
            <code>UpperSetp[mid_floor_cor]</code> [K]: Upper temperature set point for thermal comfort of zone
            </li>
            <li>
            <code>UpperSetp[mid_floor_eas]</code> [K]: Upper temperature set point for thermal comfort of zone
            </li>
            <li>
            <code>UpperSetp[mid_floor_nor]</code> [K]: Upper temperature set point for thermal comfort of zone
            </li>
            <li>
            <code>UpperSetp[mid_floor_sou]</code> [K]: Upper temperature set point for thermal comfort of zone
            </li>
            <li>
            <code>UpperSetp[mid_floor_wes]</code> [K]: Upper temperature set point for thermal comfort of zone
            </li>
            <li>
            <code>UpperSetp[top_floor_cor]</code> [K]: Upper temperature set point for thermal comfort of zone
            </li>
            <li>
            <code>UpperSetp[top_floor_eas]</code> [K]: Upper temperature set point for thermal comfort of zone
            </li>
            <li>
            <code>UpperSetp[top_floor_nor]</code> [K]: Upper temperature set point for thermal comfort of zone
            </li>
            <li>
            <code>UpperSetp[top_floor_sou]</code> [K]: Upper temperature set point for thermal comfort of zone
            </li>
            <li>
            <code>UpperSetp[top_floor_wes]</code> [K]: Upper temperature set point for thermal comfort of zone
            </li>
            <li>
            <code>ceiHei</code> [m]: Ceiling height
            </li>
            <li>
            <code>cloTim</code> [s]: One-based day number in seconds
            </li>
            <li>
            <code>lat</code> [rad]: Latitude of the location
            </li>
            <li>
            <code>lon</code> [rad]: Longitude of the location
            </li>
            <li>
            <code>nOpa</code> [1]: Opaque sky cover [0, 1]
            </li>
            <li>
            <code>nTot</code> [1]: Total sky Cover [0, 1]
            </li>
            <li>
            <code>pAtm</code> [Pa]: Atmospheric pressure
            </li>
            <li>
            <code>relHum</code> [1]: Relative Humidity
            </li>
            <li>
            <code>solAlt</code> [rad]: Altitude angel
            </li>
            <li>
            <code>solDec</code> [rad]: Declination angle
            </li>
            <li>
            <code>solHouAng</code> [rad]: Solar hour angle.
            </li>
            <li>
            <code>solTim</code> [s]: Solar time
            </li>
            <li>
            <code>solZen</code> [rad]: Zenith angle
            </li>
            <li>
            <code>winDir</code> [rad]: Wind direction
            </li>
            <li>
            <code>winSpe</code> [m/s]: Wind speed
            </li>
            
    </ul>
</p>
<h3>Additional System Design</h3>
<h4>Lighting</h4>
<p>
    Lighting heat gain is included in the internal heat gains and is not controllable.
</p>
<h4>Shading</h4>
<p>
    There is no shading on this building.
</p>
<h4>Onsite Generation and Storage</h4>
<p>
    There is no onsite generation or storage on this building site.
</p>
<h3>
    Scenario Information
</h3>
<h4>Time Periods</h4>
<p>
    The <b>Peak Heat Day</b> (specifier for <code>/scenario</code> API is <code>'peak_heat_day'</code>) period is:
    <ul>
    This testing time period is a two-week test with one-week warmup period utilizing
    baseline control.  The two-week period is centered on the day with the
    maximum 15-minute system heating load in the year.
    </ul>
    <ul>
    Start Time: Day 22.
    </ul>
    <ul>
    End Time: Day 36.
    </ul>
    </p>
    <p>
    The <b>Typical Heat Day</b> (specifier for <code>/scenario</code> API is <code>'typical_heat_day'</code>) period is:
    <ul>
    This testing time period is a two-week test with one-week warmup period utilizing
    baseline control.  The two-week period is centered on the day with day with
    the maximum 15-minute system heating load that is closest from below to the
    median of all 15-minute maximum heating loads of all days in the year.
    </ul>
    <ul>
    Start Time: Day 285.
    </ul>
    <ul>
    End Time: Day 299.
    </ul>
    </p>
    <p>
    The <b>Peak Cool Day</b> (specifier for <code>/scenario</code> API is <code>'peak_cool_day'</code>) period is:
    <ul>
    This testing time period is a two-week test with one-week warmup period utilizing
    baseline control.  The two-week period is centered on the day with the
    maximum 15-minute system cooling load in the year considering only daytime hours
    (peaks due to morning start up, before 10 am, not included since many days have similar peaks
    due to start up).
    </ul>
    <ul>
    Start Time: Day 178.
    </ul>
    <ul>
    End Time: Day 192.
    </ul>
    </p>
    <p>
    The <b>Typical Cool Day</b> (specifier for <code>/scenario</code> API is <code>'typical_cool_day'</code>) period is:
    <ul>
    This testing time period is a two-week test with one-week warmup period utilizing
    baseline control.  The two-week period is centered on the day with
    the maximum 15-minute system cooling load that is closest from below to the
    median of all 15-minute maximum cooling loads of all days in the year
    (peaks due to morning start up, before 10 am, not included since many days have similar peaks
    due to start up).
    </ul>
    <ul>
    Start Time: Day 181.
    </ul>
    <ul>
    End Time: Day 195.
    </ul>
    </p>
    <p>
    The <b>Mix Day</b> (specifier for <code>/scenario</code> API is <code>'mix_day'</code>) period is:
    <ul>
    This testing time period is a two-week test with one-week warmup period utilizing
    baseline control.  The two-week period is centered on the day with the maximimum
    sum of daily heating and cooling loads minus the difference between
    daily heating and cooling loads.  This is a day with both significant heating
    and cooling loads.
    </ul>
    <ul>
    Start Time: Day 17.
    </ul>
    <ul>
    End Time: Day 31.
    </ul>
    </p>
    <h4>Energy Pricing</h4>
    <p>
    Constant electricity prices are based on those from ComEd [1], the utility serving
    the greater Chicago area.  The price is based on the Basic Electricity Service (BES)
    rate provided to the Watt-Hour customer class for applicable charges per kWh.
    This calculation is an approximation to obtain a reasonable estimate of price.
    The charges included are as follows:
    </p>
    <ul>
    <li>
    PJM Services Charge: $0.01211
    </li>
    <li>
    Retail Purchased Electricity Charge: $0.05158
    </li>
    <li>
    Delivery Services Charge:
    i) Distribution Facilities Charge: $0.01935
    ii) Illinois Electricity Distribution Tax Charge: $0.00121
    </li>
    <li>
    Rider ECR - Environmental Cost Recovery Adjustment: $0.00031
    </li>
    <li>
    Rider EEPP - Energy Efficiency Pricing and Performance: $0.0026
    </li>
    <li>
    Rider REA - Renewable Energy Adjustment: $0.00189
    </li>
    <li>
    Rider TAX - Municipal and State Tax Additions: $0.003
    </li>
    <li>
    Rider ZEA - Zero Emission Adjustment: $0.00195
    </li>
    </ul>
    
    <p>
    The total constant electricity price is $0.094/kWh
    </p>
    <p>
    Dynamic electricity prices are based on those from ComEd [1], the utility serving
    the greater Chicago area.  The price is based on the Residential Time of Use Pricing Pilot
    (RTOUPP) rate for applicable charges per kWh.
    This calculation is an approximation to obtain a reasonable estimate of dynamic
    price.  The charges included are the same as the constant scenario (using BES)
    except for the following change:
    
    <li>
    Retail Purchased Electricity Charge:
    <p>
    Summer (Jun, Jul, Aug, Sep):
    <ul>
    <li>
    i) Super Peak Period: $0.12727, 2pm-7pm
    </li>
    <li>
    ii) Peak Period: $0.02868, 6am-2pm and 7pm-10pm
    </li>
    <li>
    iii) Off Peak Period: $0.01584, 10pm-6am
    </li>
    </ul>
    Winter:
    <ul>
    <li>
    i) Super Peak Period: $0.11748, 2pm-7pm
    </li>
    <li>
    ii) Peak Period: $0.02664, 6am-2pm and 7pm-10pm
    </li>
    <li>
    iii) Off Peak Period: $0.01629, 10pm-6am
    </li>
    </ul>
    </p>
    </li>
    </p>
    <p>
    Highly Dynamic electricity prices are based on those from ComEd [1], the utility serving
    the greater Chicago area.  The price is based on the Basic Electric Service Hourly Pricing
    (BESH) rate for applicable charges per kWh.
    This calculation is an approximation to obtain a reasonable estimate of
    highly dynamic price.  The charges included are the same as the constant
    scenario (using BES) except for the following change:
    
    <li>
    PJM Services Charge: $0.00836
    </li>
    <li>
    Retail Purchased Electricity Charge: Based on Wholesale Day-Ahead Prices
    for the year of 2019 based on [2].
    </li>
    </p>
    
    <p>
    References:
    <li>
    [1] https://www.comed.com/MyAccount/MyBillUsage/Pages/CurrentRatesTariffs.aspx
    </li>
    <li>
    [2] https://secure.comed.com/MyAccount/MyBillUsage/Pages/RatesPricing.aspx
    </li>
    </p>
    <h4>Emission Factors</h4>
    <p>
    The Electricity Emissions Factor profile is based on the average annual emissions
    from 2019 for the state of Illinois, USA per the EIA.
    It is 752 lbs/MWh or 0.341 kgCO2/kWh.
    For reference, see https://www.eia.gov/electricity/state/illinois/
    </p>




</html>"));
end TestCase;