# model_phasevel_TERRA

*** which version of Python and which libraries need to be loaded ***  
*** add one TERRA model here, so that we can see if we can run the whole workflow.

Part of the Mantle Circulation Constrained (MC^2) Project.  
Predict frequency-dependent surface wave phase velocity (and group velocity/attenuation) maps from TERRA models. Fundamental mode and overtones using MINEOS.  

-- 1. -- interpolate_TERRAgrid_to_geogrid.m  
This matlab script converts the TERRA cartesian grid to a regular 2x2 degree grid.  

-- 2. -- make_profiles_CRUST1.py  
This python script makes mineos profiles at each point on the grid. It uses PREM for Qmu, Qk and eta. The models are isotropic (Vsv=Vsh, Vpv=Vph). The crust is defined by CRUST1.0.  
*** Next you must install rapid_mineos, which you can find in my Github (along with installation instructions). ***  

-- 3. -- main_TERRA_loop_allmodels_allmodes.f  
This routine calls mineos to predict phase vel, group vel, attenuation at specified modes.  
This script is used as part of the rapid_mineos package. You must replace main.f in rapid_mineos with main_TERRA_loop_allmodels_allmodes.f. 
Currently this script is only set-up for fundamental modes. If in the future you wish to predict overtones, then you can uncomment certain parts of the code.

**** add launcher for this **** for all profiles/models or just for one. Give an example of an input and output.  

-- 4. -- interp_TERRAtoPREM_loop.py  
This interpolates the phase vel/group vel/attenuation predictions at specific periods (in my case, at the specific periods of the hvh2 phase velocity measurements which are PREM periods).  

-- 5. -- make_TERRA_pred_maps.py  
This builds global maps of phase vel/grou vel/attenuation at each mode/period.  

**** add hphase_expand check exact name and add further installation info ***  

-- 6. -- run_expand_dc_models_loop.sh  
This routine expands the grid maps into spherical harmonics coefficients.  

*** will again have to provide more inputs here for the tomo filtering. ***

-- 7. -- run_hphase_R_testing_loop.sh
calls hphase_tomofilt.f. This applys the tomographic filter of the obseved phase velocity map (hvh2) to the predicted phase velocity map.  

Then finally, add GMT plotting scripts (maybe in a new repository).
