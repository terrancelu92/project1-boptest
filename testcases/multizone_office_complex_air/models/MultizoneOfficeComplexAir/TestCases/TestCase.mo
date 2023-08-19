within MultizoneOfficeComplexAir.TestCases;
model TestCase
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
      __Dymola_Algorithm="Cvode"));
end TestCase;
