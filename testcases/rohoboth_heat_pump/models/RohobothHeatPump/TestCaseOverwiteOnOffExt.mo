within RohobothHeatPump;
model TestCaseOverwiteOnOffExt
  extends RohobothHeatPump.TestCaseOverwriteOnOff(
    oveHeaCoi(activate(y=true), uExt(y=pulse.y)),
    oveFan(activate(y=true), uExt(y=pulse.y)),
    pthp(TAirLvg(transferHeat=false), fan(addPowerToMedium=true))) annotation (
      Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
  Modelica.Blocks.Sources.CombiTimeTable heaPumOnOff1(table=[0.0,1; 3600*8,1; 3600
        *8,0; 3600*16,0; 3600*16,1; 3600*24,1])
    annotation (Placement(transformation(extent={{-58,-120},{-38,-100}})));
  Modelica.Blocks.Sources.Pulse pulse(period=1800)
    annotation (Placement(transformation(extent={{-28,-120},{-8,-100}})));
  annotation (experiment(
      StartTime=86400,
      StopTime=172800,
      Tolerance=1e-06,
      __Dymola_Algorithm="Dassl"));
end TestCaseOverwiteOnOffExt;
