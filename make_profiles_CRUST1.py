import numpy as np
import os
import multiprocessing

def read_data(file_path, skiprows=0):
    """Read a text file using numpy genfromtxt."""
    return np.genfromtxt(file_path, skip_header=skiprows)

models = [
#"compressible_400/compressible_400----conv",
#"incompresssible_400/incompressible_400----conv",
"CMB2600/CMB2600----conv",
"CMB2600_scale/CMB2600_scale----conv",
"CMB2800/CMB2800----conv",
"CMB2800_scale/CMB2800_scale----conv",
"CMB3000/CMB3000----conv",
"CMB3000_scale/CMB3000_scale----conv",
"CMB3200/CMB3200----conv",
"CMB3200_scale/CMB3200_scale----conv",
"CMB3400/CMB3400----conv",
"CMB3400_scale/CMB3400_scale----conv",
"106_scale/106_scale----conv",
"107_scale/107_scale----conv",
"108_scale/108_scale----conv",
"thermal/thermal----conv",
"primordial_6/primordial_6--crust--conv",
"primordial_6/primordial_6--fsp--conv",
"primordial_6/primordial_6--ceb--conv",
"primordial_8/primordial_8--crust--conv",
"primordial_8/primordial_8--fsp--conv",
"primordial_8/primordial_8--ceb--conv",
"thermal2/thermal2----conv",
 "CMB3600M/CMB3600M----conv",
"CMB3800M/CMB3800M----conv",
"CMB4000M/CMB4000M----conv",
"primordial_5/primordial_5--crust--conv",
"primordial_5/primordial_5--fsp--conv",
"primordial_5/primordial_5--ceb--conv",
"PR_6/PR_6--crust--conv",
"PR_6/PR_6--fsp--conv",
"PR_6/PR_6--ceb--conv",
"PR_8/PR_8--crust--conv",
"PR_8/PR_8--fsp--conv",
"PR_8/PR_8--ceb--conv",
"BB055/BB055--crust--conv",
"BB055/BB055--fsp--conv",
"BB055/BB055--ceb--conv",
"BB066/BB066--crust--conv",
"BB066/BB066--fsp--conv",
"BB066/BB066--ceb--conv",
"BB088/BB088--crust--conv",
"BB088/BB088--fsp--conv",
"BB088/BB088--ceb--conv",
"primordial_3/primordial_3--crust--conv",
"primordial_3/primordial_3--fsp--conv",
"primordial_3/primordial_3--ceb--conv",
"primordial_4/primordial_4--crust--conv",
"primordial_4/primordial_4--fsp--conv",
"primordial_4/primordial_4--ceb--conv",
"PR_3/PR_3--crust--conv",
"PR_3/PR_3--fsp--conv",
"PR_3/PR_3--ceb--conv",
"PR_4/PR_4--crust--conv",
"PR_4/PR_4--fsp--conv",
"PR_4/PR_4--ceb--conv",
"PR_5/PR_5--crust--conv",
"PR_5/PR_5--fsp--conv",
"PR_5/PR_5--ceb--conv",
"icond005/icond005----conv",
"icond009/icond009----conv",
"tempVisc/tempVisc----conv",
"tempViscComp/tempViscComp----conv",
"BB000/BB000----conv",
"BB022/BB022----conv",
"BB044/BB044----conv",
"visc2/visc2----conv",
"visc3/visc3----conv",
"visc4/visc4----conv",
"visc5/visc5----conv",
"visc6/visc6----conv",
"visc7/visc7----conv",
"visc4_incomp/visc4_incomp----conv",
"visc5_incomp/visc5_incomp----conv",
"visc6_incomp/visc6_incomp----conv",
"visc7_incomp/visc7_incomp----conv",
"BB033/BB033----conv",
"PR_4_150/PR_4_150--crust--conv",
"PR_4_150/PR_4_150--fsp--conv",
"PR_4_150/PR_4_150--ceb--conv",
"PR_5_150/PR_5_150--crust--conv",
"PR_5_150/PR_5_150--fsp--conv",
"PR_5_150/PR_5_150--ceb--conv",
"PR_6_150/PR_6_150--crust--conv",
"PR_6_150/PR_6_150--fsp--conv",
"PR_6_150/PR_6_150--ceb--conv",
"BB066_tvisc/BB066_tvisc----conv",
"CMB2600_2/CMB2600_2----conv",
"CMB2600_2_tvisc/CMB2600_2_tvisc----conv",
"CMB2600_2_prim/CMB2600_2_prim--crust--conv",
"CMB2600_2_prim/CMB2600_2_prim--fsp--conv",
"CMB2600_2_prim/CMB2600_2_prim--ceb--conv",
"CMB2600_2_prim_tvisc/CMB2600_2_prim_tvisc--crust--conv",
"CMB2600_2_prim_tvisc/CMB2600_2_prim_tvisc--fsp--conv",
"CMB2600_2_prim_tvisc/CMB2600_2_prim_tvisc--ceb--conv",
"CMB2800_2/CMB2800_2----conv",
"CMB2800_2_tvisc/CMB2800_2_tvisc----conv",
"CMB2800_2_prim/CMB2800_2_prim--crust--conv",
"CMB2800_2_prim/CMB2800_2_prim--fsp--conv",
"CMB2800_2_prim/CMB2800_2_prim--ceb--conv",
"CMB2800_2_prim_tvisc/CMB2800_2_prim_tvisc--crust--conv",
"CMB2800_2_prim_tvisc/CMB2800_2_prim_tvisc--fsp--conv",
"CMB2800_2_prim_tvisc/CMB2800_2_prim_tvisc--ceb--conv",
"CMB3000_2/CMB3000_2----conv",
"CMB3000_2_tvisc/CMB3000_2_tvisc----conv",
"CMB3000_2_prim/CMB3000_2_prim--crust--conv",
"CMB3000_2_prim/CMB3000_2_prim--fsp--conv",
"CMB3000_2_prim/CMB3000_2_prim--ceb--conv",
"CMB3000_2_prim_tvisc/CMB3000_2_prim_tvisc--crust--conv",
"CMB3000_2_prim_tvisc/CMB3000_2_prim_tvisc--fsp--conv",
"CMB3000_2_prim_tvisc/CMB3000_2_prim_tvisc--ceb--conv",
"CC_highT/CC_highT----conv",
"CC_highT_prim/CC_highT_prim--crust--conv",
"CC_highT_prim/CC_highT_prim--fsp--conv",
"CC_highT_prim/CC_highT_prim--ceb--conv",
"CC/CC----conv",
"CC_prim/CC_prim--crust--conv",
"CC_prim/CC_prim--fsp--conv",
"CC_prim/CC_prim--ceb--conv",
"CC_lowT/CC_lowT----conv",
"CC_lowT_prim/CC_lowT_prim--crust--conv",
"CC_lowT_prim/CC_lowT_prim--fsp--conv",
"CC_lowT_prim/CC_lowT_prim--ceb--conv",
"muller_3000/muller_3000----conv",
"muller_3000_prim/muller_3000_prim--crust--conv",
"muller_3000_prim/muller_3000_prim--fsp--conv",
"muller_3000_prim/muller_3000_prim--ceb--conv",
"muller_2600/muller_2600----conv",
"muller_2600_prim/muller_2600_prim--crust--conv",
"muller_2600_prim/muller_2600_prim--fsp--conv",
"muller_2600_prim/muller_2600_prim--ceb--conv",
"muller_2800/muller_2800----conv",
"muller_2800_prim/muller_2800_prim--crust--conv",
"muller_2800_prim/muller_2800_prim--fsp--conv",
"muller_2800_prim/muller_2800_prim--ceb--conv",
"m_visc1/m_visc1----conv",
"m_visc2/m_visc2----conv",
"m_visc3/m_visc3----conv",
"m_visc4/m_visc4----conv",
"m_bb_000/m_bb_000----conv",
"m_bb_022/m_bb_022----conv",
"m_bb_044/m_bb_044----conv",
"m_bb_066/m_bb_066----conv",
"m_bb_088/m_bb_088----conv",
"m_visc1_tvisc/m_visc1_tvisc----conv",
"m_visc2_tvisc/m_visc2_tvisc----conv",
"m_visc3_tvisc/m_visc3_tvisc----conv",
"m_visc4_tvisc/m_visc4_tvisc----conv",
"m_bb_000_tvisc/m_bb_000_tvisc----conv",
"m_bb_022_tvisc/m_bb_022_tvisc----conv",
"m_bb_044_tvisc/m_bb_044_tvisc----conv",
"m_bb_066_tvisc/m_bb_066_tvisc----conv",
"m_bb_088_tvisc/m_bb_088_tvisc----conv",
"m_bb_022_tvisc1/m_bb_022_tvisc1----conv",
"m_bb_044_tvisc1/m_bb_044_tvisc1----conv",
"m_bb_066_tvisc1/m_bb_066_tvisc1----conv",
"m_bb_022_tvisc1_prim/m_bb_022_tvisc1_prim--crust--conv",
"m_bb_022_tvisc1_prim/m_bb_022_tvisc1_prim--fsp--conv",
"m_bb_022_tvisc1_prim/m_bb_022_tvisc1_prim--ceb--conv",
"m_bb_044_tvisc1_prim/m_bb_044_tvisc1_prim--crust--conv",
"m_bb_044_tvisc1_prim/m_bb_044_tvisc1_prim--fsp--conv",
"m_bb_044_tvisc1_prim/m_bb_044_tvisc1_prim--ceb--conv",
"m_bb_066_tvisc1_prim/m_bb_066_tvisc1_prim--crust--conv",
"m_bb_066_tvisc1_prim/m_bb_066_tvisc1_prim--fsp--conv",
"m_bb_066_tvisc1_prim/m_bb_066_tvisc1_prim--ceb--conv",
"m_precond_100/m_precond_100----conv",
"m_precond_50/m_precond_50----conv",
"m_thermal_het/m_thermal_het----conv",
"m_thermal_hom/m_thermal_hom----conv",
"m_precond_100_rr/m_precond_100_rr----conv",
"m_jump_20/m_jump_20----conv",
"m_jump_10/m_jump_10----conv",
"m_viscav_2/m_viscav_2----conv",
"m_viscav_10/m_viscav_10----conv",
"m_bb_066_tvisc1_comp/m_bb_066_tvisc1_comp----conv",
"m_bb_066_tvisc1_prim_comp/m_bb_066_tvisc1_prim_comp--crust--conv",
"m_bb_066_tvisc1_prim_comp/m_bb_066_tvisc1_prim_comp--fsp--conv",
"m_bb_066_tvisc1_prim_comp/m_bb_066_tvisc1_prim_comp--ceb--conv",
"m_bb_066_tvisc1_comp38/m_bb_066_tvisc1_comp38----conv",
"m_bb_066_tvisc1_prim_comp38/m_bb_066_tvisc1_prim_comp38--crust--conv",
"m_bb_066_tvisc1_prim_comp38/m_bb_066_tvisc1_prim_comp38--fsp--conv",
"m_bb_066_tvisc1_prim_comp38/m_bb_066_tvisc1_prim_comp38--ceb--conv",
"mcmb_2600_u/mcmb_2600_u----conv",
"mcmb_2600_prim_u/mcmb_2600_prim_u--crust--conv",
"mcmb_2600_prim_u/mcmb_2600_prim_u--fsp--conv",
"mcmb_2600_prim_u/mcmb_2600_prim_u--ceb--conv",
"mcmb_2800_u/mcmb_2800_u----conv",
"mcmb_2800_prim_u/mcmb_2800_prim_u--crust--conv",
"mcmb_2800_prim_u/mcmb_2800_prim_u--fsp--conv",
"mcmb_2800_prim_u/mcmb_2800_prim_u--ceb--conv",
"mcmb_3000_u/mcmb_3000_u----conv",
"mcmb_3000_prim_u/mcmb_3000_prim_u--crust--conv",
"mcmb_3000_prim_u/mcmb_3000_prim_u--fsp--conv",
"mcmb_3000_prim_u/mcmb_3000_prim_u--ceb--conv",
"mcmbc_3600_u/mcmbc_3600_u----conv",
"mcmbc_3600_prim_u/mcmbc_3600_prim_u--crust--conv",
"mcmbc_3600_prim_u/mcmbc_3600_prim_u--fsp--conv",
"mcmbc_3600_prim_u/mcmbc_3600_prim_u--ceb--conv",
"mcmbc_3800_u/mcmbc_3800_u----conv",
"mcmbc_3800_prim_u/mcmbc_3800_prim_u--crust--conv",
"mcmbc_3800_prim_u/mcmbc_3800_prim_u--fsp--conv",
"mcmbc_3800_prim_u/mcmbc_3800_prim_u--ceb--conv",
"mcmbc_4000_u/mcmbc_4000_u----conv",
"mcmbc_4000_prim_u/mcmbc_4000_prim_u--crust--conv",
"mcmbc_4000_prim_u/mcmbc_4000_prim_u--fsp--conv",
"mcmbc_4000_prim_u/mcmbc_4000_prim_u--ceb--conv",
"m_022_tv1_u/m_022_tv1_u----conv",
"m_022_tv1_prim_u/m_022_tv1_prim_u--crust--conv",
"m_022_tv1_prim_u/m_022_tv1_prim_u--fsp--conv",
"m_022_tv1_prim_u/m_022_tv1_prim_u--ceb--conv",
"m_044_tv1_u/m_044_tv1_u----conv",
"m_044_tv1_prim_u/m_044_tv1_prim_u--crust--conv",
"m_044_tv1_prim_u/m_044_tv1_prim_u--fsp--conv",
"m_044_tv1_prim_u/m_044_tv1_prim_u--ceb--conv",
"m_066_tv1_u/m_066_tv1_u----conv",
"m_066_tv1_prim_u/m_066_tv1_prim_u--crust--conv",
"m_066_tv1_prim_u/m_066_tv1_prim_u--fsp--conv",
"m_066_tv1_prim_u/m_066_tv1_prim_u--ceb--conv",
"m_cc_022_u/m_cc_022_u----conv",
"m_cc_022_u_prim/m_cc_022_u_prim--crust--conv",
"m_cc_022_u_prim/m_cc_022_u_prim--fsp--conv",
"m_cc_022_u_prim/m_cc_022_u_prim--ceb--conv",
"m_cc_044_u/m_cc_044_u----conv",
"m_cc_044_u_prim/m_cc_044_u_prim--crust--conv",
"m_cc_044_u_prim/m_cc_044_u_prim--fsp--conv",
"m_cc_044_u_prim/m_cc_044_u_prim--ceb--conv",
"m_cc_066_u/m_cc_066_u----conv",
"m_cc_066_u_prim/m_cc_066_u_prim--crust--conv",
"m_cc_066_u_prim/m_cc_066_u_prim--fsp--conv",
"m_cc_066_u_prim/m_cc_066_u_prim--ceb--conv",
# "256_m_cc_066_u/256_m_cc_066_u----conv",
# "256_044_3800_lith_scl/256_044_3800_lith_scl----conv",
# "256_044_4000/256_044_4000----conv",
# "256_044_4000_1/256_044_4000_1----conv",
# "256_044_3800_lith/256_044_3800_lith----conv",
# "256_044_cc/256_044_cc----conv",
# "256_044_3800_lith_scl_1/256_044_3800_lith_scl_1----conv",
"m_lhz/m_lhz----conv",
"m_bas/m_bas----conv",
"u_recy0/u_recy0----conv",
"u_recy1/u_recy1----conv",
"u_recy2/u_recy2----conv",
"u_recy3/u_recy3----conv",
"u_recy4/u_recy4----conv",
"u_recy5/u_recy5----conv",
"m_ave_c1/m_ave_c1----conv",
"m_ave_c2/m_ave_c2----conv",
"v1/v1----conv",
"v2/v2----conv",
"v3/v3----conv",
"v4/v4----conv",
"v6/v6----conv",
"v7/v7----conv",
"v8/v8----conv",
"v9/v9----conv",
"v10/v10----conv",
"m3400_at/m3400_at----conv",
"m3400_at_prim/m3400_at_prim--crust--conv",
"m3400_at_prim/m3400_at_prim--fsp--conv",
"m3400_at_prim/m3400_at_prim--ceb--conv",
"m3600_at/m3600_at----conv",
"m3600_at_prim/m3600_at_prim--crust--conv",
"m3600_at_prim/m3600_at_prim--fsp--conv",
"m3600_at_prim/m3600_at_prim--ceb--conv",
"m3800_at/m3800_at----conv",
"m3800_at_prim/m3800_at_prim--crust--conv",
"m3800_at_prim/m3800_at_prim--fsp--conv",
"m3800_at_prim/m3800_at_prim--ceb--conv",
"m4000_at/m4000_at----conv",
"m4000_at_prim/m4000_at_prim--crust--conv",
"m4000_at_prim/m4000_at_prim--fsp--conv",
"m4000_at_prim/m4000_at_prim--ceb--conv",
"m4200_at/m4200_at----conv",
"m4200_at_prim/m4200_at_prim--crust--conv",
"m4200_at_prim/m4200_at_prim--fsp--conv",
"m4200_at_prim/m4200_at_prim--ceb--conv",
"m3400_sc/m3400_sc----conv",
"m3400_sc_prim/m3400_sc_prim--crust--conv",
"m3400_sc_prim/m3400_sc_prim--fsp--conv",
"m3400_sc_prim/m3400_sc_prim--ceb--conv",
"m4200_sc/m4200_sc----conv",
"m4200_sc_prim/m4200_sc_prim--crust--conv",
"m4200_sc_prim/m4200_sc_prim--fsp--conv",
"m4200_sc_prim/m4200_sc_prim--ceb--conv",
"m3400_rh/m3400_rh----conv",
"m3400_rh_prim/m3400_rh_prim--crust--conv",
"m3400_rh_prim/m3400_rh_prim--fsp--conv",
"m3400_rh_prim/m3400_rh_prim--ceb--conv",
"m4200_rh/m4200_rh----conv",
"m4200_rh_prim/m4200_rh_prim--crust--conv",
"m4200_rh_prim/m4200_rh_prim--fsp--conv",
"m4200_rh_prim/m4200_rh_prim--ceb--conv",
"m3400_rh_at/m3400_rh_at----conv",
"m3400_rh_at_prim/m3400_rh_at_prim--crust--conv",
"m3400_rh_at_prim/m3400_rh_at_prim--fsp--conv",
"m3400_rh_at_prim/m3400_rh_at_prim--ceb--conv",
"m4200_rh_at/m4200_rh_at----conv",
"m4200_rh_at_prim/m4200_rh_at_prim--crust--conv",
"m4200_rh_at_prim/m4200_rh_at_prim--fsp--conv",
"m4200_rh_at_prim/m4200_rh_at_prim--ceb--conv",
"m3400_sc_2/m3400_sc_2----conv",
"m3400_sc_prim_2/m3400_sc_prim_2--crust--conv",
"m3400_sc_prim_2/m3400_sc_prim_2--fsp--conv",
"m3400_sc_prim_2/m3400_sc_prim_2--ceb--conv",
"m4200_sc_2/m4200_sc_2----conv",
"m4200_sc_prim_2/m4200_sc_prim_2--crust--conv",
"m4200_sc_prim_2/m4200_sc_prim_2--fsp--conv",
"m4200_sc_prim_2/m4200_sc_prim_2--ceb--conv",
"m3400_at_044/m3400_at_044----conv",
"m3400_at_prim_044/m3400_at_prim_044--crust--conv",
"m3400_at_prim_044/m3400_at_prim_044--fsp--conv",
"m3400_at_prim_044/m3400_at_prim_044--ceb--conv",
"m3600_at_044/m3600_at_044----conv",
"m3600_at_prim_044/m3600_at_prim_044--crust--conv",
"m3600_at_prim_044/m3600_at_prim_044--fsp--conv",
"m3600_at_prim_044/m3600_at_prim_044--ceb--conv",
"m3800_at_044/m3800_at_044----conv",
"m3800_at_prim_044/m3800_at_prim_044--crust--conv",
"m3800_at_prim_044/m3800_at_prim_044--fsp--conv",
"m3800_at_prim_044/m3800_at_prim_044--ceb--conv",
"m4000_at_044/m4000_at_044----conv",
"m4000_at_prim_044/m4000_at_prim_044--crust--conv",
"m4000_at_prim_044/m4000_at_prim_044--fsp--conv",
"m4000_at_prim_044/m4000_at_prim_044--ceb--conv",
"m4200_at_044/m4200_at_044----conv",
"m4200_at_prim_044/m4200_at_prim_044--crust--conv",
"m4200_at_prim_044/m4200_at_prim_044--fsp--conv",
"m4200_at_prim_044/m4200_at_prim_044--ceb--conv",
"m3400_sc_044/m3400_sc_044----conv",
"m3400_sc_prim_044/m3400_sc_prim_044--crust--conv",
"m3400_sc_prim_044/m3400_sc_prim_044--fsp--conv",
"m3400_sc_prim_044/m3400_sc_prim_044--ceb--conv",
"m4200_sc_044/m4200_sc_044----conv",
"m4200_sc_prim_044/m4200_sc_prim_044--crust--conv",
"m4200_sc_prim_044/m4200_sc_prim_044--fsp--conv",
"m4200_sc_prim_044/m4200_sc_prim_044--ceb--conv",
"m3400_rh_044/m3400_rh_044----conv",
"m3400_rh_prim_044/m3400_rh_prim_044--crust--conv",
"m3400_rh_prim_044/m3400_rh_prim_044--fsp--conv",
"m3400_rh_prim_044/m3400_rh_prim_044--ceb--conv",
"m4200_rh_044/m4200_rh_044----conv",
"m4200_rh_prim_044/m4200_rh_prim_044--crust--conv",
"m4200_rh_prim_044/m4200_rh_prim_044--fsp--conv",
"m4200_rh_prim_044/m4200_rh_prim_044--ceb--conv",
"m3400_rh_at_044/m3400_rh_at_044----conv",
"m3400_rh_at_prim_044/m3400_rh_at_prim_044--crust--conv",
"m3400_rh_at_prim_044/m3400_rh_at_prim_044--fsp--conv",
"m3400_rh_at_prim_044/m3400_rh_at_prim_044--ceb--conv",
"m4200_rh_at_044/m4200_rh_at_044----conv",
"m4200_rh_at_prim_044/m4200_rh_at_prim_044--crust--conv",
"m4200_rh_at_prim_044/m4200_rh_at_prim_044--fsp--conv",
"m4200_rh_at_prim_044/m4200_rh_at_prim_044--ceb--conv",
"cl1/cl1----conv",
"cl2/cl2----conv",
"cl3/cl3----conv",
"cl4/cl4----conv",
"cl1_s/cl1_s----conv",
"cl2_s/cl2_s----conv",
"cl3_s/cl3_s----conv",
"cl4_s/cl4_s----conv",
"astheno1/astheno1----conv",
"astheno2/astheno2----conv",
"astheno1_prim/astheno1_prim--crust--conv",
"astheno1_prim/astheno1_prim--fsp--conv",
"astheno1_prim/astheno1_prim--ceb--conv",
"astheno2_prim/astheno2_prim--crust--conv",
"astheno2_prim/astheno2_prim--fsp--conv",
"astheno2_prim/astheno2_prim--ceb--conv",
"v3_prim/v3_prim--crust--conv",
"v3_prim/v3_prim--fsp--conv",
"v3_prim/v3_prim--ceb--conv",
"v6_prim/v6_prim--crust--conv",
"v6_prim/v6_prim--fsp--conv",
"v6_prim/v6_prim--ceb--conv",
"v9_prim/v9_prim--crust--conv",
"v9_prim/v9_prim--fsp--conv",
"v9_prim/v9_prim--ceb--conv"
]

base_path = '/media/will/Monika1/backup_convert/convert'

# Path to PREM
prem_file_path = '/home/will/Documents/rapid_mineos/models/prem_noocean.txt'
crust2 = read_data(prem_file_path, skiprows=3)
prem_radii = crust2[:, 0]

depths = ['2890', '2844.8438', '2799.6875', '2754.5312', '2709.375', '2664.2188', '2619.0625', '2573.9062', '2528.75', '2483.5938',
              '2438.4375', '2393.2812', '2348.125', '2302.9688', '2257.8125', '2212.6562', '2167.5', '2122.3438', '2077.1875', '2032.0312',
              '1986.875', '1941.7188', '1896.5625', '1851.4062', '1806.25', '1761.0938', '1715.9375', '1670.7812', '1625.625', '1580.4688',
              '1535.3125', '1490.1562', '1445', '1399.8438', '1354.6875', '1309.5312', '1264.375', '1219.2188', '1174.0625', '1128.9062',
              '1083.75', '1038.5938', '993.4375', '948.2812', '903.125', '857.9688', '812.8125', '767.6562', '722.5', '677.3438',
              '632.1875', '587.0312', '541.875', '496.7188', '451.5625', '406.4062', '361.25', '316.0938', '270.9375', '225.7812',
              '180.625', '135.4688', '90.3125', '45.1562']

    # for 256 res models. incompressible_400
    # depths = ['2890', '2867.4221', '2844.8438', '2822.2654', '2799.6875', '2777.1096', '2754.5312', '2731.9529', '2709.375',
    #  '2686.7971', '2664.2188', '2641.6404', '2619.0625', '2596.4846', '2573.9062', '2551.3279', '2528.75', '2506.1721', '2483.5938',
    #  '2461.0154', '2438.4375', '2415.8596', '2393.2812', '2370.7029', '2348.125', '2325.5471', '2302.9688', '2280.3904', '2257.8125',
    #  '2235.2344', '2212.6562', '2190.0781', '2167.5', '2144.9219', '2122.3438', '2099.7656', '2077.1875', '2054.6094', '2032.0312',
    #  '2009.4531', '1986.875', '1964.2969', '1941.7188', '1919.1406', '1896.5625', '1873.9844', '1851.4062', '1828.8281', '1806.25',
    #  '1783.6719', '1761.0938', '1738.5156', '1715.9375', '1693.3594', '1670.7812', '1648.2031', '1625.625', '1603.0469', '1580.4688',
    #  '1557.8906', '1535.3125', '1512.7344', '1490.1562', '1467.5781', '1445', '1422.4219', '1399.8438', '1377.2656', '1354.6875',
    #  '1332.1094', '1309.5312', '1286.9531', '1264.375', '1241.7969', '1219.2188', '1196.6406', '1174.0625', '1151.4844', '1128.9062',
    #  '1106.3281', '1083.75', '1061.1719', '1038.5938', '1016.0156', '993.4375', '970.8594', '948.2812', '925.7031', '903.125',
    #  '880.5469', '857.9688', '835.3906', '812.8125', '790.2344', '767.6562', '745.0781', '722.5', '699.9219', '677.3438', '654.7656',
    #  '632.1875', '609.6094', '587.0312', '564.4531', '541.875', '519.2969', '496.7188', '474.1406', '451.5625', '428.9844', '406.4062',
    #  '383.8281', '361.25', '338.6719', '316.0938', '293.5156', '270.9375', '248.3594', '225.7812', '203.2031', '180.625', '158.0469',
    #  '135.4688', '112.8906', '90.3125', '67.7344', '45.1558', '22.5781']
    
        # for 256 res models.

    # depths = ['2890', '2867.4219', '2844.8438', '2822.2656', '2799.6875', '2777.1094', '2754.5312', '2731.9531', '2709.375', '2686.7969',
    #           '2664.2188', '2641.6406', '2619.0625', '2596.4844', '2573.9062', '2551.3281', '2528.75', '2506.1719', '2483.5938', '2461.0156',
    #           '2438.4375', '2415.8594', '2393.2812', '2370.7031', '2348.125', '2325.5469', '2302.9688', '2280.3906', '2257.8125', '2235.2344',
    #           '2212.6562', '2190.0781', '2167.5', '2144.9219', '2122.3438', '2099.7656', '2077.1875', '2054.6094', '2032.0312', '2009.4531',
    #           '1986.875', '1964.2969', '1941.7188', '1919.1406', '1896.5625', '1873.9844', '1851.4062', '1828.8281', '1806.25', '1783.6719',
    #           '1761.0938', '1738.5156', '1715.9375', '1693.3594', '1670.7812', '1648.2031', '1625.625', '1603.0469', '1580.4688', '1557.8906',
    #           '1535.3125', '1512.7344', '1490.1562', '1467.5781', '1445', '1422.4219', '1399.8438', '1377.2656', '1354.6875', '1332.1094',
    #           '1309.5312', '1286.9531', '1264.375', '1241.7969', '1219.2188', '1196.6406', '1174.0625', '1151.4844', '1128.9062', '1106.3281',
    #           '1083.75', '1061.1719', '1038.5938', '1016.0156', '993.4375', '970.8594', '948.2812', '925.7031', '903.125', '880.5469',
    #           '857.9688', '835.3906', '812.8125', '790.2344', '767.6562', '745.0781', '722.5', '699.9219', '677.3438', '654.7656', '632.1875',
    #           '609.6094', '587.0312', '564.4531', '541.875', '519.2969', '496.7188', '474.1406', '451.5625', '428.9844', '406.4062', '383.8281',
    #           '361.25', '338.6719', '316.0938', '293.5156', '270.9375', '248.3594', '225.7812', '203.2031', '180.625', '158.0469',
    #           '135.4688', '112.8906', '90.3125', '67.7344', '45.1562', '22.5781']

for model in models:
    parts = model.split('/')
    model_name = parts[-1]
    model_dir = parts[0] if len(parts) > 1 else model_name
    model_path = os.path.join(base_path, model_dir)
    print(model_name)
    output_directory = os.path.join(model_path, f'mineos_profiles_{model_name}')
    os.makedirs(output_directory, exist_ok=True)

    infile_density_path = os.path.join(base_path, model_dir, f'{model_name}_density_depth_45.1562km_2x2.xy')
    infile_density = read_data(infile_density_path)
    longitude = infile_density[:, 0]
    latitude = infile_density[:, 1]

    # --- Cache all the data for depths to minimize file reads
    depth_data = {}
    for depth_str in depths:
        density_file = os.path.join(model_path, f'{model_name}_density_depth_{depth_str}km_2x2.xy')
        vs_file      = os.path.join(model_path, f'{model_name}_vs_depth_{depth_str}km_2x2.xy')
        vp_file      = os.path.join(model_path, f'{model_name}_vp_depth_{depth_str}km_2x2.xy')

        depth_data[depth_str] = {
            "density": read_data(density_file)[:, 2],
            "vs": read_data(vs_file)[:, 2],
            "vp": read_data(vp_file)[:, 2]
        }

    def process_point(i):
        lon = longitude[i]
        lat = latitude[i]
        outfile_path = os.path.join(output_directory, f'{lat}_{lon}.txt')
        os.makedirs(os.path.dirname(outfile_path), exist_ok=True)

        infile_CRUST1 = f'/home/will/Documents/rapid_mineos/models/every1deg_CRUST1_layers_roundeddownpt5deg/CRUST1_layers_{int(lat)}_{int(lon)}.txt'
        CRUST1 = read_data(infile_CRUST1)
        crust_data = CRUST1
        crust1_radius, crust1_density, crust1_vpv, crust1_vsv, crust1_Qbulk, crust1_Qmu, crust1_vph, crust1_vsh, crust1_eta = crust_data.T

        lines_to_write = []

        # --- HEADER ---
        lines_to_write.append(f"{model} {lat} {lon}\n")
        lines_to_write.append("  1    1.00000  1\n")
        lines_to_write.append("XXX 33  66\n")  # Placeholder for number of lines

        # --- 1. PREM lines 4 to 69 (INCLUSIVE) ---
        for row in crust2[0:66]:  # Python 0-based, 3:69 means lines 4 to 69, inclusive
            lines_to_write.append(
                f"{row[0]:8.0f} {row[1]:9.2f} {row[2]:9.2f} {row[3]:9.2f} "
                f"{row[4]:9.1f} {row[5]:9.1f} {row[6]:9.2f} {row[7]:9.2f} {row[8]:.5f}\n"
            )

        # --- 2. TERRA values for each depth ---
        first_terra = True
        for depth_str in depths:
            depth = float(depth_str)
            if first_terra:
                radius = 3480000.0
                first_terra = False
            else:
                radius = 6371000 - depth * 1000

            density_terra = depth_data[depth_str]["density"][i]
            vs_terra = depth_data[depth_str]["vs"][i]
            vp_terra = depth_data[depth_str]["vp"][i]
            PREM_etaa = 1.0000
            PREM_Qkk = 57823.0
            PREM_Qmuu = 312.0

            lines_to_write.append(
                f"{radius:8.0f} {density_terra:9.2f} {vp_terra * 1000:9.2f} {vs_terra * 1000:9.2f} "
                f"{PREM_Qkk:9.1f} {PREM_Qmuu:9.1f} {vp_terra * 1000:9.2f} {vs_terra * 1000:9.2f} {PREM_etaa:.5f}\n"
            )

        # --- 3. (OPTIONAL) 6 crustal layers at the end ---
        for j in range(6):
            lines_to_write.append(
                f'{crust1_radius[j]:8.0f} {crust1_density[j]:9.2f} {crust1_vpv[j]:9.2f} {crust1_vsv[j]:9.2f} '
                f'{crust1_Qbulk[j]:9.1f} {crust1_Qmu[j]:9.1f} {crust1_vph[j]:9.2f} {crust1_vsh[j]:9.2f} {crust1_eta[j]:.5f}\n'
            )

        # --- WRITE FILE ---
        with open(outfile_path, 'w') as fid:
            fid.writelines(lines_to_write)

        # --- FIX LINE COUNT IN HEADER ---
        with open(outfile_path, 'r') as fid:
            lines = fid.readlines()
        line_count = len(lines) - 3  # Remove header lines
        lines[2] = f"{line_count} 33  66\n"
        with open(outfile_path, 'w') as fid:
            fid.writelines(lines)

    if __name__ == '__main__':
        with multiprocessing.Pool(processes=10) as pool:  # Set to your number of CPUs
            pool.map(process_point, range(len(longitude)))
