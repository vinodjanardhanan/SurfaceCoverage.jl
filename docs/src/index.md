```@meta
CurrentModule = SurfaceCoverage
```

# SurfaceCoverage
SurfaceCoverage is a packge for testing a surface reaction mechanism. The code integrates the surface coverages until a steady state is reached for a given gas phase composition, temperature and pressure. i.e.,

```math
\frac{d\theta_k}{dt} = \frac{\dot{s}_k \sigma_k}{\Gamma}
```
where $\theta_k$ is the surface coverage of species  $k$, $t$ is the time, $\dot{s}_k$ is the molar production rate (mol/m$^2$-s) of species $k$, $\sigma_k$ is the site coordination number and $\Gamma$ is the total site density (mol/m$^2$). After successful integration, the code returns the steady-state coverages, surface flux (reaction rate) of individual surface species and the sum of surface coverages and fluxes. Ideally, the surface coverages must sum to 1, and the sum of fluxes must vanish at steady state.


Documentation for [SurfaceCoverage](https://github.com/vinodjanardhanan/SurfaceCoverage.jl).

## Installation
To install the package, use the following commands in the julia REPL
```julia
julia> using Pkg
julia> Pkg.add("SurfaceCoverage")
```
## General interface
```@index
```

```@autodocs
Modules = [SurfaceCoverage]
```

## Executing the code
The code is invoked by using the following method.

On the Julia REPL 
```julia
julia>using SurfaceCoverage
julia>coverage("coverage.xml","lib/")
```


## Input file
The method takes two arguments *input\_file* and *lib\_dir*. The input\_files specifies the input XML file (in this example it is "coverage.xml") and lib\_dir speficies the path to the data files folder where *therm.dat* is present. The structure of the XML input file is shown below.

```
<?xml version="1.0" encoding="ISO-8859-1"?>
<coverage>
    <gasphase>CH4 H2O H2 CO CO2 O2 N2</gasphase>
    <molefractions>CH4=0.2,H2O=0.1,CO2=0.7</molefractions>
    <T>1073.15</T>
    <p>1e5</p>
    <mech>ch4ni.xml</mech>
</coverage>
```

The meaning of different XML tags is explained below.

- <coverage> : tag specifying the model
- <gasphase> : list of gas-phase species present in the reaction mechanism. The species names must be separated by white spaces or tab
- <molefractions> : mole fractions of the gas-phase species. Instead of mole fractions, mass fractions may also be specified. In that case, the tag must be <massfractions>. You must ensure that the sum of mass or mole fractions specified is one. There are no internal checks to verify this.
- <T>: Temperature in K
- <p> : Pressure in Pa
- <mech>: name of the mechanism input file 

In addition to the XML input file, the code also requires a *therm.dat* file. The code expects this file in the *lib_dir* folder by default. You must ensure that all the species present in the XML element <gasphase> are listed in the *therm.dat* file.

## Input file download

The xml input file and the *lib* directory containing other required input files may be downloaded from [here](https://github.com/vinodjanardhanan/Coverage.jl/tree/main/test)

## Output
The code does not generate any file output.  An example of terminal output that inspect generates is shown below

```
Initial coverage: 
-----------------------
        (NI)     6.0000e-01 
       H(NI)     0.0000e+00 
       O(NI)     0.0000e+00 
     CH4(NI)     0.0000e+00 
     H2O(NI)     4.0000e-01 
     CO2(NI)     0.0000e+00 
      CO(NI)     0.0000e+00 
      OH(NI)     0.0000e+00 
       C(NI)     0.0000e+00 
     HCO(NI)     0.0000e+00 
      CH(NI)     0.0000e+00 
     CH3(NI)     0.0000e+00 
     CH2(NI)     0.0000e+00 

T(K):   1073.15
p(Pa):  100000.0

Final coverage and flux after [10.0](s): 

     Species     coverage        flux(mol/m2-s)
-------------------------------------------------
        (NI) 	 2.9259e-01 	 +1.0338e-14 
       H(NI) 	 3.4172e-03 	 +7.5090e-15 
       O(NI) 	 7.0353e-01 	 -3.2467e-15 
     CH4(NI) 	 4.5279e-10 	 +1.1648e-16 
     H2O(NI) 	 8.4369e-05 	 +2.1847e-15 
     CO2(NI) 	 8.5809e-06 	 -4.3368e-19 
      CO(NI) 	 1.4316e-04 	 +1.1914e-17 
      OH(NI) 	 2.2621e-04 	 -2.5742e-15 
       C(NI) 	 1.1795e-06 	 +5.4699e-19 
     HCO(NI) 	 3.0945e-16 	 +0.0000e+00 
      CH(NI) 	 1.8607e-10 	 -8.6209e-20 
     CH3(NI) 	 1.7535e-09 	 -5.8953e-19 
     CH2(NI) 	 1.2266e-09 	 +5.0271e-19 

Sum of fluxes (mol/m2-s): 1.4339057611099624e-14
Sum of coverages: 1.0000000036937517
```