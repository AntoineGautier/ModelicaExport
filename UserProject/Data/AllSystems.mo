within UserProject.Data;
class AllSystems
  extends Buildings.Templates.Data.AllSystems(
    sysUni=Buildings.Templates.Types.Units.SI,
    stdEne=Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1,
    stdVen=Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1,
    ashCliZon=Buildings.Controls.OBC.ASHRAE.G36.Types.ASHRAEClimateZone.Zone_1A);
  extends UserProject.Data.AirHandlersFans;
  extends UserProject.Data.ZoneEquipment;
end AllSystems;
