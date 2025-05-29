#!/bin/bash

# Declare OPTIMAL_ICUT as an associative array
declare -A OPTIMAL_ICUT

# Initialize OPTIMAL_ICUT with your indices as keys and your desired values
# OPTIMAL_ICUT=(
#     [028]=430 [035]=337 [043]=271 [051]=352
#     [061]=385 [072]=479 [084]=570 [098]=652
#     [112]=731 [127]=784 [144]=808 [161]=822
#     [179]=797 [198]=764 [216]=721 [235]=700
#     [253]=700 [271]=657
# )

# OPTIMAL_ICUT=(
#     [018]=250 [022]=250 [027]=250 [033]=250
#     [039]=250 [047]=250 [057]=250 [068]=250
#     [080]=250 [094]=250 [108]=250 [123]=250
#     [139]=250
# )

# OPTIMAL_ICUT=(
#     [039]=250 [047]=250 [056]=250 [066]=250
#     [078]=250 [091]=250 [105]=250 [120]=250
#     [136]=250 [152]=250 [168]=250 [184]=250
#     [200]=250
# )

# OPTIMAL_ICUT=(
#     [068]=250 [079]=250 [091]=250 [105]=250
#     [120]=250 [136]=250 [152]=250 [168]=250
#     [184]=250
# )

OPTIMAL_ICUT=(
    [096]=250 [109]=250 [123]=250 [137]=250
    [152]=250 [167]=250
)


# List of directories to process
dirs=(
# "compressible_400----conv/"
# "CMB3600M----conv/"
# "CMB3800M----conv/"
# "CMB4000M----conv/"
# "tempViscComp----conv/"
# "visc2----conv/"
# "visc3----conv/"
# "visc4----conv/"
# "visc5----conv/"
# "visc6----conv/"
# "visc7----conv/"
# "m_bb_066_tvisc1_comp----conv/"
# "m_bb_066_tvisc1_comp38----conv/"
# "m_bb_066_tvisc1_prim_comp38--crust--conv/"
# "m_bb_066_tvisc1_prim_comp38--fsp--conv/"
# "m_bb_066_tvisc1_prim_comp38--ceb--conv/"
# "mcmbc_3600_u----conv/"
# "mcmbc_3600_prim_u--crust--conv/"
# "mcmbc_3600_prim_u--fsp--conv/"
# "mcmbc_3600_prim_u--ceb--conv/"
# "mcmbc_3800_u----conv/"
# "mcmbc_3800_prim_u--crust--conv/"
# "mcmbc_3800_prim_u--fsp--conv/"
# "mcmbc_3800_prim_u--ceb--conv/"
# "mcmbc_4000_u----conv/"
# "mcmbc_4000_prim_u--crust--conv/"
# "mcmbc_4000_prim_u--fsp--conv/"
# "mcmbc_4000_prim_u--ceb--conv/"
# "m_022_tv1_u----conv/"
# "m_022_tv1_prim_u--crust--conv/"
# "m_022_tv1_prim_u--fsp--conv/"
# "m_022_tv1_prim_u--ceb--conv/"
# "m_044_tv1_u----conv/"
# "m_044_tv1_prim_u--crust--conv/"
# "m_044_tv1_prim_u--fsp--conv/"
# "m_044_tv1_prim_u--ceb--conv/"
# "m_066_tv1_u----conv/"
# "m_066_tv1_prim_u--crust--conv/"
# "m_066_tv1_prim_u--fsp--conv/"
# "m_066_tv1_prim_u--ceb--conv/"
# "m_cc_022_u----conv/"
# "m_cc_022_u_prim--crust--conv/"
# "m_cc_022_u_prim--fsp--conv/"
# "m_cc_022_u_prim--ceb--conv/"
# "m_cc_044_u----conv/"
# "m_cc_044_u_prim--crust--conv/"
# "m_cc_044_u_prim--fsp--conv/"
# "m_cc_044_u_prim--ceb--conv/"
# "m_cc_066_u----conv/"
# "m_cc_066_u_prim--crust--conv/"
# "m_cc_066_u_prim--fsp--conv/"
# "m_cc_066_u_prim--ceb--conv/"
#-------------------------------------adiabat
# "CMB2600----conv/"
# "CMB2600_scale----conv/"
# "CMB2800----conv/"
# "CMB2800_scale----conv/"
# "CMB3000----conv/"
# "CMB3000_scale----conv/"
# "CMB3200----conv/"
# "CMB3200_scale----conv/"
# "CMB3400----conv/"
# "CMB3400_scale----conv/"
# "106_scale----conv/"
# "107_scale----conv/"
# "108_scale----conv/"
# "thermal----conv/"
# "primordial_6--crust--conv/"
# "primordial_6--fsp--conv/"
# "primordial_6--ceb--conv/"
# "primordial_8--crust--conv/"
# "primordial_8--fsp--conv/"
# "primordial_8--ceb--conv/"
# "thermal2----conv/"
# "primordial_5--crust--conv/"
# "primordial_5--fsp--conv/"
# "primordial_5--ceb--conv/"
# "PR_6--crust--conv/"
# "PR_6--fsp--conv/"
# "PR_6--ceb--conv/"
# "PR_6--crust--conv/"
# "PR_6--fsp--conv/"
# "PR_6--ceb--conv/"
# "BB055--crust--conv/"
# "BB055--fsp--conv/"
# "BB055--ceb--conv/"
# "BB066--crust--conv/"
# "BB066--fsp--conv/"
# "BB066--ceb--conv/"
# "BB088--crust--conv/"
# "BB088--fsp--conv/"
# "BB088--ceb--conv/"
# "primordial_3--crust--conv/"
# "primordial_3--fsp--conv/"
# "primordial_3--ceb--conv/"
# "primordial_4--crust--conv/"
# "primordial_4--fsp--conv/"
# "primordial_4--ceb--conv/"
# "PR_3--crust--conv/"
# "PR_3--fsp--conv/"
# "PR_3--ceb--conv/"
# "PR_4--crust--conv/"
# "PR_4--fsp--conv/"
# "PR_4--ceb--conv/"
# "PR_5--crust--conv/"
# "PR_5--fsp--conv/"
# "PR_5--ceb--conv/"
# "icond005----conv/"
# "icond009----conv/"
# "tempVisc----conv/"
# "BB000----conv/"
# "BB022----conv/"
# "BB044----conv/"
# "visc4_incomp----conv/"
# "visc5_incomp----conv/"
# "visc6_incomp----conv/"
# "visc7_incomp----conv/"
# "BB033----conv/"
# "PR_4_150--crust--conv/"
# "PR_4_150--fsp--conv/"
# "PR_4_150--ceb--conv/"
# "PR_4_150--crust--conv/"
# "PR_4_150--fsp--conv/"
# "PR_4_150--ceb--conv/"
# "PR_4_150--crust--conv/"
# "PR_4_150--fsp--conv/"
# "PR_4_150--ceb--conv/"
# "BB066_tvisc----conv/"
# "CMB2600_2----conv/"
# "CMB2600_2_tvisc----conv/"
# "CMB2600_2_prim--crust--conv/"
# "CMB2600_2_prim--fsp--conv/"
# "CMB2600_2_prim--ceb--conv/"
# "CMB2600_2_prim_tvisc--crust--conv/"
# "CMB2600_2_prim_tvisc--fsp--conv/"
# "CMB2600_2_prim_tvisc--ceb--conv/"
# "CMB2800_2----conv/"
# "CMB2800_2_tvisc----conv/"
# "CMB2800_2_prim--crust--conv/"
# "CMB2800_2_prim--fsp--conv/"
# "CMB2800_2_prim--ceb--conv/"
# "CMB2800_2_prim_tvisc--crust--conv/"
# "CMB2800_2_prim_tvisc--fsp--conv/"
# "CMB2800_2_prim_tvisc--ceb--conv/"
# "CMB3000_2----conv/"
# "CMB2800_2_tvisc----conv/"
# "CMB3000_2_prim--crust--conv/"
# "CMB3000_2_prim--fsp--conv/"
# "CMB3000_2_prim--ceb--conv/"
# "CMB3000_2_prim_tvisc--crust--conv/"
# "CMB3000_2_prim_tvisc--fsp--conv/"
# "CMB3000_2_prim_tvisc--ceb--conv/"
# "CC_highT----conv/"
# "CC_highT_prim--crust--conv/"
# "CC_highT_prim--fsp--conv/"
# "CC_highT_prim--ceb--conv/"
# "CC----conv/"
# "CC_prim--crust--conv/"
# "CC_prim--fsp--conv/"
# "CC_prim--ceb--conv/"
# "CC_lowT----conv/"
# "CC_lowT_prim--crust--conv/"
# "CC_lowT_prim--fsp--conv/"
# "CC_lowT_prim--ceb--conv/"
# "muller_3000----conv/"
# "muller_3000_prim--crust--conv/"
# "muller_3000_prim--fsp--conv/"
# "muller_3000_prim--ceb--conv/"
# "muller_2600----conv/"
# "muller_2600_prim--crust--conv/"
# "muller_2600_prim--fsp--conv/"
# "muller_2600_prim--ceb--conv/"
# "muller_2800----conv/"
# "muller_2800_prim--crust--conv/"
# "muller_2800_prim--fsp--conv/"
# "muller_2800_prim--ceb--conv/"
# "m_visc1----conv/"
# "m_visc2----conv/"
# "m_visc3----conv/"
# "m_visc4----conv/"
# "m_bb_000----conv/"
# "m_bb_022----conv/"
# "m_bb_044----conv/"
# "m_bb_066----conv/"
# "m_bb_088----conv/"
# "m_visc1_tvisc----conv/"
# "m_visc2_tvisc----conv/"
# "m_visc3_tvisc----conv/"
# "m_visc4_tvisc----conv/"
# "m_bb_000_tvisc----conv/"
# "m_bb_022_tvisc----conv/"
# "m_bb_044_tvisc----conv/"
# "m_bb_066_tvisc----conv/"
# "m_bb_088_tvisc----conv/"
# "m_bb_022_tvisc----conv/"
# "m_bb_044_tvisc----conv/"
# "m_bb_066_tvisc----conv/"
# "m_bb_022_tvisc1_prim--crust--conv/"
# "m_bb_022_tvisc1_prim--fsp--conv/"
# "m_bb_022_tvisc1_prim--ceb--conv/"
# "m_bb_044_tvisc1_prim--crust--conv/"
# "m_bb_044_tvisc1_prim--fsp--conv/"
# "m_bb_044_tvisc1_prim--ceb--conv/"
# "m_bb_066_tvisc1_prim--crust--conv/"
# "m_bb_066_tvisc1_prim--fsp--conv/"
# "m_bb_066_tvisc1_prim--ceb--conv/"
# "m_precond_100----conv/"
# "m_precond_50----conv/"
# "m_thermal_het----conv/"
# "m_thermal_hom----conv/"
# "m_precond_100_rr----conv/"
# "m_jump_20----conv/"
# "m_jump_10----conv/"
# "m_viscav_2----conv/"
# "m_viscav_10----conv/"
# "mcmb_2600_u----conv/"
# "mcmb_2600_prim_u--crust--conv/"
# "mcmb_2600_prim_u--fsp--conv/"
# "mcmb_2600_prim_u--ceb--conv/"
# "mcmb_2800_u----conv/"
# "mcmb_2800_prim_u--crust--conv/"
# "mcmb_2800_prim_u--fsp--conv/"
# "mcmb_2800_prim_u--ceb--conv/"
# "mcmb_3000_u----conv/"
# "mcmb_3000_prim_u--crust--conv/"
# "mcmb_3000_prim_u--fsp--conv/"
# "mcmb_3000_prim_u--ceb--conv/"
# "m_lhz----conv/"
# "m_bas----conv/"
# "u_recy0----conv/"
# "u_recy1----conv/"
# "u_recy2----conv/"
# "u_recy3----conv/"
# "u_recy4----conv/"
# "u_recy5----conv/"
# "m_ave_c1----conv/"
# "m_ave_c2----conv/"
# "v1----conv/"
# "v2----conv/"
# "v3----conv/"
# "v4----conv/"
# "v6----conv/"
# "v7----conv/"
# "v8----conv/"
# "v9----conv/"
# "v10----conv/"
# "m3400_at----conv/"
# "m3400_at_prim--crust--conv/"
# "m3400_at_prim--fsp--conv/"
# "m3400_at_prim--ceb--conv/"
# "m3600_at----conv/"
# "m3600_at_prim--crust--conv/"
# "m3600_at_prim--fsp--conv/"
# "m3600_at_prim--ceb--conv/"
# "m3800_at----conv/"
# "m3800_at_prim--crust--conv/"
# "m3800_at_prim--fsp--conv/"
# "m3800_at_prim--ceb--conv/"
# "m4000_at----conv/"
# "m4000_at_prim--crust--conv/"
# "m4000_at_prim--fsp--conv/"
# "m4000_at_prim--ceb--conv/"
# "m4200_at----conv/"
# "m4200_at_prim--crust--conv/"
# "m4200_at_prim--fsp--conv/"
# "m4200_at_prim--ceb--conv/"
# "m3400_rh----conv/"
# "m3400_rh_prim--crust--conv/"
# "m3400_rh_prim--fsp--conv/"
# "m3400_rh_prim--ceb--conv/"
# "m4200_rh----conv/"
# "m3400_rh_at----conv/"
# "m3400_rh_at_prim--crust--conv/"
# "m3400_rh_at_prim--fsp--conv/"
# "m3400_rh_at_prim--ceb--conv/"
# "m4200_rh_at_prim--crust--conv/"
# "m4200_rh_at_prim--fsp--conv/"
# "m4200_rh_at_prim--ceb--conv/"
# "incompressible_400----conv/"
# "256_044_cc----conv/"
# "256_044_4000_1----conv/"
# "256_044_3800_lith_scl----conv/"
# "256_044_3800_lith_scl_1----conv/"
# ------- for selected models with overtones --------------
"m_cc_022_u----conv/"
"m_cc_022_u_prim--ceb--conv/"
"m_cc_022_u_prim--crust--conv/"
"m_cc_022_u_prim--fsp--conv/"
"m_cc_044_u----conv/"
"m_cc_044_u_prim--ceb--conv/"
"m_cc_044_u_prim--crust--conv/"
"m_cc_044_u_prim--fsp--conv/"
"m_cc_066_u----conv/"
"m_cc_066_u_prim--ceb--conv/"
"m_cc_066_u_prim--crust--conv/"
"m_cc_066_u_prim--fsp--conv/"
"m_022_tv1_prim_u--ceb--conv/"
"m_022_tv1_prim_u--crust--conv/"
"m_022_tv1_prim_u--fsp--conv/"
"m_022_tv1_u----conv/"
"m_044_tv1_prim_u--ceb--conv/"
"m_044_tv1_prim_u--crust--conv/"
"m_044_tv1_prim_u--fsp--conv/"
"m_044_tv1_u----conv/"
"m_066_tv1_prim_u--ceb--conv/"
"m_066_tv1_prim_u--crust--conv/"
"m_066_tv1_prim_u--fsp--conv/"
"m_066_tv1_u----conv/"
"visc2----conv/"
"visc3----conv/"
"visc4----conv/"
"visc5----conv/"
"visc6----conv/"
"visc7----conv/"
"mcmbc_3600_prim_u--ceb--conv/"
"mcmbc_3600_prim_u--crust--conv/"
"mcmbc_3600_prim_u--fsp--conv/"
"mcmbc_3600_u----conv/"
"mcmbc_3800_prim_u--ceb--conv/"
"mcmbc_3800_prim_u--crust--conv/"
"mcmbc_3800_prim_u--fsp--conv/"
"mcmbc_3800_u----conv/"
"mcmbc_4000_prim_u--ceb--conv/"
"mcmbc_4000_prim_u--crust--conv/"
"mcmbc_4000_prim_u--fsp--conv/"
"mcmbc_4000_u----conv/"
)

# Base directory
#base_dir="/media/will/WS/adiabat/"
#base_dir="/media/will/WS/"
base_dir="/media/will/Monika/overtone_preds/"

for dir in "${dirs[@]}"; do
    full_dir="${base_dir}${dir}"

    #for i in 028 035 043 051 061 072 084 098 112 127 144 161 179 198 216 235 253 271
    #for i in 018 022 027 033 039 047 057 068 080 094 108 123 139
    #for i in 039 047 056 066 078 091 105 120 136 152 168 184 200
    #for i in 068 079 091 105 120 136 152 168 184
    for i in 096 109 123 137 152 167
    do
        ICUT=${OPTIMAL_ICUT[$i]}

        #LMAX=40
        LMAX=20
        #INDIR=/data/will/hvh2v_out/0Sv
        #INDIR=/data/will/hvh2v_out/1Sv
        #INDIR=/data/will/hvh2v_out/2Sv
        #INDIR=/data/will/hvh2v_out/3Sv
        INDIR=/data/will/hvh2v_out/4Sv
        #FILE=hvh2v.000S${i}.1stdclus_cp5deg
        #FILE=hvh2v.001S${i}.1stdclus_cp5deg
        #FILE=hvh2v.002S${i}.1stdclus_cp5deg
        #FILE=hvh2v.003S${i}.1stdclus_cp5deg
        FILE=hvh2v.004S${i}.1stdclus_cp5deg
        INFILE=${INDIR}/${FILE}.txt
        XYZINFILE=xyzinfle
        #OUTDIR=/data/will/hvh2v_out/0Sv/${FILE}
        #OUTDIR=/data/will/hvh2v_out/1Sv/${FILE}
        #OUTDIR=/data/will/hvh2v_out/2Sv/${FILE}
        #OUTDIR=/data/will/hvh2v_out/3Sv/${FILE}
        OUTDIR=/data/will/hvh2v_out/4Sv/${FILE}
        OUTDIR=${OUTDIR}'_lmax'${LMAX}
        OUTPREFIX=${OUTDIR}/$1
        JUNKDIR=junk
        ETA0=1
        ETA1=1
        ETA2=1
        #ICUT=652
        mkdir $OUTDIR
        echo ${INFILE}
        echo ${OUTPREFIX}

        #sphin_file=0S${i}_CCv3.sph2
        #sphin_file=1S${i}_CCv3.sph2
        #sphin_file=2S${i}_CCv3.sph2
        #sphin_file=3S${i}_CCv3.sph2
        sphin_file=4S${i}_CCv3.sph2

        echo ${full_dir}${sphin_file} > ${XYZINFILE}
        echo ${full_dir}${sphin_file}.xyz >> ${XYZINFILE}
        echo 2 >> ${XYZINFILE} 		    #dc contour level
        echo 0.01 >> ${XYZINFILE}	     #1=*100, 0.01=not
        echo 1 $LMAX >> ${XYZINFILE}
        echo 2 >> ${XYZINFILE}

        build/bin/raw2xyz_jr < ${XYZINFILE}

        echo apply tomographic filter 
        build/bin/hphase_tomofilt ${OUTPREFIX}evc ${full_dir}${sphin_file} output_file.sph -c ${ICUT} > ${JUNKDIR}/junk_tomofilt

        cp output_file.sph ${full_dir}${sphin_file}_tomofiltered.sph

        # Output model file in spherical harmonics is: ${OUTPREFIX}inv
        #echo Convert spherical harmonic model coefficients into dc/c for geographical coordinates
        echo ${full_dir}${sphin_file}_tomofiltered.sph > ${XYZINFILE}
        echo ${full_dir}${sphin_file}_tomofiltered.xyz >> ${XYZINFILE}
        echo 2 >> ${XYZINFILE} 		    #dc contour level
        echo 0.01 >> ${XYZINFILE}	     #1=*100, 0.01=not
        echo 1 $LMAX >> ${XYZINFILE}
        echo 2 >> ${XYZINFILE}

        build/bin/raw2xyz_jr < ${XYZINFILE}

        echo OUTPUT= ${full_dir}${sphin_file}_tomofiltered_cp5.xyz
    done
done

echo -- end time --
