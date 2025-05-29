# model_phasevel_TERRA
Part of the Mantle Circulation Constrained (MC^2) Project.  
Predict frequency-dependent surface wave phase velocity (and group velocity/attenuation) maps from TERRA models. Fundamental mode and overtones using MINEOS.  

-- interpolate_TERRAgrid_to_geogrid.m  
This matlab script converts the TERRA cartesian grid to a regular 2x2 degree grid.  

-- make_profiles_CRUST1.py  
This python script makes mineos profiles at each point on the grid. It uses PREM for Qmu, Qk and eta. The models are isotropic (Vsv=Vsh, Vpv=Vph). The crust is defined by CRUST1.0.  

-- main_TERRA_loop_allmodels_allmodes.f  
This routine calls rapid_mineos.f to predict phase vel, group vel, attenuation at specified modes.  

-- interp_TERRAtoPREM.py  
This interpolates the phase vel/group vel/attenuation predictions at specific periods (in my case, at the specific periods of the hvh2 phase velocity measurements).  

-- make_TERRA_pred_maps.py  
This builds global maps of phase vel/grou vel/attenuation at each mode/period.  

-- run_expand_dc_models_loop.sh  
This routine expands the grid maps into spherical harmonics coefficients.  

hphase_tomofilt.f ----> run_hphase_R_testing_loop.sh  
This applys the tomographic filter of the obseved phase velocity map (hvh2) to the predicted phase velocity map.  
