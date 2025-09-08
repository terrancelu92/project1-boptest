within IDEAS.Utilities.IO.SignalExchange.SignalTypes;
type SignalsForActuatorTravel = enumeration(
    None
      "Not used for control actuators",
    Damper
      "Damper",
    Valve
      "Valve",
    Fan
      "Fan",
    Pump
      "Pump",
    HVACEquipment
      "HVAC Equipment",
    Others
      "Others")
  "Signals used for the calculation of key performance indexes"
  annotation (Documentation(info="<html>
<p>This enumeration defines the signal types that are used by BOPTEST to compute the control actuator travel. </p>
</html>", revisions="<html>
</html>"));
