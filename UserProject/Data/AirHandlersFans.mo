within UserProject.Data;
record AirHandlersFans
  // Start attribute or default binding must be used for disabled parameters
  // (for example VAV_AHU[2].damOutMin.dp_nominal, but VAV_AHU[1].damOutMin.dp_nominal is enabled!)
  parameter Buildings.Templates.AirHandlersFans.Data.VAVMultiZone VAV_AHU[2](
  cfg={
    UserProject.AirHandlersFans.Configuration.VAV_AHU_Config1(),
    UserProject.AirHandlersFans.Configuration.VAV_AHU_Config2()},
  id={"VAV_AHU_1", "VAV_AHU_2"},
  damOut(dp_nominal={15, 15}),
  damOutMin(dp_nominal={15, 0}),
  damRel(dp_nominal={15, 15}),
  damRet(dp_nominal={15, 15}),
  mOutMin_flow_nominal={0.2, 0.2},
  fanSup(
    m_flow_nominal={1, 1},
    dp_nominal={500, 500}),
  fanRet(
    m_flow_nominal={1, 1},
    dp_nominal={200, 200}),
  coiHeaPre(
    cap_nominal={1e4, 1e4},
    dpAir_nominal={100, 100},
    dpWat_nominal={0.5e4, 0.5e4},
    dpValve_nominal={0.3e4, 0.3e4},
    mWat_flow_nominal={1e4/4186/10, 1e4/4186/10},
    TAirEnt_nominal={273.15, 273.15},
    TWatEnt_nominal={50 + 273.15, 50 + 273.15}),
  coiCoo(
    cap_nominal={1e4, 1e4},
    dpAir_nominal={100, 100},
    dpWat_nominal={3e4, 3e4},
    dpValve_nominal={2e4, 2e4},
    mWat_flow_nominal={1e4/4186/5, 1e4/4186/5},
    TAirEnt_nominal={30 + 273.15, 30 + 273.15},
    TWatEnt_nominal={7 + 273.15, 7 + 273.15},
    wAirEnt_nominal={0.012, 0.012}),
  ctl(
    VOutUnc_flow_nominal={0.4, 0.4},
    VOutTot_flow_nominal={0.5, 0.5},
    VOutAbsMin_flow_nominal={0.3, 0.3},
    VOutMin_flow_nominal={0.4, 0.4},
    dpDamOutMinAbs={10, 10},
    dpDamOutMin_nominal={15, 15},
    pAirSupSet_rel_max={500, 500},
    pAirRetSet_rel_min={10, 10},
    pAirRetSet_rel_max={40, 40},
    yFanSup_min={0.1, 0.1},
    yFanRel_min={0.1, 0.1},
    yFanRet_min={0.1, 0.1},
    dVFanRet_flow={0.1, 0.1},
    TAirSupSet_min={12 + 273.15, 12 + 273.15},
    TAirSupSet_max={18 + 273.15, 18 + 273.15},
    TOutRes_min={16 + 273.15, 16 + 273.15},
    TOutRes_max={21 + 273.15, 21 + 273.15}));
end AirHandlersFans;
