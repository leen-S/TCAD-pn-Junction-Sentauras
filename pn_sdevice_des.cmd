* This file is device simulation command file.
* It has many sections
* This is a comment


* Input Output file section *
File{
   Grid      = "sdemodel_msh.tdr"		* input mesh file
   Plot      = "pn_dev_plot.tdr"		* output device tdr
*   Parameter = "@parameter@"			* input material par file
   Current   = "pn_dev_current.plt"		* output current plt
   Output    = "pn_output.log"			* output log file
}
* The input mesh file name should match the mesh file output of SDE.


* Electrode (Contacts) Section *
Electrode{
   { Name="a"    Voltage= 0.0 }		* initial condition on electrodes (contacts)
   { Name="c"    Voltage= 0.0 }		* prefer equilibrium
}
* The name of the contacts should match with those defined in SDE command file.


* Physics section - What physical models to activate *
Physics{
   EffectiveIntrinsicDensity(NoBandGapNarrowing)
   Recombination(SRH(DopingDependence))
   Mobility(DopingDependence)
}
* The format is "Keyword(Options)"


* The output device tdr file will save these *
* keywords properties mentioned in Plot section *
Plot{
*--Density and Currents, etc
   eDensity hDensity
   TotalCurrent/Vector eCurrent/Vector hCurrent/Vector
   eMobility hMobility
   eVelocity hVelocity
   eQuasiFermi hQuasiFermi

*--Temperature 
   eTemperature Temperature hTemperature

*--Fields and charges
   ElectricField/Vector Potential SpaceCharge

*--Doping Profiles
   Doping DonorConcentration AcceptorConcentration

*--Generation/Recombination
   SRH Band2Band Auger
   AvalancheGeneration eAvalancheGeneration hAvalancheGeneration

*--Driving forces
   eGradQuasiFermi/Vector hGradQuasiFermi/Vector
   eEparallel hEparallel eENormal hENormal

*--Band structure/Composition
   BandGap 
   BandGapNarrowing
   Affinity
   ConductionBand ValenceBand
   eQuantumPotential hQuantumPotential
   
*--Stress related data
   StressXX StressYY StressZZ
   StressXY StressXZ StressYZ
}
* Some of these would not make sense without solving for them by activating
* the concerned physical models in the Physics section


* The maths of the numerical solvers - not changed usually *
Math {
  Extrapolate
  Derivatives
  Avalderivatives
  RelErrControl
  Digits= 5 *(for precision)
  ErRef(electron)= 1.e10
  ErRef(hole)= 1.e10
  Notdamped= 50
  Iterations= 20
  Directcurrent
  Method= ILS
  ILSrc= "
  set(1){
	  iterative( gmres(100), tolrel=1e-8, maxit=200);
	  preconditioning(ilut(0.0005,-1),left);
	  ordering ( symmetric=nd, nonsymmetric=mpsilst );
	  options(compact=yes,verbose=0);
  };
  "  
   eMobilityAveraging= ElementEdge
   * uses edge mobility instead of element one for electron mobility	
   hMobilityAveraging= ElementEdge   
   * uses edge mobility instead of element one for hole mobility
   GeometricDistances 		         
   * when needed, compute distance to the interface instead of closest point on the interface
   ParameterInheritance= Flatten 	  
   * regions inherit parameters from materials  
}
* For first time users, do not change the Maths section


* Solve section specifies the sweeps and the equations to solve
Solve{
  NewCurrentFile="initial" 
  Coupled(Iterations= 100 LineSearchDamping= 1e-4){Poisson}
  Save(FilePrefix="first")
  
  Load(FilePrefix="first")
  NewCurrentFile="p_sweep_" 
  Quasistationary(
     InitialStep= 0.01
     MaxStep= 0.05 Minstep= 1.e-5
     Increment= 1.3
     
     Goal {Name="a" Voltage=1}) {Coupled{Poisson Electron Hole}
     Plot (FilePrefix="p_sweep_" Time=(0;0.2;0.4;0.6;0.8;1) NoOverwrite)}
}

