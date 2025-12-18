within UserProject.AirHandlersFans.Configuration;
record VAV_AHU_Config1
  // This record is only a subset of all the parameters that define a system configuration
  // (i.e. the parameters exposed in ctrl-flow).
  // This subset is the one needed to enable/disable the control parameters
  // and equipment characteristics in UserProject.Data.
  extends Buildings.Templates.AirHandlersFans.Configuration.VAVMultiZone(
    final typ=Buildings.Templates.AirHandlersFans.Types.Configuration.SingleDuct,
    final typFanSup=Buildings.Templates.Components.Types.Fan.SingleVariable,
    final typFanRel=Buildings.Templates.Components.Types.Fan.None,
    final typFanRet=Buildings.Templates.Components.Types.Fan.SingleVariable,
    final have_souChiWat=true,
    final have_souHeaWat=true,
    final nFanSup=1,
    final nFanRet=1,
    final nFanRel=0,
    final typCoiHeaPre=Buildings.Templates.Components.Types.Coil.WaterBasedHeating,
    final typCoiCoo=Buildings.Templates.Components.Types.Coil.WaterBasedCooling,
    final typCoiHeaReh=Buildings.Templates.Components.Types.Coil.None,
    final typValCoiHeaPre=Buildings.Templates.Components.Types.Valve.TwoWayModulating,
    final typValCoiCoo=Buildings.Templates.Components.Types.Valve.TwoWayModulating,
    final typValCoiHeaReh=Buildings.Templates.Components.Types.Valve.None,
    final typDamOut=Buildings.Templates.Components.Types.Damper.Modulating,
    final typDamOutMin=Buildings.Templates.Components.Types.Damper.Modulating,
    final typDamRet=Buildings.Templates.Components.Types.Damper.Modulating,
    final typDamRel=Buildings.Templates.Components.Types.Damper.Modulating,
    final typSecOut=Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.DedicatedDampersAirflow,
    final typCtl=Buildings.Templates.AirHandlersFans.Types.Controller.G36VAVMultiZone,
    final buiPreCon=Buildings.Controls.OBC.ASHRAE.G36.Types.PressureControl.ReliefFan,
    final stdVen=Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1);
end VAV_AHU_Config1;
