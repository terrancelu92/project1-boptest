model wrapped "Wrapped model"
	// Input overwrite
	Modelica.Blocks.Interfaces.RealInput oveCooCoi_u(unit="1", min=0.0, max=1.0) "Real signal to control the DX cooling coil on off signal (any value less than 0.1 - off, any value larger or equal than 0.1 - on";
	Modelica.Blocks.Interfaces.BooleanInput oveCooCoi_activate "Activation for Real signal to control the DX cooling coil on off signal (any value less than 0.1 - off, any value larger or equal than 0.1 - on";
	Modelica.Blocks.Interfaces.RealInput oveFan_u(unit="1", min=0.0, max=1.0) "Real signal to control the fan on off signal (any value less than 0.1 - off, any value larger or equal than 0.1 - on";
	Modelica.Blocks.Interfaces.BooleanInput oveFan_activate "Activation for Real signal to control the fan on off signal (any value less than 0.1 - off, any value larger or equal than 0.1 - on";
	Modelica.Blocks.Interfaces.RealInput oveHeaCoi_u(unit="1", min=0.0, max=1.0) "Real signal to control the DX heating coil on off signal (any value less than 0.1 - off, any value larger or equal than 0.1 - on";
	Modelica.Blocks.Interfaces.BooleanInput oveHeaCoi_activate "Activation for Real signal to control the DX heating coil on off signal (any value less than 0.1 - off, any value larger or equal than 0.1 - on";
	Modelica.Blocks.Interfaces.RealInput oveTZonCoo_u(unit="K", min=289.15, max=303.15) "Real signal to control the zone air cooling setpoint";
	Modelica.Blocks.Interfaces.BooleanInput oveTZonCoo_activate "Activation for Real signal to control the zone air cooling setpoint";
	Modelica.Blocks.Interfaces.RealInput oveTZonHea_u(unit="K", min=289.15, max=303.15) "Real signal to control the zone air heating setpoint";
	Modelica.Blocks.Interfaces.BooleanInput oveTZonHea_activate "Activation for Real signal to control the zone air heating setpoint";
	Modelica.Blocks.Interfaces.RealInput pthp_oveTOut_u(unit="K", min=243.15, max=343.15) "Real signal to reset the outdoor air drybulb temperature";
	Modelica.Blocks.Interfaces.BooleanInput pthp_oveTOut_activate "Activation for Real signal to reset the outdoor air drybulb temperature";
	// Out read
	Modelica.Blocks.Interfaces.RealOutput OccSchMea_y(unit="1") = mod.OccSchMea.y "Occupancy signal";
	Modelica.Blocks.Interfaces.RealOutput QLoaMea_y(unit="W") = mod.QLoaMea.y "Cooling or heating load measurement measurement";
	Modelica.Blocks.Interfaces.RealOutput TSupMea_y(unit="K") = mod.TSupMea.y "Supply air temperature measurement";
	Modelica.Blocks.Interfaces.RealOutput TZonMea_y(unit="K") = mod.TZonMea.y "Zone air temperature measurement";
	Modelica.Blocks.Interfaces.RealOutput pthp_PCooCoo_y(unit="W") = mod.pthp.PCooCoo.y "Electrical power measurement of cooling coil";
	Modelica.Blocks.Interfaces.RealOutput pthp_PFan_y(unit="W") = mod.pthp.PFan.y "Electrical power measurement of fan";
	Modelica.Blocks.Interfaces.RealOutput pthp_PHeaCoi_y(unit="W") = mod.pthp.PHeaCoi.y "Electrical power measurement of heating coil";
	Modelica.Blocks.Interfaces.RealOutput pthp_PHeaCoiSup_y(unit="W") = mod.pthp.PHeaCoiSup.y "Electrical power measurement of supplemental electric heating coil";
	Modelica.Blocks.Interfaces.RealOutput pthp_QCooCoi_y(unit="W") = mod.pthp.QCooCoi.y "Cooling rate measurement of cooling coil (negative value)";
	Modelica.Blocks.Interfaces.RealOutput pthp_QHeaCoi_y(unit="W") = mod.pthp.QHeaCoi.y "Heating rate measurement of heating coil";
	Modelica.Blocks.Interfaces.RealOutput yFanMea_y(unit="1") = mod.yFanMea.y "Indoor fan speed measurement";
	Modelica.Blocks.Interfaces.RealOutput oveCooCoi_y(unit="1") = mod.oveCooCoi.y "Real signal to control the DX cooling coil on off signal (any value less than 0.1 - off, any value larger or equal than 0.1 - on";
	Modelica.Blocks.Interfaces.RealOutput oveFan_y(unit="1") = mod.oveFan.y "Real signal to control the fan on off signal (any value less than 0.1 - off, any value larger or equal than 0.1 - on";
	Modelica.Blocks.Interfaces.RealOutput oveHeaCoi_y(unit="1") = mod.oveHeaCoi.y "Real signal to control the DX heating coil on off signal (any value less than 0.1 - off, any value larger or equal than 0.1 - on";
	Modelica.Blocks.Interfaces.RealOutput oveTZonCoo_y(unit="K") = mod.oveTZonCoo.y "Real signal to control the zone air cooling setpoint";
	Modelica.Blocks.Interfaces.RealOutput oveTZonHea_y(unit="K") = mod.oveTZonHea.y "Real signal to control the zone air heating setpoint";
	Modelica.Blocks.Interfaces.RealOutput pthp_oveTOut_y(unit="K") = mod.pthp.oveTOut.y "Real signal to reset the outdoor air drybulb temperature";
	// Original model
	RohobothHeatPump.TestCaseOverwriteOnOff mod(
		oveCooCoi(uExt(y=oveCooCoi_u),activate(y=oveCooCoi_activate)),
		oveFan(uExt(y=oveFan_u),activate(y=oveFan_activate)),
		oveHeaCoi(uExt(y=oveHeaCoi_u),activate(y=oveHeaCoi_activate)),
		oveTZonCoo(uExt(y=oveTZonCoo_u),activate(y=oveTZonCoo_activate)),
		oveTZonHea(uExt(y=oveTZonHea_u),activate(y=oveTZonHea_activate)),
		pthp.oveTOut(uExt(y=pthp_oveTOut_u),activate(y=pthp_oveTOut_activate))) "Original model with overwrites";
end wrapped;
