within UserProject.Data;
record ZoneEquipment
  parameter Buildings.Templates.ZoneEquipment.Data.VAVBox VAV_REH[10](
    cfg=fill(UserProject.ZoneEquipment.Configuration.VAV_Config1(), 10),
    id={"VAV_REH_1_1", "VAV_REH_1_2", "VAV_REH_1_3", "VAV_REH_1_4", "VAV_REH_1_5", "VAV_REH_1_6", "VAV_REH_1_7", "VAV_REH_2_1", "VAV_REH_2_3", "VAV_REH_2_3"},
    id_souAir={"VAV_AHU_1", "VAV_AHU_1", "VAV_AHU_1", "VAV_AHU_1", "VAV_AHU_1", "VAV_AHU_1", "VAV_AHU_1", "VAV_AHU_2", "VAV_AHU_2", "VAV_AHU_2"},
    damVAV(dp_nominal={50, 50, 50, 50, 50, 50, 50, 50, 50, 50}),
    coiHea(
      cap_nominal={1e3, 1e3, 1e3, 1e3, 1e3, 1e3, 1e3, 1e3, 1e3, 1e3},
      dpAir_nominal={70, 70, 70, 70, 70, 70, 70, 70, 70, 70},
      dpWat_nominal={0.1e4, 0.1e4, 0.1e4, 0.1e4, 0.1e4, 0.1e4, 0.1e4, 0.1e4, 0.1e4, 0.1e4},
      dpValve_nominal={0.05e4, 0.05e4, 0.05e4, 0.05e4, 0.05e4, 0.05e4, 0.05e4, 0.05e4, 0.05e4, 0.05e4},
      mWat_flow_nominal={1e3/4186/10, 1e3/4186/10, 1e3/4186/10, 1e3/4186/10, 1e3/4186/10, 1e3/4186/10, 1e3/4186/10, 1e3/4186/10, 1e3/4186/10, 1e3/4186/10},
      TAirEnt_nominal={285.15, 285.15, 285.15, 285.15, 285.15, 285.15, 285.15, 285.15, 285.15, 285.15},
      TWatEnt_nominal={323.15, 323.15, 323.15, 323.15, 323.15, 323.15, 323.15, 323.15, 323.15, 323.15}),
    ctl(
      VAirCooSet_flow_max={0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1},
      VAirHeaSet_flow_max={0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03, 0.03},
      VOutMinOcc_flow={2.5e-3, 2.5e-3, 2.5e-3, 2.5e-3, 2.5e-3, 2.5e-3, 2.5e-3, 2.5e-3, 2.5e-3, 2.5e-3},
      VOutMinAre_flow={3e-3, 3e-3, 3e-3, 3e-3, 3e-3, 3e-3, 3e-3, 3e-3, 3e-3, 3e-3},
      VOutOcc_flow={2.5e-3, 2.5e-3, 2.5e-3, 2.5e-3, 2.5e-3, 2.5e-3, 2.5e-3, 2.5e-3, 2.5e-3, 2.5e-3},
      VOutAre_flow={3e-3, 3e-3, 3e-3, 3e-3, 3e-3, 3e-3, 3e-3, 3e-3, 3e-3, 3e-3},
      VAirSet_flow_min={0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01}));
end ZoneEquipment;
