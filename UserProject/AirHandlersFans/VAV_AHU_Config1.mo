within UserProject.AirHandlersFans;
model VAV_AHU_Config1
  extends Buildings.Templates.AirHandlersFans.VAVMultiZone(
    secOutRel(redeclare replaceable
      Buildings.Templates.AirHandlersFans.Components.OutdoorSection.DedicatedDampersAirflow
      secOut
      "Separate dampers for ventilation and economizer, with airflow measurement station",
      redeclare
      Buildings.Templates.AirHandlersFans.Components.ReliefReturnSection.ReturnFan
      secRel "Return fan with modulating relief damper"));
end VAV_AHU_Config1;
