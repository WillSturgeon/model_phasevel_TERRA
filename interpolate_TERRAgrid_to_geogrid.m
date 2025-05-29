% Clear previous data and figures
close all; clear all; clc;

%list of TERRA models (.nc) format, which are currently stored on the external hard-drive called 'Monika'.
models = [
"/compressible_400/compressible_400----conv",
"/incompresssible_400/incompressible_400----conv",
"/CMB2600/CMB2600----conv",
"/CMB2600_scale/CMB2600_scale----conv",
"/CMB2800/CMB2800----conv",
"/CMB2800_scale/CMB2800_scale----conv",
"/CMB3000/CMB3000----conv",
"/CMB3000_scale/CMB3000_scale----conv",
"/CMB3200/CMB3200----conv",
"/CMB3200_scale/CMB3200_scale----conv",
"/CMB3400/CMB3400----conv",
"/CMB3400_scale/CMB3400_scale----conv",
"/106_scale/106_scale----conv",
"/107_scale/107_scale----conv",
"/108_scale/108_scale----conv",
"/thermal/thermal----conv",
"/primordial_6/primordial_6--crust--conv",
"/primordial_6/primordial_6--fsp--conv",
"/primordial_6/primordial_6--ceb--conv",
"/primordial_8/primordial_8--crust--conv",
"/primordial_8/primordial_8--fsp--conv",
"/primordial_8/primordial_8--ceb--conv",
"/thermal2/thermal2----conv",
"/CMB3600M/CMB3600M----conv",
"/CMB3800M/CMB3800M----conv",
"/CMB4000M/CMB4000M----conv",
"/primordial_5/primordial_5--crust--conv",
"/primordial_5/primordial_5--fsp--conv",
"/primordial_5/primordial_5--ceb--conv",
"/PR_6/PR_6--crust--conv",
"/PR_6/PR_6--fsp--conv",
"/PR_6/PR_6--ceb--conv",
"/PR_8/PR_8--crust--conv",
"/PR_8/PR_8--fsp--conv",
"/PR_8/PR_8--ceb--conv",
"/BB055/BB055-crust--conv",
"/BB055/BB055--fsp--conv",
"/BB055/BB055--ceb--conv",
"/BB066/BB066--crust--conv",
"/BB066/BB066--fsp--conv",
"/BB066/BB066--ceb--conv",
"/BB088/BB088--crust--conv",
"/BB088/BB088--fsp--conv",
"/BB088/BB088--ceb--conv",
"/primordial_3/primordial_3--crust--conv",
"/primordial_3/primordial_3--fsp--conv",
"/primordial_3/primordial_3--ceb--conv",
"/primordial_4/primordial_4--crust--conv",
"/primordial_4/primordial_4--fsp--conv",
"/primordial_4/primordial_4--ceb--conv",
"/PR_3/PR_3--crust--conv",
"/PR_3/PR_3--fsp--conv",
"/PR_3/PR_3--ceb--conv",
"/PR_4/PR_4--crust--conv",
"/PR_4/PR_4--fsp--conv",
"/PR_4/PR_4--ceb--conv",
"/PR_5/PR_5--crust--conv",
"/PR_5/PR_5--fsp--conv",
"/PR_5/PR_5--ceb--conv",
"/icond005/icond005----conv",
"/icond009/icond009----conv",
"/tempVisc/tempVisc----conv",
"/tempViscComp/tempViscComp----conv",
"/BB000/BB000----conv",
"/BB022/BB022----conv",
"/BB044/BB044----conv",
"/visc2/visc2----conv",
"/visc3/visc3----conv",
"/visc4/visc4----conv",
"/visc5/visc5----conv",
"/visc6/visc6----conv",
"/visc7/visc7----conv",
"/visc4_incomp/visc4_incomp----conv",
"/visc5_incomp/visc5_incomp----conv",
"/visc6_incomp/visc6_incomp----conv",
"/visc7_incomp/visc7_incomp----conv",
"/BB033/BB033----conv",
"/PR_4_150/PR_4_150--crust--conv",
"/PR_4_150/PR_4_150--fsp--conv",
"/PR_4_150/PR_4_150--ceb--conv",
"/PR_5_150/PR_5_150--crust--conv",
"/PR_5_150/PR_5_150--fsp--conv",
"/PR_5_150/PR_5_150--ceb--conv",
"/PR_6_150/PR_6_150--crust--conv",
"/PR_6_150/PR_6_150--fsp--conv",
"/PR_6_150/PR_6_150--ceb--conv",
"/BB066_tvisc/BB066_tvisc----conv",
"/CMB2600_2/CMB2600_2----conv",
"/CMB2600_2_tvisc/CMB2600_2_tvisc----conv",
"/CMB2600_2_prim/CMB2600_2_prim--crust--conv",
"/CMB2600_2_prim/CMB2600_2_prim--fsp--conv",
"/CMB2600_2_prim/CMB2600_2_prim--ceb--conv",
"/CMB2600_2_prim_tvisc/CMB2600_2_prim_tvisc--crust--conv",
"/CMB2600_2_prim_tvisc/CMB2600_2_prim_tvisc--fsp--conv",
"/CMB2600_2_prim_tvisc/CMB2600_2_prim_tvisc--ceb--conv",
"/CMB2800_2/CMB2800_2----conv",
"/CMB2800_2_tvisc/CMB2800_2_tvisc----conv",
"/CMB2800_2_prim/CMB2800_2_prim--crust--conv",
"/CMB2800_2_prim/CMB2800_2_prim--fsp--conv",
"/CMB2800_2_prim/CMB2800_2_prim--ceb--conv",
"/CMB2800_2_prim_tvisc/CMB2800_2_prim_tvisc--crust--conv",
"/CMB2800_2_prim_tvisc/CMB2800_2_prim_tvisc--fsp--conv",
"/CMB2800_2_prim_tvisc/CMB2800_2_prim_tvisc--ceb--conv",
"/CMB3000_2/CMB3000_2----conv",
"/CMB3000_2_tvisc/CMB3000_2_tvisc----conv",
"/CMB3000_2_prim/CMB3000_2_prim--crust--conv",
"/CMB3000_2_prim/CMB3000_2_prim--fsp--conv",
"/CMB3000_2_prim/CMB3000_2_prim--ceb--conv",
"/CMB3000_2_prim_tvisc/CMB3000_2_prim_tvisc--crust--conv",
"/CMB3000_2_prim_tvisc/CMB3000_2_prim_tvisc--fsp--conv",
"/CMB3000_2_prim_tvisc/CMB3000_2_prim_tvisc--ceb--conv",
"/CC_highT/CC_highT----conv",
"/CC_highT_prim/CC_highT_prim--crust--conv",
"/CC_highT_prim/CC_highT_prim--fsp--conv",
"/CC_highT_prim/CC_highT_prim--ceb--conv",
"/CC/CC----conv",
"/CC_prim/CC_prim--crust--conv",
"/CC_prim/CC_prim--fsp--conv",
"/CC_prim/CC_prim--ceb--conv",
"/CC_lowT/CC_lowT----conv",
"/CC_lowT_prim/CC_lowT_prim--crust--conv",
"/CC_lowT_prim/CC_lowT_prim--fsp--conv",
"/CC_lowT_prim/CC_lowT_prim--ceb--conv",
"/muller_3000/muller_3000----conv",
"/muller_3000_prim/muller_3000_prim--crust--conv",
"/muller_3000_prim/muller_3000_prim--fsp--conv",
"/muller_3000_prim/muller_3000_prim--ceb--conv",
"/muller_2600/muller_2600----conv",
"/muller_2600_prim/muller_2600_prim--crust--conv",
"/muller_2600_prim/muller_2600_prim--fsp--conv",
"/muller_2600_prim/muller_2600_prim--ceb--conv",
"/muller_2800/muller_2800----conv",
"/muller_2800_prim/muller_2800_prim--crust--conv",
"/muller_2800_prim/muller_2800_prim--fsp--conv",
"/muller_2800_prim/muller_2800_prim--ceb--conv",
"/m_visc1/m_visc1----conv",
"/m_visc2/m_visc2----conv",
"/m_visc3/m_visc3----conv",
"/m_visc4/m_visc4----conv",
"/m_bb_000/m_bb_000----conv",
"/m_bb_022/m_bb_022----conv",
"/m_bb_044/m_bb_044----conv",
"/m_bb_066/m_bb_066----conv",
"/m_bb_088/m_bb_088----conv",
"/m_visc1_tvisc/m_visc1_tvisc----conv",
"/m_visc2_tvisc/m_visc2_tvisc----conv",
"/m_visc3_tvisc/m_visc3_tvisc----conv",
"/m_visc4_tvisc/m_visc4_tvisc----conv",
"/m_bb_000_tvisc/m_bb_000_tvisc----conv",
"/m_bb_022_tvisc/m_bb_022_tvisc----conv",
"/m_bb_044_tvisc/m_bb_044_tvisc----conv",
"/m_bb_066_tvisc/m_bb_066_tvisc----conv",
"/m_bb_088_tvisc/m_bb_088_tvisc----conv",
"/m_bb_022_tvisc1/m_bb_022_tvisc1----conv",
"/m_bb_044_tvisc1/m_bb_044_tvisc1----conv",
"/m_bb_066_tvisc1/m_bb_066_tvisc1----conv",
"/m_bb_022_tvisc1_prim/m_bb_022_tvisc1_prim--crust--conv",
"/m_bb_022_tvisc1_prim/m_bb_022_tvisc1_prim--fsp--conv",
"/m_bb_022_tvisc1_prim/m_bb_022_tvisc1_prim--ceb--conv",
"/m_bb_044_tvisc1_prim/m_bb_044_tvisc1_prim--crust--conv",
"/m_bb_044_tvisc1_prim/m_bb_044_tvisc1_prim--fsp--conv",
"/m_bb_044_tvisc1_prim/m_bb_044_tvisc1_prim--ceb--conv",
"/m_bb_066_tvisc1_prim/m_bb_066_tvisc1_prim--crust--conv",
"/m_bb_066_tvisc1_prim/m_bb_066_tvisc1_prim--fsp--conv",
"/m_bb_066_tvisc1_prim/m_bb_066_tvisc1_prim--ceb--conv",
"/m_precond_100/m_precond_100----conv",
"/m_precond_50/m_precond_50----conv",
"/m_thermal_het/m_thermal_het----conv",
"/m_thermal_hom/m_thermal_hom----conv",
"/m_precond_100_rr/m_precond_100_rr----conv",
"/m_jump_20/m_jump_20----conv",
"/m_jump_10/m_jump_10----conv",
"/m_viscav_2/m_viscav_2----conv",
"/m_viscav_10/m_viscav_10----conv",
"/m_bb_066_tvisc1_comp/m_bb_066_tvisc1_comp----conv",
"/m_bb_066_tvisc1_prim_comp/m_bb_066_tvisc1_prim_comp--crust--conv",
"/m_bb_066_tvisc1_prim_comp/m_bb_066_tvisc1_prim_comp--fsp--conv",
"/m_bb_066_tvisc1_prim_comp/m_bb_066_tvisc1_prim_comp--ceb--conv",
"/m_bb_066_tvisc1_comp38/m_bb_066_tvisc1_comp38----conv",
"/m_bb_066_tvisc1_prim_comp38/m_bb_066_tvisc1_prim_comp38--crust--conv",
"/m_bb_066_tvisc1_prim_comp38/m_bb_066_tvisc1_prim_comp38--fsp--conv",
"/m_bb_066_tvisc1_prim_comp38/m_bb_066_tvisc1_prim_comp38--ceb--conv",
"/mcmb_2600_u/mcmb_2600_u----conv",
"/mcmb_2600_prim_u/mcmb_2600_prim_u--crust--conv",
"/mcmb_2600_prim_u/mcmb_2600_prim_u--fsp--conv",
"/mcmb_2600_prim_u/mcmb_2600_prim_u--ceb--conv",
"/mcmb_2800_u/mcmb_2800_u----conv",
"/mcmb_2800_prim_u/mcmb_2800_prim_u--crust--conv",
"/mcmb_2800_prim_u/mcmb_2800_prim_u--fsp--conv",
"/mcmb_2800_prim_u/mcmb_2800_prim_u--ceb--conv",
"/mcmb_3000_u/mcmb_3000_u----conv",
"/mcmb_3000_prim_u/mcmb_3000_prim_u--crust--conv",
"/mcmb_3000_prim_u/mcmb_3000_prim_u--fsp--conv",
"/mcmb_3000_prim_u/mcmb_3000_prim_u--ceb--conv",
"/mcmbc_3600_u/mcmbc_3600_u----conv",
"/mcmbc_3600_prim_u/mcmbc_3600_prim_u--crust--conv",
"/mcmbc_3600_prim_u/mcmbc_3600_prim_u--fsp--conv",
"/mcmbc_3600_prim_u/mcmbc_3600_prim_u--ceb--conv",
"/mcmbc_3800_u/mcmbc_3800_u----conv",
"/mcmbc_3800_prim_u/mcmbc_3800_prim_u--crust--conv",
"/mcmbc_3800_prim_u/mcmbc_3800_prim_u--fsp--conv",
"/mcmbc_3800_prim_u/mcmbc_3800_prim_u--ceb--conv",
"/mcmbc_4000_u/mcmbc_4000_u----conv",
"/mcmbc_4000_prim_u/mcmbc_4000_prim_u--crust--conv",
"/mcmbc_4000_prim_u/mcmbc_4000_prim_u--fsp--conv",
"/mcmbc_4000_prim_u/mcmbc_4000_prim_u--ceb--conv",
"/m_022_tv1_u/m_022_tv1_u----conv",
"/m_022_tv1_prim_u/m_022_tv1_prim_u--crust--conv",
"/m_022_tv1_prim_u/m_022_tv1_prim_u--fsp--conv",
"/m_022_tv1_prim_u/m_022_tv1_prim_u--ceb--conv",
"/m_044_tv1_u/m_044_tv1_u----conv",
"/m_044_tv1_prim_u/m_044_tv1_prim_u--crust--conv",
"/m_044_tv1_prim_u/m_044_tv1_prim_u--fsp--conv",
"/m_044_tv1_prim_u/m_044_tv1_prim_u--ceb--conv",
"/m_066_tv1_u/m_066_tv1_u----conv",
"/m_066_tv1_prim_u/m_066_tv1_prim_u--crust--conv",
"/m_066_tv1_prim_u/m_066_tv1_prim_u--fsp--conv",
"/m_066_tv1_prim_u/m_066_tv1_prim_u--ceb--conv",
"/m_cc_022_u/m_cc_022_u----conv",
"/m_cc_022_u_prim/m_cc_022_u_prim--crust--conv",
"/m_cc_022_u_prim/m_cc_022_u_prim--fsp--conv",
"/m_cc_022_u_prim/m_cc_022_u_prim--ceb--conv",
"/m_cc_044_u/m_cc_044_u----conv",
"/m_cc_044_u_prim/m_cc_044_u_prim--crust--conv",
"/m_cc_044_u_prim/m_cc_044_u_prim--fsp--conv",
"/m_cc_044_u_prim/m_cc_044_u_prim--ceb--conv",
"/m_cc_066_u/m_cc_066_u----conv",
"/m_cc_066_u_prim/m_cc_066_u_prim--crust--conv",
"/m_cc_066_u_prim/m_cc_066_u_prim--fsp--conv",
"/m_cc_066_u_prim/m_cc_066_u_prim--ceb--conv",
"/256_044_cc/256_044_cc----conv",
"/256_044_4000_1/256_044_4000_1----conv",
"/256_044_3800_lith_scl/256_044_3800_lith_scl----conv",
"/256_044_3800_lith_scl_1/256_044_3800_lith_scl_1----conv",
"/m_lhz/m_lhz----conv",
"/m_bas/m_bas----conv",
"/u_recy0/u_recy0----conv",
"/u_recy1/u_recy1----conv",
"/u_recy2/u_recy2----conv",
"/u_recy3/u_recy3----conv",
"/u_recy4/u_recy4----conv",
"/u_recy5/u_recy5----conv",
"/m_ave_c1/m_ave_c1----conv",
"/m_ave_c2/m_ave_c2----conv",
"/v1/v1----conv",
"/v2/v2----conv",
"/v3/v3----conv",
"/v4/v4----conv",
"/v6/v6----conv",
"/v7/v7----conv",
"/v8/v8----conv",
"/v9/v9----conv",
"/v10/v10----conv",
"/m3400_at/m3400_at----conv",
"/m3400_at_prim/m3400_at_prim--crust--conv",
"/m3400_at_prim/m3400_at_prim--fsp--conv",
"/m3400_at_prim/m3400_at_prim--ceb--conv",
"/m3600_at/m3600_at----conv",
"/m3600_at_prim/m3600_at_prim--crust--conv",
"/m3600_at_prim/m3600_at_prim--fsp--conv",
"/m3600_at_prim/m3600_at_prim--ceb--conv",
"/m3800_at/m3800_at----conv",
"/m3800_at_prim/m3800_at_prim--crust--conv",
"/m3800_at_prim/m3800_at_prim--fsp--conv",
"/m3800_at_prim/m3800_at_prim--ceb--conv",
"/m4000_at/m4000_at----conv",
"/m4000_at_prim/m4000_at_prim--crust--conv",
"/m4000_at_prim/m4000_at_prim--fsp--conv",
"/m4000_at_prim/m4000_at_prim--ceb--conv",
"/m4200_at/m4200_at----conv",
"/m4200_at_prim/m4200_at_prim--crust--conv",
"/m4200_at_prim/m4200_at_prim--fsp--conv",
"/m4200_at_prim/m4200_at_prim--ceb--conv",
"/m3400_sc/m3400_sc----conv",
"/m3400_sc_prim/m3400_sc_prim--crust--conv",
"/m3400_sc_prim/m3400_sc_prim--fsp--conv",
"/m3400_sc_prim/m3400_sc_prim--ceb--conv",
"/m4200_sc/m4200_sc----conv",
"/m4200_sc_prim/m4200_sc_prim--crust--conv",
"/m4200_sc_prim/m4200_sc_prim--fsp--conv",
"/m4200_sc_prim/m4200_sc_prim--ceb--conv",
"/m3400_rh/m3400_rh----conv",
"/m3400_rh_prim/m3400_rh_prim--crust--conv",
"/m3400_rh_prim/m3400_rh_prim--fsp--conv",
"/m3400_rh_prim/m3400_rh_prim--ceb--conv",
"/m4200_rh/m4200_rh----conv",
"/m4200_rh_prim/m4200_rh_prim--crust--conv",
"/m4200_rh_prim/m4200_rh_prim--fsp-conv",
"/m4200_rh_prim/m4200_rh_prim--ceb--conv",
"/m3400_rh_at/m3400_rh_at----conv",
"/m3400_rh_at_prim/m3400_rh_at_prim--crust--conv",
"/m3400_rh_at_prim/m3400_rh_at_prim--fsp--conv",
"/m3400_rh_at_prim/m3400_rh_at_prim--ceb--conv",
"/m4200_rh_at/m4200_rh_at----conv",
"/m4200_rh_at_prim/m4200_rh_at_prim--crust--conv",
"/m4200_rh_at_prim/m4200_rh_at_prim--fsp--conv",
"/m4200_rh_at_prim/m4200_rh_at_prim--ceb--conv",
"/m3400_sc_2/m3400_sc_2----conv",
"/m3400_sc_prim_2/m3400_sc_prim_2--crust--conv",
"/m3400_sc_prim_2/m3400_sc_prim_2--fsp--conv",
"/m3400_sc_prim_2/m3400_sc_prim_2--ceb--conv",
"/m4200_sc_2/m4200_sc_2----conv",
"/m4200_sc_prim_2/m4200_sc_prim_2--crust--conv",
"/m4200_sc_prim_2/m4200_sc_prim_2--fsp--conv",
"/m4200_sc_prim_2/m4200_sc_prim_2--ceb--conv",
"/m3400_at_044/m3400_at_044----conv",
"/m3400_at_prim_044/m3400_at_prim_044--crust--conv",
"/m3400_at_prim_044/m3400_at_prim_044--fsp--conv",
"/m3400_at_prim_044/m3400_at_prim_044--ceb--conv",
"/m3600_at_044/m3600_at_044----conv",
"/m3600_at_prim_044/m3600_at_prim_044--crust--conv",
"/m3600_at_prim_044/m3600_at_prim_044--fsp--conv",
"/m3600_at_prim_044/m3600_at_prim_044--ceb--conv",
"/m3800_at_044/m3800_at_044----conv",
"/m3800_at_prim_044/m3800_at_prim_044--crust--conv",
"/m3800_at_prim_044/m3800_at_prim_044--fsp--conv",
"/m3800_at_prim_044/m3800_at_prim_044--ceb--conv",
"/m4000_at_044/m4000_at_044----conv",
"/m4000_at_prim_044/m4000_at_prim_044--crust--conv",
"/m4000_at_prim_044/m4000_at_prim_044--fsp--conv",
"/m4000_at_prim_044/m4000_at_prim_044--ceb--conv",
"/m4200_at_044/m4200_at_044----conv",
"/m4200_at_prim_044/m4200_at_prim_044--crust--conv",
"/m4200_at_prim_044/m4200_at_prim_044--fsp--conv",
"/m4200_at_prim_044/m4200_at_prim_044--ceb--conv",
"/m3400_sc_044/m3400_sc_044----conv",
"/m3400_sc_prim_044/m3400_sc_prim--crust--conv",
"/m3400_sc_prim_044/m3400_sc_prim--fsp--conv",
"/m3400_sc_prim_044/m3400_sc_prim--ceb--conv",
"/m4200_sc_044/m4200_sc_044----conv",
"/m4200_sc_prim_044/m4200_sc_prim_044--crust--conv",
"/m4200_sc_prim_044/m4200_sc_prim_044--fsp--conv",
"/m4200_sc_prim_044/m4200_sc_prim_044--ceb--conv",
"/m3400_rh_044/m3400_rh_044----conv",
"/m3400_rh_prim_044/m3400_rh_prim_044--crust--conv",
"/m3400_rh_prim_044/m3400_rh_prim_044--fsp--conv",
"/m3400_rh_prim_044/m3400_rh_prim_044--ceb--conv",
"/m4200_rh_044/m4200_rh_044----conv",
"/m4200_rh_prim_044/m4200_rh_prim_044--crust--conv",
"/m4200_rh_prim_044/m4200_rh_prim_044--fsp--conv",
"/m4200_rh_prim_044/m4200_rh_prim_044--ceb--conv",
"/m3400_rh_at_044/m3400_rh_at_044----conv",
"/m3400_rh_at_prim_044/m3400_rh_at_prim_044--crust--conv",
"/m3400_rh_at_prim_044/m3400_rh_at_prim_044--fsp--conv",
"/m3400_rh_at_prim_044/m3400_rh_at_prim_044--ceb--conv",
"/m4200_rh_at_044/m4200_rh_at_044----conv",
"/m4200_rh_at_prim_044/m4200_rh_prim_044--crust--conv",
"/m4200_rh_at_prim_044/m4200_rh_prim_044--fsp--conv",
"/m4200_rh_at_prim_044/m4200_rh_prim_044--ceb--conv",
"/cl1/cl1----conv",
"/cl2/cl2----conv",
"/cl3/cl3----conv",
"/cl4/cl4----conv",
"/cl1_s/cl1_s----conv",
"/cl2_s/cl2_s----conv",
"/cl3_s/cl3_s----conv",
"/cl4_s/cl4_s----conv",
"/astheno1/astheno1----conv",
"/astheno2/astheno2----conv",
"/astheno1_prim/astheno1_prim--crust--conv",
"/astheno1_prim/astheno1_prim--fsp--conv",
"/astheno1_prim/astheno1_prim--ceb--conv",
"/astheno2_prim/astheno2_prim--crust--conv",
"/astheno2_prim/astheno2_prim--fsp--conv",
"/astheno2_prim/astheno2_prim--ceb--conv",
"/v3_prim/v3_prim--crust--conv",
"/v3_prim/v3_prim--fsp--conv",
"/v3_prim/v3_prim--ceb--conv",
"/v6_prim/v6_prim--crust--conv",
"/v6_prim/v6_prim--fsp--conv",
"/v6_prim/v6_prim--ceb--conv",
"/v9_prim/v9_prim--crust--conv",
"/v9_prim/v9_prim--fsp--conv",
"/v9_prim/v9_prim--ceb--conv"];

% Specify the path to the NetCDF file
for i=1:length(models)
model=models(i);model=string(model)
ncfile = strcat("/Volumes/Monika/convert",model);
ncfile=string(ncfile);
% Define parameters including 'depths'
parameters = {'vs', 'vp', 'density'};

% Define the new grid
new_longitude = -178:2:180;
new_latitude = -88:2:90;

% Read 'depths' from the NetCDF fileg
depths = ncread(ncfile, 'depths');
%%
% Iterate through all depth valuessi
for depth_index = 1:numel(depths)
    depth_value = depths(depth_index)
    %clear caxis_auto caxis 

    % Create a fullscreen figure with 5 rows and 2 columns for subplots
    %figure('Position', get(0, 'ScreenSize'));

    for param_index = 1:length(parameters)
        parameter_name = parameters{param_index};

        % Read data from the NetCDF file for the current parameter
        param = ncread(ncfile, parameter_name);
        latitude = ncread(ncfile, 'latitude');
        longitude = ncread(ncfile, 'longitude');

        if strcmp(parameter_name, 'depths')
            % Use the 'depths' vector
            param_values = depths;
        else
            % Extracting the first layer for the current parameter
            param_values = squeeze(param(:, depth_index, :));
        end

        % Convert latitude and longitude to 1D double arrays
        lat_flat = double(reshape(latitude, [], 1));
        lon_flat = double(reshape(longitude, [], 1));

        % Reshape the parameter data to a 1D double array
        param_flat = double(reshape(param_values, [], 1));

        % Verify if latitude -178 and -88 are missing or contain NaN values
     %   is_nan_lat_minus_178 = all(isnan(param_values(:, 1))); % Check for latitude -178
     %   is_nan_lat_minus_88 = all(isnan(param_values(:, 6))); % Check for latitude -88

        % Create scatteredInterpolant for interpolation for the current parameter
        F_param = scatteredInterpolant(lon_flat, lat_flat, param_flat, 'linear', 'none');

        % Interpolate data onto the new grid for the current parameter
        [new_lon_grid, new_lat_grid] = meshgrid(new_longitude, new_latitude);
        param_first_layer_new = F_param(new_lon_grid, new_lat_grid);

        % Flatten the new longitude and latitude grids for scatter plot
        new_lon_flat = new_lon_grid(:);
        new_lat_flat = new_lat_grid(:);
        param_first_layer_new_flat = param_first_layer_new(:);

        % Find NaN values in the interpolated data and remove them
        nan_indices = isnan(param_first_layer_new_flat);
        new_lon_flat = new_lon_flat(~nan_indices);
        new_lat_flat = new_lat_flat(~nan_indices);
        param_first_layer_new_flat = param_first_layer_new_flat(~nan_indices);

        % Save the output file for the current parameter with depth value in the name
        output_file = strcat("/Volumes/Monika/convert/",model,'_',parameter_name,'_depth_',num2str(depth_value),'km_2x2.xy');
        output_file=string(output_file);
        output_data = [new_lon_flat, new_lat_flat, param_first_layer_new_flat];
        dlmwrite(output_file, output_data, 'delimiter', ' ', 'precision', 9);

        % Create subplot for the current parameter
        %subplot(3, 2, param_index * 2 - 1);
        %scatter(lon_flat, lat_flat, 10, param_flat, 'o', 'filled');
        %colorbar;
        %xlabel('Longitude');
        %ylabel('Latitude');
        %title(['Original ' parameter_name]);

        % Save the output file original grid
        %output_file2 = strcat("/Volumes/MC2/TERRA_models_Franck/convert',model,'_',parameter_name,'_depth_',num2str(depth_value),'km_originalgrid.xy');
        %output_file2=string(output_file2);
        %output_data2 = [lon_flat, lat_flat, param_flat];
        %dlmwrite(output_file2, output_data2, 'delimiter', ' ', 'precision', 9);

        %subplot(3, 2, param_index * 2);
        %scatter(new_lon_flat, new_lat_flat, 10, param_first_layer_new_flat, 'o', 'filled');
        %colorbar;
        %xlabel('Longitude');
        %ylabel('Latitude');
        %title(['Interpolated ' parameter_name]);
        %sgtitle(strcat(string(depth_value),' km'));

        % Adjust the colorbar limits to be the same for each row
        %caxis_auto = caxis;
        %subplot(3, 2, param_index * 2 - 1);
        %caxis(caxis_auto);
        %subplot(3, 2, param_index * 2);
        %caxis(caxis_auto);
    end

    % Save the figure for the current depth value
    %saveas(gcf, strcat("/Volumes/MC2/TERRA_models_Franck/convert',model,'_grid_interp_depth_',num2str(depth_value),'km.png'));

    % Close the figure to free up memory
    %close(gcf);
end

end
