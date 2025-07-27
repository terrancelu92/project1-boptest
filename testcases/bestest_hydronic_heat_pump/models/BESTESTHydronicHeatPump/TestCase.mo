within BESTESTHydronicHeatPump;
model TestCase "This model just extends the test case model from IDEAS library"
  extends IDEAS.Examples.IBPSA.SingleZoneResidentialHydronicHeatPump(
    reaPum(KPIs=IDEAS.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.ControlActuatorTravel,
        CAT=IDEAS.Utilities.IO.SignalExchange.SignalTypes.SignalsForActuatorTravel.Pump),

    reaFan(KPIs=IDEAS.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.ControlActuatorTravel,
        CAT=IDEAS.Utilities.IO.SignalExchange.SignalTypes.SignalsForActuatorTravel.Fan),

    reaHeaPumY(KPIs=IDEAS.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.ControlActuatorTravel,
        CAT=IDEAS.Utilities.IO.SignalExchange.SignalTypes.SignalsForActuatorTravel.HVACEquipment));

end TestCase;
