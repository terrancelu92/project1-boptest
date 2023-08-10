within RohobothHeatPump;
model TestCase
  extends Modelica.Icons.Example;

  replaceable package MediumA = Buildings.Media.Air
    constrainedby Modelica.Media.Interfaces.PartialCondensingGases
    "Medium model for air";

  parameter Modelica.Units.SI.PressureDifference dpAir_nominal=75
    "Pressure drop at m_flow_nominal";

  parameter Modelica.Units.SI.PressureDifference dpDX_nominal=75
    "Pressure drop at m_flow_nominal";

  parameter Modelica.Units.SI.Time averagingTimestep = 3600
    "Time-step used to average out Modelica results for comparison with EPlus results. Same val;ue is also applied to unit delay shift on EPlus power value";

  parameter Modelica.Units.SI.Time delayTimestep = 3600
    "Time-step used to unit delay shift on EPlus power value";

  parameter Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.BaseClasses.CoilHeatTransfer datHeaCoi(
    is_CooCoi=false,
    sta={
      Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.BaseClasses.Stage(
        spe=1800/60,
        nomVal=
          Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=7144.01,
          COP_nominal=2.75,
          SHR_nominal=1,
          m_flow_nominal=0.5075,
          TEvaIn_nominal=273.15 + 6,
          TConIn_nominal=273.15 + 21),
        perCur=
          Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Examples.PerformanceCurves.DXHeating_Curve_II())},
    nSta=1)
    "Heating coil data"
    annotation (Placement(transformation(extent={{60,90},{80,110}})));

  parameter
    Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.CoolingCoil datCooCoi(
    sta={
      Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.BaseClasses.Stage(
        spe=1800,
        nomVal=
          Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=-7144.01,
          COP_nominal=3.0,
          SHR_nominal=0.8,
          m_flow_nominal=0.5075),
        perCur=
          Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.BaseClasses.PerformanceCurve(
          capFunT={0.942587793,0.009543347,0.00068377,-0.011042676,0.000005249,-0.00000972},
          capFunFF={0.8,0.2,0},
          EIRFunT={0.342414409,0.034885008,-0.0006237,0.004977216,0.000437951,-0.000728028},
          EIRFunFF={1.1552,-0.1808,0.0256},
          TConInMin=273.15 + 18,
          TConInMax=273.15 + 46.11,
          TEvaInMin=273.15 + 12.78,
          TEvaInMax=273.15 + 23.89,
          ffMin=0.875,
          ffMax=1.125))},
    nSta=1)
    "Cooling coil data"
    annotation (Placement(transformation(extent={{30,90},{50,110}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant damPos(
    final k=0.2)
    "Outdoor air damper position"
    annotation (Placement(transformation(extent={{-130,40},{-110,60}})));

  Buildings.Fluid.ZoneEquipment.PackagedTerminalHeatPump.PackagedTerminalHeatPump
    pthp(
    final QSup_flow_nominal=5600.34,
    final dpCooDX_nominal= 0,
    final dpHeaDX_nominal= 0,
    final dpSupHea_nominal= 0,
    SupHeaCoi(final tau=30),
    redeclare package MediumA = MediumA,
    final mAirOut_flow_nominal=0.5075,
    final mAir_flow_nominal=0.5075,
    final dpAir_nominal= dpAir_nominal,
    datHeaCoi=datHeaCoi,
    redeclare
      Buildings.Fluid.ZoneEquipment.PackagedTerminalHeatPump.CaseStudy.Data.FanData
      fanPer,
    datCooCoi=datCooCoi,
    datDef=datDef,
    TAirMix(
      tau=10,
      initType=Modelica.Blocks.Types.Init.InitialState,
      transferHeat=true),
    TAirCooCoi(
      tau=10,
      initType=Modelica.Blocks.Types.Init.InitialState,
      transferHeat=true),
    TAirHeaCoi(
      tau=10,
      initType=Modelica.Blocks.Types.Init.InitialState,
      transferHeat=true),
    TAirOut(
      tau=10,
      initType=Modelica.Blocks.Types.Init.InitialState,
      transferHeat=true),
    TAirFanOut(
      tau=10,
      initType=Modelica.Blocks.Types.Init.InitialState,
      transferHeat=true),
    TAirLvg(
      tau=10,
      initType=Modelica.Blocks.Types.Init.InitialState,
      transferHeat=true),
    TAirRet(
      tau=10,
      initType=Modelica.Blocks.Types.Init.InitialState,
      transferHeat=true),
    TAirExh(
      tau=10,
      initType=Modelica.Blocks.Types.Init.InitialState,
      transferHeat=true))
                   "Packaged terminal heat pump instance"
    annotation (Placement(transformation(extent={{-16,-26},{24,14}})));

  Buildings.Fluid.ZoneEquipment.BaseClasses.ModularController modCon(
    final sysTyp=Buildings.Fluid.ZoneEquipment.BaseClasses.Types.SystemTypes.pthp,
    final fanTyp=Buildings.Fluid.ZoneEquipment.BaseClasses.Types.FanTypes.conSpeFan,
    final has_fanOpeMod=true,
    tFanEnaDel=0,
    tFanEna=300,
    dTHys=0.5,
    TiCoo=120,
    TiHea=120,
    dTHeaSet(displayUnit="K"))
    "Instance of modular controller with constant speed fan and DX coils"
    annotation (Placement(transformation(extent={{-80,-78},{-60,-50}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant fanOpeMod(
    final k=false)
    "Fan operating mode"
    annotation (Placement(transformation(extent={{-130,-90},{-110,-70}})));

  Buildings.Controls.OBC.CDL.Continuous.Hysteresis fanProOn(uLow=0, uHigh=0.001)
    "Check if fan is proven on based on measured fan speed"
    annotation (Placement(transformation(extent={{36,0},{56,20}})));

  inner Buildings.ThermalZones.EnergyPlus_9_6_0.Building building(
  spawnExe="spawn-0.3.0-8d93151657",
    idfName=Modelica.Utilities.Files.loadResource(
        "modelica://RohobothHeatPump/Resources/US+SF+CZ5A+hp+slab+IECC_2021.idf"),
    epwName=Modelica.Utilities.Files.loadResource(
        "modelica://RohobothHeatPump/Resources/USA_WA_Pasco-Tri.Cities.AP.727845_TMY3.epw"),
    weaName=Modelica.Utilities.Files.loadResource(
        "modelica://RohobothHeatPump/Resources/USA_WA_Pasco-Tri.Cities.AP.727845_TMY3.mos"))
    "Building instance for thermal zone, use spawnExe=spawn-0.3.0-8d93151657 for BOPTEST"
    annotation (Placement(transformation(extent={{-10,118},{10,138}})));

  Buildings.ThermalZones.EnergyPlus_9_6_0.ThermalZone zon(
    zoneName="living_unit1",
    redeclare package Medium = MediumA,
    T_start=294.15,
    final nPorts=2)
    "Thermal zone model"
    annotation (Placement(transformation(extent={{58,30},{98,70}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con[3](
    final k=fill(0, 3))
    "Zero signal for internal thermal loads"
    annotation (Placement(transformation(extent={{0,30},{20,50}})));

  Buildings.BoundaryConditions.WeatherData.Bus weaBus
    "Weather bus"
    annotation (Placement(transformation(extent={{18,110},{58,150}}),
      iconTransformation(extent={{-168,170},{-148,190}})));

  Modelica.Blocks.Routing.RealPassThrough TOut
    "Outdoor air drybulb temperature"
    annotation (Placement(transformation(extent={{62,120},{82,140}})));

  Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Examples.PerformanceCurves.DXHeating_DefrostCurve
    datDef(
    final defOpe=Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.Types.DefrostOperation.resistive,
    final defTri=Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.Types.DefrostTimeMethods.timed,
    final tDefRun=0.1666,
    final QDefResCap=10500,
    final QCraCap=200)
    "Defrost data"
    annotation (Placement(transformation(extent={{-8,90},{12,110}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea
    "Convert fan enable signal to real value"
    annotation (Placement(transformation(extent={{-40,-86},{-20,-66}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TZonHea(k=273.15 + 21)
    "Zone heating temperature setpoint"
    annotation (Placement(transformation(extent={{-130,-30},{-110,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TZonCoo(k=273.15 + 100)
    "Zone cooling temperature setpoint"
    annotation (Placement(transformation(extent={{-130,4},{-110,24}})));
  Buildings.ThermalZones.EnergyPlus_9_6_0.OutputVariable OccSch(
    name="Schedule Value",
    key="Occupancy",
    y(final unit="1", displayUnit="1"))
    "Block that reads EnergyPlus Occ Schedule"
    annotation (Placement(transformation(extent={{-130,110},{-110,130}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T=1, initType=Modelica.Blocks.Types.Init.InitialState)
    annotation (Placement(transformation(extent={{-100,110},{-80,130}})));
  Buildings.Utilities.IO.SignalExchange.Overwrite oveTZonCoo(u(
      unit="K",
      min=289.15,
      max=303.15), description=
        "Real signal to control the zone air cooling setpoint")
    "Block for overwriting zone air cooling setpoint"            annotation (
      Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-90,14})));
  Buildings.Utilities.IO.SignalExchange.Overwrite oveTZonHea(u(
      unit="K",
      min=289.15,
      max=303.15), description=
        "Real signal to control the zone air heating setpoint")
    "Block for overwriting zone air heating setpoint" annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-90,-20})));
  Buildings.Utilities.IO.SignalExchange.Read TZonMea(
    description="Zone air temperature measurement",
    KPIs=Buildings.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.AirZoneTemperature,
    y(unit="K"),
    zone="living_unit1") "Zone air temperature measurement"
    annotation (Placement(transformation(extent={{120,58},{140,78}})));

  Buildings.Utilities.IO.SignalExchange.Read TSupMea(
    description="Supply air temperature measurement",
    KPIs=Buildings.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.None,
    y(unit="K")) "Supply air temperature measurement"
    annotation (Placement(transformation(extent={{80,-70},{100,-50}})));

  Buildings.Utilities.IO.SignalExchange.Read OccSchMea(
    description="Occupancy signal",
    KPIs=Buildings.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.None,
    y(unit="1")) "Occupancy schedule signal"
    annotation (Placement(transformation(extent={{-86,80},{-66,100}})));

  Modelica.Blocks.Math.RealToBoolean realToBoolean(threshold=0.1)
    annotation (Placement(transformation(extent={{-62,110},{-42,130}})));
  Modelica.Blocks.Math.BooleanToReal booleanToReal
    annotation (Placement(transformation(extent={{-120,80},{-100,100}})));
  Buildings.Utilities.IO.SignalExchange.Read yFanMea(
    description="Indoor fan speed measurement",
    KPIs=Buildings.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.None,
    y(unit="1")) "Indoor fan speed measurement"
    annotation (Placement(transformation(extent={{80,-40},{100,-20}})));

  Buildings.Utilities.IO.SignalExchange.Read QLoaMea(
    description="Cooling or heating load measurement measurement",
    KPIs=Buildings.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.None,
    y(unit="W"),
    zone="living_unit1") "Cooling or heating load measurement"
    annotation (Placement(transformation(extent={{120,0},{140,20}})));

  Modelica.Blocks.Sources.RealExpression realExpression(y=zon.conQCon_flow.Q_flow)
    annotation (Placement(transformation(extent={{84,0},{104,20}})));
equation
  connect(fanOpeMod.y, modCon.fanOpeMod) annotation (Line(points={{-108,-80},{-100,
          -80},{-100,-73.4},{-82,-73.4}}, color={255,0,255}));
  connect(pthp.yFan_actual, fanProOn.u) annotation (Line(points={{25,10},{34,10}},
                            color={0,0,127}));
  connect(pthp.port_Air_a2, zon.ports[1])
    annotation (Line(points={{24,-2},{76,-2},{76,30.9}},
                                                       color={0,127,255}));
  connect(pthp.port_Air_b2, zon.ports[2])
    annotation (Line(points={{24,-10},{80,-10},{80,30.9}},
                                                         color={0,127,255}));
  connect(con.y, zon.qGai_flow) annotation (Line(points={{22,40},{40,40},{40,60},
          {56,60}}, color={0,0,127}));
  connect(zon.TAir, modCon.TZon) annotation (Line(points={{99,68},{108,68},{108,
          -98},{-100,-98},{-100,-54.6},{-82,-54.6}}, color={0,0,127}));
  connect(pthp.TAirSup, modCon.TSup) annotation (Line(points={{25,4},{30,4},{30,
          -88},{-96,-88},{-96,-77},{-82,-77}}, color={0,0,127}));
  connect(damPos.y,pthp. uEco) annotation (Line(points={{-108,50},{-58,50},{-58,
          12},{-17,12}},
                     color={0,0,127}));

  connect(modCon.yCooEna, pthp.uCooEna) annotation (Line(points={{-58,-52},{-30,
          -52},{-30,-20},{-17,-20}},     color={255,0,255}));
  connect(fanProOn.y, modCon.uFan) annotation (Line(points={{58,10},{60,10},{60,
          -94},{-102,-94},{-102,-51},{-82,-51}}, color={255,0,255}));
  connect(building.weaBus,pthp. weaBus) annotation (Line(
      points={{10,128},{14,128},{14,66},{-12.2,66},{-12.2,-0.4}},
      color={255,204,51},
      thickness=0.5));
  connect(weaBus, building.weaBus) annotation (Line(
      points={{38,130},{24,130},{24,128},{10,128}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(weaBus.TDryBul, TOut.u) annotation (Line(
      points={{38,130},{60,130}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(modCon.yFan, booToRea.u)
    annotation (Line(points={{-58,-76},{-42,-76}}, color={255,0,255}));
  connect(booToRea.y,pthp. uFan) annotation (Line(points={{-18,-76},{-10,-76},{-10,
          -40},{-34,-40},{-34,8},{-17,8}},     color={0,0,127}));
  connect(modCon.ySupHea, pthp.uSupHea) annotation (Line(points={{-58,-60},{-46,
          -60},{-46,-8},{-17,-8}},   color={0,0,127}));
  connect(TOut.y, modCon.TOut) annotation (Line(points={{83,130},{100,130},{100,
          80},{-68,80},{-68,-42},{-90,-42},{-90,-66},{-82,-66}},
                                         color={0,0,127}));
  connect(modCon.yHeaEna, pthp.uHeaEna) annotation (Line(points={{-58,-56},{-26,
          -56},{-26,-24},{-17,-24}},     color={255,0,255}));
  connect(OccSch.y, firstOrder.u)
    annotation (Line(points={{-109,120},{-102,120}}, color={0,0,127}));
  connect(TZonCoo.y, oveTZonCoo.u)
    annotation (Line(points={{-108,14},{-102,14}}, color={0,0,127}));
  connect(TZonHea.y, oveTZonHea.u)
    annotation (Line(points={{-108,-20},{-102,-20}}, color={0,0,127}));
  connect(oveTZonHea.y, modCon.THeaSet) annotation (Line(points={{-79,-20},{-72,
          -20},{-72,-40},{-94,-40},{-94,-62},{-82,-62}}, color={0,0,127}));
  connect(oveTZonCoo.y, modCon.TCooSet) annotation (Line(points={{-79,14},{-74,
          14},{-74,-36},{-92,-36},{-92,-58.2},{-82,-58.2}}, color={0,0,127}));
  connect(TSupMea.u, pthp.TAirSup) annotation (Line(points={{78,-60},{34,-60},{
          34,4},{25,4}}, color={0,0,127}));
  connect(zon.TAir, TZonMea.u)
    annotation (Line(points={{99,68},{118,68}}, color={0,0,127}));
  connect(firstOrder.y, realToBoolean.u)
    annotation (Line(points={{-79,120},{-64,120}}, color={0,0,127}));
  connect(realToBoolean.y, booleanToReal.u) annotation (Line(points={{-41,120},
          {-28,120},{-28,108},{-134,108},{-134,90},{-122,90}}, color={255,0,255}));
  connect(booleanToReal.y, OccSchMea.u)
    annotation (Line(points={{-99,90},{-88,90}}, color={0,0,127}));
  connect(realToBoolean.y, modCon.uAva) annotation (Line(points={{-41,120},{-40,
          120},{-40,-48},{-104,-48},{-104,-70},{-82,-70}}, color={255,0,255}));
  connect(pthp.yFan_actual, yFanMea.u) annotation (Line(points={{25,10},{32,10},
          {32,-30},{78,-30}}, color={0,0,127}));
  connect(realExpression.y, QLoaMea.u)
    annotation (Line(points={{105,10},{118,10}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-140,
            -120},{140,140}})),
      Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,-120},{
            140,140}}),
                    graphics={Polygon(points={{-48,-16},{-48,-16}}, lineColor={28,
              108,200})}),
    experiment(
      StartTime=86400,
      StopTime=691200,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
    Documentation(info="<html>
    <p>
    This is a validation model for the packaged terminal heat pump (PTHP) system model under heating mode 
    with a modular controller. The validation model consists of: </p>
    <ul>
    <li>
    An instance of the PTHP system model <code>PackagedTerminalHeatPump</code>. 
    </li>
    <li>
    A thermal zone model <code>zon</code> of class 
    <a href=\"modelica://Buildings.ThermalZones.EnergyPlus_9_6_0.ThermalZone\">
    Buildings.ThermalZones.EnergyPlus_9_6_0.ThermalZone</a>. 
    </li>
    <li>
    A modular controller <code>ModularController</code> of class 
    <a href=\"modelica://Buildings.Fluid.ZoneEquipment.BaseClasses.ModularController\">
    Buildings.Fluid.ZoneEquipment.BaseClasses.ModularController</a>. 
    </li>
    </ul>
    <p>
    The validation model provides a closed-loop example of <code>PackagedTerminalHeatPump</code> that 
    is operated by <code>ModularController</code> to regulate the zone temperature in 
    <code>zon</code> at its heating setpoint. The electric supplemental heating coil is activated 
    when the outdoor temperature is below the minimum outdoor air drybulb temperature limit.
    </p>
    </html>
    ", revisions="<html>
    <ul>
    <li>
    June 21, 2023, by Xing Lu, Karthik Devaprasad, and Junke Wang:<br/>
    First implementation.
    </li>
    </ul>
    </html>"));
end TestCase;
