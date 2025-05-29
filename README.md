# model_phasevel_TERRA
Part of the Mantle Circulation Constrained (MC^2) Project.  
Predict frequency-dependent surface wave phase velocity (and group velocity/attenuation) maps from TERRA models. Fundamental mode and overtones using MINEOS.  

-- 1. --interpolate_TERRAgrid_to_geogrid.m  
This matlab script converts the TERRA cartesian grid to a regular 2x2 degree grid.  

-- 2. -- make_profiles_CRUST1.py  
This python script makes mineos profiles at each point on the grid. It uses PREM for Qmu, Qk and eta. The models are isotropic (Vsv=Vsh, Vpv=Vph). The crust is defined by CRUST1.0.  

-- 3. -- main_TERRA_loop_allmodels_allmodes.f  
This routine calls rapid_mineos.f (which is in my Github respository, which includes installation info) to predict phase vel, group vel, attenuation at specified modes.  
This script is used as part of the rapid_mineos package. You must copy this script to main.f and then recompile.
Currently this script is only set-up for fundamental modes, so you need to uncomment certain parts for the overtones and set nmax to e.g. 4 (instead of 0).

-- 4. -- interp_TERRAtoPREM_loop.py  
This interpolates the phase vel/group vel/attenuation predictions at specific periods (in my case, at the specific periods of the hvh2 phase velocity measurements).  

-- 5. -- make_TERRA_pred_maps.py  
This builds global maps of phase vel/grou vel/attenuation at each mode/period.  

-- 6. --run_expand_dc_models_loop.sh  
This routine expands the grid maps into spherical harmonics coefficients.  

-- 7. -- run_hphase_R_testing_loop.sh
calls hphase_tomofilt.f. This applys the tomographic filter of the obseved phase velocity map (hvh2) to the predicted phase velocity map.  
