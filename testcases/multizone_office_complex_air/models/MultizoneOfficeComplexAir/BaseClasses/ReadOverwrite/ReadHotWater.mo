within MultizoneOfficeComplexAir.BaseClasses.ReadOverwrite;
model ReadHotWater
  "Collection of Hot Water System measurements for BOPTEST"

  Buildings.Utilities.IO.SignalExchange.Read dp(
    description="Differential pressure of chilled/hot water measurement",
    KPIs=Buildings.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.None,
    y(unit="K")) "Differential pressure of chilled/hot water measurement"
    annotation (Placement(transformation(extent={{-10,70},{10,90}})));

  Buildings.Utilities.IO.SignalExchange.Read TW(
    description="Chilled water temperature measurement",
    KPIs=Buildings.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.None,
    y(unit="K")) "Chilled/hot water temperature measurement"
    annotation (Placement(transformation(extent={{-10,30},{10,50}})));

  Modelica.Blocks.Interfaces.RealInput dp_in
    "Differential pressure of chilled/hot water measurement"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
  Modelica.Blocks.Interfaces.RealInput TW_in "CHW/HW temperature measurement"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));

  Buildings.Utilities.IO.SignalExchange.Read reaPPum(
    description="Chilled water plant pump power consumption",
    KPIs=Buildings.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.ElectricPower,
    y(unit="W")) "Block for outputting the chilled water plant"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  Buildings.Utilities.IO.SignalExchange.Read reaPBoi(
    description="Multiple gas power consumption",
    KPIs=Buildings.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.GasPower,
    y(unit="W"))  "Block for outputting the multiple boilers"
    annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));

  Modelica.Blocks.Interfaces.RealInput PPum_in "Water pump power"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealInput PBoi_in  "Boiler power "
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));

equation
  connect(dp.u, dp_in)
    annotation (Line(points={{-12,80},{-120,80}}, color={0,0,127}));
  connect(TW_in, TW.u)
    annotation (Line(points={{-120,40},{-12,40}},   color={0,0,127}));
  connect(reaPPum.u, PPum_in)
    annotation (Line(points={{-12,0},{-120,0}},   color={0,0,127}));
    connect(reaPBoi.u,PBoi_in)
    annotation (Line(points={{-12,-40},{-120,-40}}, color={0,0,127}));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,120}}), graphics={Rectangle(
          extent={{-100,120},{102,-102}},
          lineColor={0,0,0},
          fillColor={255,170,170},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-32,24},{34,-16}},
          lineColor={0,0,0},
          textString="Read
Wat"),  Text(
          extent={{-158,128},{142,168}},
          textString="%name",
          textColor={0,0,255})}),Diagram(coordinateSystem(preserveAspectRatio=
            false, extent={{-100,-100},{100,120}})));
end ReadHotWater;