module SurfaceCoverage
using LightXML
using Printf

using SurfaceReactions
using RxnHelperUtils

export coverage

"""
This function is to test a surface reaction mechanism.
Ideally the sum of fluxes must vanish at steady state. 
The function also gives the surface coverages for a 
given gasphase concentration and T,p conditions.
The program generates only a screen outout
#   Usage:
-   coverage(input_file, lib_dir)
-   input_file: name of the input file (String)
-   lib_dir: path to the folder where the data files are present
"""
function  coverage(input_file::AbstractString, lib_dir::AbstractString)
    
    local gasphase = Array{String,1}()    

    xmldoc = parse_file(input_file)
    xmlroot = root(xmldoc)
    #Read the gasphase
    #tag_gasphase = get_elements_by_tagname(xmlroot,"gasphase")
    gasphase = get_collection_from_xml(xmlroot,"gasphase")
    #thermo_file = lib_dir*"therm.dat"
    thermo_file = get_path(lib_dir, "therm.dat")
    thermo_obj = SurfaceReactions.IdealGas.create_thermo(gasphase, thermo_file)        
    
    #Get the molefractions
    mole_fracs = get_molefraction_from_xml(xmlroot,thermo_obj.molwt,gasphase)
    
    #Read the temperature xml
    local T = get_value_from_xml(xmlroot,"T")
    #Get the pressure from xml
    local p = get_value_from_xml(xmlroot,"p")
    

    #Get the mechanism file from xml
    local mech_file = get_text_from_xml(xmlroot,"mech")
    mech_file = lib_dir*"/"*mech_file
    
    md = SurfaceReactions.compile_mech(mech_file,thermo_obj,gasphase)
    covg = md.sm.si.ini_covg
    n_species = length(gasphase)+length(md.sm.species)
    rate = zeros(n_species)    
    all_conc = zeros(n_species)    
    surf_conc = zeros(length(covg))
    rxn_rate = zeros(length(md.sm.reactions))
    #Create the state object    
    state = SurfaceReactions.SurfaceRxnState(T, p, mole_fracs, covg, surf_conc ,  rxn_rate , rate, all_conc)

    #calculate the molar production rates    
    t, state = SurfaceReactions.calculate_ss_molar_production_rates!(state,thermo_obj,md,10.0)
    println("\nInitial coverage: ")
    println("-----------------------")
    for i in eachindex(covg)
        @printf("%12s \t %.4e \n", md.sm.species[i], md.sm.si.ini_covg[i])        
    end
    println("\nT(K): \t",T)
    println("p(Pa): \t", p)
    println("\nFinal coverage and flux after $t(s): \n")    
    println("     Species \t coverage \t flux(mol/m2-s)")
    println("-------------------------------------------------")
    ng = length(state.mole_frac)
    
    for i in eachindex(covg)        
        @printf("%12s \t %.4e \t %+.4e \n",md.sm.species[i], state.covg[i], state.source[ng+i])        
    end
    
    println("\nSum of fluxes (mol/m2-s): ", sum(state.source[ng+1:lastindex(state.source)]))
    println("Sum of coverages: ", sum(state.covg))
    
    return Symbol("Success")
   
end

end
