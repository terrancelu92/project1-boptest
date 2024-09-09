within MultizoneOfficeComplexAir.BaseClasses.LoadSide;
model LoadWrapper "Load calculation in EnergyPlus using Spawn"
  MultizoneOfficeComplexAir.BaseClasses.LoadSide.BaseClasses.WholeBuildingEnergyPlus
    whoBui annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Modelica.Blocks.Interfaces.RealInput T[15] "temperature vector"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput wetBul "wet bulb temperature"
    annotation (Placement(transformation(extent={{100,80},{120,100}}),
        iconTransformation(extent={{100,80},{120,100}})));
  Modelica.Blocks.Interfaces.RealOutput dryBul "dry bulb temperature"
    annotation (Placement(transformation(extent={{100,50},{120,70}}),
        iconTransformation(extent={{100,50},{120,70}})));
  Modelica.Blocks.Interfaces.RealOutput relHum "relative humidity"
    annotation (Placement(transformation(extent={{100,-60},{120,-40}}),
        iconTransformation(extent={{100,-60},{120,-40}})));
  Modelica.Blocks.Interfaces.RealOutput numOcc[15] "number of occupant"
    annotation (Placement(transformation(extent={{100,-10},{120,10}}),
        iconTransformation(extent={{100,10},{120,30}})));

  Modelica.Blocks.Interfaces.RealOutput loa[15] "total load"
    annotation (Placement(transformation(extent={{100,-30},{120,-10}}),
        iconTransformation(extent={{100,-30},{120,-10}})));
  Modelica.Blocks.Math.Add3 add[15](each k3=-1)
    annotation (Placement(transformation(extent={{60,-30},{80,-10}})));
  Modelica.Blocks.Interfaces.RealOutput occ "relative humidity" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,-84})));
  Buildings.Utilities.IO.SignalExchange.WeatherStation weaSta
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  inner Buildings.ThermalZones.EnergyPlus_9_6_0.Building building(
    idfName=Modelica.Utilities.Files.loadResource(
        "modelica://MultizoneOfficeComplexAir/Resources/idf/wholebuilding96_spawn.idf"),
    epwName=Modelica.Utilities.Files.loadResource(
        "modelica://MultizoneOfficeComplexAir/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.epw"),
    weaName=Modelica.Utilities.Files.loadResource(
        "modelica://MultizoneOfficeComplexAir/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"),
    computeWetBulbTemperature=true,
    usePrecompiledFMU=false) "Building model"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));

  Modelica.Icons.SignalBus weaBus
    annotation (Placement(transformation(extent={{-8,92},{8,108}}),
        iconTransformation(extent={{-8,92},{8,108}})));
equation
  connect(whoBui.Outdoor_Humidity, relHum) annotation (Line(points={{-38,0},{40,
          0},{40,-50},{110,-50}}, color={0,0,127}));
  connect(T[1], whoBui.Temp1_bot);
  connect(T[2], whoBui.Temp2_bot);
  connect(T[3], whoBui.Temp3_bot);
  connect(T[4], whoBui.Temp4_bot);
  connect(T[5], whoBui.Temp5_bot);
  connect(T[6], whoBui.Temp1);
  connect(T[7], whoBui.Temp2);
  connect(T[8], whoBui.Temp3) annotation (Line(points={{-120,-2.66454e-15},{-120,
          0},{-62,0}}, color={0,0,127}));
  connect(T[9], whoBui.Temp4);
  connect(T[10], whoBui.Temp5);
  connect(T[11], whoBui.Temp1_top);
  connect(T[12], whoBui.Temp2_top);
  connect(T[13], whoBui.Temp3_top);
  connect(T[14], whoBui.Temp4_top);
  connect(T[15], whoBui.Temp5_top);
  connect(numOcc[1], whoBui.Zone1_bot_People);
  connect(numOcc[2], whoBui.Zone2_bot_People);
  connect(numOcc[3], whoBui.Zone3_bot_People);
  connect(numOcc[4], whoBui.Zone4_bot_People);
  connect(numOcc[5], whoBui.Zone5_bot_People);
  connect(numOcc[6], whoBui.Zone1_People);
  connect(numOcc[7], whoBui.Zone2_People);
  connect(numOcc[8], whoBui.Zone3_People) annotation (Line(points={{110,-1.33227e-15},
          {90,-1.33227e-15},{90,0},{-38,0}}, color={0,0,127}));
  connect(numOcc[9], whoBui.Zone4_People);
  connect(numOcc[10], whoBui.Zone5_People);
  connect(numOcc[11], whoBui.Zone1_top_People);
  connect(numOcc[12], whoBui.Zone2_top_People);
  connect(numOcc[13], whoBui.Zone3_top_People);
  connect(numOcc[14], whoBui.Zone4_top_People);
  connect(numOcc[15], whoBui.Zone5_top_People);

  connect(add[1].u1, whoBui.Zone1_bot_Sensible_COOLING_LOAD) annotation (Line(
        points={{58,-12},{0,-12},{0,0},{-38,0}}, color={0,0,127}));
  connect(add[1].u2, whoBui.Zone1_bot_Latent_COOLING_LOAD) annotation (Line(
        points={{58,-20},{10,-20},{10,0},{-38,0}}, color={0,0,127}));
  connect(add[1].u3, whoBui.Zone1_bot_HEATING_LOAD) annotation (Line(points={{
          58,-28},{20,-28},{20,0},{-38,0}}, color={0,0,127}));
  connect(add[2].u1, whoBui.Zone2_bot_Sensible_COOLING_LOAD);
  connect(add[2].u2, whoBui.Zone2_bot_Latent_COOLING_LOAD);
  connect(add[2].u3, whoBui.Zone2_bot_HEATING_LOAD);
  connect(add[3].u1, whoBui.Zone3_bot_Sensible_COOLING_LOAD);
  connect(add[3].u2, whoBui.Zone3_bot_Latent_COOLING_LOAD);
  connect(add[3].u3, whoBui.Zone3_bot_HEATING_LOAD);
  connect(add[4].u1, whoBui.Zone4_bot_Sensible_COOLING_LOAD);
  connect(add[4].u2, whoBui.Zone4_bot_Latent_COOLING_LOAD);
  connect(add[4].u3, whoBui.Zone4_bot_HEATING_LOAD);
  connect(add[5].u1, whoBui.Zone5_bot_Sensible_COOLING_LOAD);
  connect(add[5].u2, whoBui.Zone5_bot_Latent_COOLING_LOAD);
  connect(add[5].u3, whoBui.Zone5_bot_HEATING_LOAD);

  connect(add[6].u1, whoBui.Zone1_Sensible_COOLING_LOAD);
  connect(add[6].u2, whoBui.Zone1_Latent_COOLING_LOAD);
  connect(add[6].u3, whoBui.Zone1_HEATING_LOAD);
  connect(add[7].u1, whoBui.Zone2_Sensible_COOLING_LOAD);
  connect(add[7].u2, whoBui.Zone2_Latent_COOLING_LOAD);
  connect(add[7].u3, whoBui.Zone2_HEATING_LOAD);
  connect(add[8].u1, whoBui.Zone3_Sensible_COOLING_LOAD);
  connect(add[8].u2, whoBui.Zone3_Latent_COOLING_LOAD);
  connect(add[8].u3, whoBui.Zone3_HEATING_LOAD);
  connect(add[9].u1, whoBui.Zone4_Sensible_COOLING_LOAD);
  connect(add[9].u2, whoBui.Zone4_Latent_COOLING_LOAD);
  connect(add[9].u3, whoBui.Zone4_HEATING_LOAD);
  connect(add[10].u1, whoBui.Zone5_Sensible_COOLING_LOAD);
  connect(add[10].u2, whoBui.Zone5_Latent_COOLING_LOAD);
  connect(add[10].u3, whoBui.Zone5_HEATING_LOAD);

  connect(add[11].u1, whoBui.Zone1_top_Sensible_COOLING_LOAD);
  connect(add[11].u2, whoBui.Zone1_top_Latent_COOLING_LOAD);
  connect(add[11].u3, whoBui.Zone1_top_HEATING_LOAD);
  connect(add[12].u1, whoBui.Zone2_top_Sensible_COOLING_LOAD);
  connect(add[12].u2, whoBui.Zone2_top_Latent_COOLING_LOAD);
  connect(add[12].u3, whoBui.Zone2_top_HEATING_LOAD);
  connect(add[13].u1, whoBui.Zone3_top_Sensible_COOLING_LOAD);
  connect(add[13].u2, whoBui.Zone3_top_Latent_COOLING_LOAD);
  connect(add[13].u3, whoBui.Zone3_top_HEATING_LOAD);
  connect(add[14].u1, whoBui.Zone4_top_Sensible_COOLING_LOAD);
  connect(add[14].u2, whoBui.Zone4_top_Latent_COOLING_LOAD);
  connect(add[14].u3, whoBui.Zone4_top_HEATING_LOAD);
  connect(add[15].u1, whoBui.Zone5_top_Sensible_COOLING_LOAD);
  connect(add[15].u2, whoBui.Zone5_top_Latent_COOLING_LOAD);
  connect(add[15].u3, whoBui.Zone5_top_HEATING_LOAD);

  connect(whoBui.Occ, occ) annotation (Line(points={{-38,0},{30,0},{30,-84},{
          110,-84}}, color={0,0,127}));
  connect(dryBul, whoBui.Outdoor_Temperature) annotation (Line(points={{110,60},
          {50,60},{50,0},{-38,0}}, color={0,0,127}));
  connect(wetBul, whoBui.Wetbulb) annotation (Line(points={{110,90},{-10,90},{-10,
          0},{-38,0}}, color={0,0,127}));
  connect(add.y,loa)  annotation (Line(
      points={{81,-20},{110,-20}},
      color={0,0,127}));
  connect(weaSta.weaBus, whoBui.weaBus) annotation (Line(
      points={{-39.9,49.9},{-50,49.9},{-50,10}},
      color={255,204,51},
      thickness=0.5));
  connect(building.weaBus, whoBui.weaBus) annotation (Line(
      points={{-60,50},{-50,50},{-50,10}},
      color={255,204,51},
      thickness=0.5));
  connect(whoBui.weaBus, weaBus) annotation (Line(
      points={{-50,10},{-50,100},{0,100}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
                                        Text(
        extent={{-154,166},{146,126}},
        textString="%name",
        textColor={0,0,255}),
        Bitmap(extent={{-94,-86},{94,82}}, fileName="modelica://MultizoneOfficeComplexAir/Resources/figure/spawn_icon.png")}),
        Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>This is an EnergyPlus (V9.6) wrapper model that calculates the building&rsquo;s thermal loads with the boundary conditions. The inputs are the zone air temperatures from Modelica that is responsible for the airflow calculation (e.g., building infiltration) and HVAC system and controls.</p>
<p>See the model <a href=\"modelica://MultizoneOfficeComplexAir.BaseClasses.LoadSide.BaseClasses.WholeBuildingEnergyPlus\">MultizoneOfficeComplexAir.BaseClasses.LoadSide.BaseClasses.WholeBuildingEnergyPlus</a> for the EnergyPlus model.</p>
</html>", revisions="<html>
<ul>
<li>August 8, 2024, by Guowen Li, Xing Lu, Yan Chen: </li>
<p>Added weather bus.</p>
<li>August 17, 2023, by Xing Lu, Sen Huang, Lingzhe Wang, Yan Chen: </li>
<p>First implementation.</p>
</ul>
</html>"));
end LoadWrapper;
