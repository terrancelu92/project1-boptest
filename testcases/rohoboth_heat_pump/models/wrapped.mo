model wrapped "Wrapped model"
	// Input overwrite
	Modelica.Blocks.Interfaces.RealInput oveTZonCoo_u(unit="K", min=289.15, max=303.15) "Real signal to control the zone air cooling setpoint";
	Modelica.Blocks.Interfaces.BooleanInput oveTZonCoo_activate "Activation for Real signal to control the zone air cooling setpoint";
	Modelica.Blocks.Interfaces.RealInput oveTZonHea_u(unit="K", min=289.15, max=303.15) "Real signal to control the zone air heating setpoint";
	Modelica.Blocks.Interfaces.BooleanInput oveTZonHea_activate "Activation for Real signal to control the zone air heating setpoint";
	// Out read
	Modelica.Blocks.Interfaces.RealOutput OccSchMea_y(unit="1") = mod.OccSchMea.y "Occupancy signal";
	Modelica.Blocks.Interfaces.RealOutput TSupMea_y(unit="K") = mod.TSupMea.y "Supply air temperature measurement";
	Modelica.Blocks.Interfaces.RealOutput TZonMea_y(unit="K") = mod.TZonMea.y "Zone air temperature measurement";
	Modelica.Blocks.Interfaces.RealOutput pthp_PCooCoo_y(unit="W") = mod.pthp.PCooCoo.y "Electrical power measurement of cooling coil";
	Modelica.Blocks.Interfaces.RealOutput pthp_PFan_y(unit="W") = mod.pthp.PFan.y "Electrical power measurement of fan";
	Modelica.Blocks.Interfaces.RealOutput pthp_PHeaCoi_y(unit="W") = mod.pthp.PHeaCoi.y "Electrical power measurement of heating coil";
	Modelica.Blocks.Interfaces.RealOutput pthp_PHeaCoiSup_y(unit="W") = mod.pthp.PHeaCoiSup.y "Electrical power measurement of supplemental electric heating coil";
	Modelica.Blocks.Interfaces.RealOutput yFanMea_y(unit="1") = mod.yFanMea.y "Indoor fan speed measurement";
	Modelica.Blocks.Interfaces.RealOutput oveTZonCoo_y(unit="K") = mod.oveTZonCoo.y "Real signal to control the zone air cooling setpoint";
	Modelica.Blocks.Interfaces.RealOutput oveTZonHea_y(unit="K") = mod.oveTZonHea.y "Real signal to control the zone air heating setpoint";
	// Original model
	RohobothHeatPump.TestCase mod(
		oveTZonCoo(uExt(y=oveTZonCoo_u),activate(y=oveTZonCoo_activate)),
		oveTZonHea(uExt(y=oveTZonHea_u),activate(y=oveTZonHea_activate))) "Original model with overwrites";
end wrapped;
