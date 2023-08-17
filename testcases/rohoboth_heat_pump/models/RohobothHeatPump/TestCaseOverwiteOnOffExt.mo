within RohobothHeatPump;
model TestCaseOverwiteOnOffExt
  extends RohobothHeatPump.TestCaseOverwriteOnOff(oveHeaCoi(activate(y=true),
        uExt(y=heaPumOnOff.y[1])), oveFan(activate(y=true), uExt(y=heaPumOnOff.y[
            1])))
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
  Modelica.Blocks.Sources.CombiTimeTable heaPumOnOff(table=[0.0,1; 3600*8,1;
        3600*8,0; 3600*16,0; 3600*16,1; 3600*24,1])
    annotation (Placement(transformation(extent={{-60,-120},{-40,-100}})));
end TestCaseOverwiteOnOffExt;
