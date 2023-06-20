within MultizoneOfficeComplexAir.BaseClasses.HVACSide.BaseClasses;
model AirSide "Air side system"
  Modelica.Blocks.Interfaces.RealInput loa[15] "Load from external calculator"
    annotation (Placement(transformation(extent={{-128,46},{-100,74}}),
        iconTransformation(extent={{-128,16},{-100,44}})));
  Modelica.Blocks.Interfaces.RealOutput TZon[15] "Zone air temperature"
   annotation (Placement(transformation(extent={{200,-10},
            {220,10}}), iconTransformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealInput TDryBul "Zone air dry bulb temperature"
   annotation (Placement(transformation(extent={{-128,-14},{-100,14}}),
                              iconTransformation(extent={{-128,-34},{-100,-6}})));

   Modelica.Blocks.Interfaces.RealInput TCooSetPoi[15];
  Modelica.Blocks.Interfaces.BooleanInput TCooSetPoi_activate[15];
  Modelica.Blocks.Interfaces.RealInput THeaSetPoi[15];
  Modelica.Blocks.Interfaces.BooleanInput THeaSetPoi_activate[15];
  Modelica.Blocks.Interfaces.RealInput mAirFlow[15];
  Modelica.Blocks.Interfaces.BooleanInput mAirFlow_activate[15];
  Modelica.Blocks.Interfaces.RealInput yPos[15];
  Modelica.Blocks.Interfaces.BooleanInput yPos_activate[15];

  parameter Real alpha =  1.25  "Sizing factor";
  package MediumAir = Buildings.Media.Air "Medium model for air";
  package MediumCHW = Buildings.Media.Water "Medium model for chilled water";
  package MediumHeaWat = Buildings.Media.Water "Medium model for heating water";
  parameter Integer n =  3  "Number of floors";
  parameter Modelica.Units.SI.Pressure PreDroCoiAir=50
    "Pressure drop in the air side";
  parameter Modelica.Units.SI.Pressure PreDroMixingBoxAir=50
    "Pressure drop in the air side";
  parameter Modelica.Units.SI.Pressure PreDroCooWat=79712
    "Pressure drop in the water side";
  parameter Modelica.Units.SI.Temperature TemEcoHig=273.15 + 15.58
    "the highest temeprature when the economizer is on";
  parameter Modelica.Units.SI.Temperature TemEcoLow=273.15 + 0
    "the lowest temeprature when the economizer is on";
  parameter Real MixingBoxDamMin = 0.3 "the minimum damper postion";
  parameter Modelica.Units.SI.VolumeFlowRate VolFloCur[n,:]={{(mAirFloRat1[1]
       + mAirFloRat2[1] + mAirFloRat3[1] + mAirFloRat4[1] + mAirFloRat5[1])/1.2
      *0.5,(mAirFloRat1[1] + mAirFloRat2[1] + mAirFloRat3[1] + mAirFloRat4[1]
       + mAirFloRat5[1])/1.2*0.7,(mAirFloRat1[1] + mAirFloRat2[1] + mAirFloRat3
      [1] + mAirFloRat4[1] + mAirFloRat5[1])/1.2,(mAirFloRat1[1] + mAirFloRat2[
      1] + mAirFloRat3[1] + mAirFloRat4[1] + mAirFloRat5[1])/1.2*2},{(
      mAirFloRat1[2] + mAirFloRat2[2] + mAirFloRat3[2] + mAirFloRat4[2] +
      mAirFloRat5[2])/1.2*0.5,(mAirFloRat1[2] + mAirFloRat2[2] + mAirFloRat3[2]
       + mAirFloRat4[2] + mAirFloRat5[2])/1.2*0.7,(mAirFloRat1[2] + mAirFloRat2
      [2] + mAirFloRat3[2] + mAirFloRat4[2] + mAirFloRat5[2])/1.2,(mAirFloRat1[
      2] + mAirFloRat2[2] + mAirFloRat3[2] + mAirFloRat4[2] + mAirFloRat5[2])/
      1.2*2},{(mAirFloRat1[3] + mAirFloRat2[3] + mAirFloRat3[3] + mAirFloRat4[3]
       + mAirFloRat5[3])/1.2*0.5,(mAirFloRat1[3] + mAirFloRat2[3] + mAirFloRat3
      [3] + mAirFloRat4[3] + mAirFloRat5[3])/1.2*0.7,(mAirFloRat1[3] +
      mAirFloRat2[3] + mAirFloRat3[3] + mAirFloRat4[3] + mAirFloRat5[3])/1.2,(
      mAirFloRat1[3] + mAirFloRat2[3] + mAirFloRat3[3] + mAirFloRat4[3] +
      mAirFloRat5[3])/1.2*2}} "Volume flow rate curve";
  parameter Real HydEff[n,:] = {{0.93*0.65,0.93*0.7,0.93,0.93*0.6} for i in linspace(1,n,n)} "Hydraulic efficiency";
  parameter Real MotEff[n,:] = {{0.6045*0.65,0.6045*0.7,0.6045,0.6045*0.6} for i in linspace(1,n,n)} "Motor efficiency";
  parameter Modelica.Units.SI.Pressure SupPreCur[n,:]={{1400,1000,700,700*0.5}
      for i in linspace(
      1,
      n,
      n)} "Pressure curve";
  parameter Modelica.Units.SI.Pressure RetPreCur[n,:]={{600,400,200,100} for i in
          linspace(
      1,
      n,
      n)} "Pressure curve";
  parameter Modelica.Units.SI.Pressure PreAirDroMai1=140
    "Pressure drop 1 across the duct";
  parameter Modelica.Units.SI.Pressure PreAirDroMai2=140
    "Pressure drop 2 across the main duct";
  parameter Modelica.Units.SI.Pressure PreAirDroMai3=120
    "Pressure drop 3 across the main duct";
  parameter Modelica.Units.SI.Pressure PreAirDroMai4=152
    "Pressure drop 4 across the main duct";
  parameter Modelica.Units.SI.Pressure PreAirDroBra1=0
    "Pressure drop 1 across the duct branch 1";
  parameter Modelica.Units.SI.Pressure PreAirDroBra2=0
    "Pressure drop 1 across the duct branch 2";
  parameter Modelica.Units.SI.Pressure PreAirDroBra3=0
    "Pressure drop 1 across the duct branch 3";
  parameter Modelica.Units.SI.Pressure PreAirDroBra4=0
    "Pressure drop 1 across the duct branch 4";
  parameter Modelica.Units.SI.Pressure PreAirDroBra5=0
    "Pressure drop 1 across the duct branch 5";
  parameter Modelica.Units.SI.Pressure PreWatDroMai1=79712*0.2
    "Pressure drop 1 across the pipe";
  parameter Modelica.Units.SI.Pressure PreWatDroMai2=79712*0.1
    "Pressure drop 2 across the main pipe";
  parameter Modelica.Units.SI.Pressure PreWatDroMai3=79712*0.1
    "Pressure drop 3 across the main pipe";
  parameter Modelica.Units.SI.Pressure PreWatDroMai4=79712*0.1
    "Pressure drop 4 across the main pipe";
  parameter Modelica.Units.SI.Pressure PreWatDroBra1=79712*0.3
    "Pressure drop 1 across the pipe branch 1";
  parameter Modelica.Units.SI.Pressure PreWatDroBra2=79712*0.2
    "Pressure drop 1 across the pipe branch 2";
  parameter Modelica.Units.SI.Pressure PreWatDroBra3=79712*0.1
    "Pressure drop 1 across the pipe branch 3";
  parameter Modelica.Units.SI.Pressure PreWatDroBra4=0
    "Pressure drop 1 across the pipe branch 4";
  parameter Modelica.Units.SI.Pressure PreWatDroBra5=0
    "Pressure drop 1 across the pipe branch 5";
  parameter Modelica.Units.SI.MassFlowRate mAirFloRat1[n]={10.92*1.2*alpha,
      10.92*1.2*10*alpha,10.92*1.2*alpha}*3 "mass flow rate for vav 1";
  parameter Modelica.Units.SI.MassFlowRate mAirFloRat2[n]={2.25*1.2*alpha,2.25*
      1.2*10*alpha,2.25*1.2*alpha}*3 "mass flow rate for vav 2";
  parameter Modelica.Units.SI.MassFlowRate mAirFloRat3[n]={1.49*1.2*alpha,1.49*
      1.2*10*alpha,1.49*1.2*alpha}*3 "mass flow rate for vav 3";
  parameter Modelica.Units.SI.MassFlowRate mAirFloRat4[n]={1.9*1.2*alpha,1.9*
      1.2*10*alpha,1.9*1.2*alpha}*3 "mass flow rate for vav 4";
  parameter Modelica.Units.SI.MassFlowRate mAirFloRat5[n]={1.73*1.2*alpha,1.73*
      1.2*10*alpha,1.73*1.2*alpha}*3 "mass flow rate for vav 5";
  parameter Modelica.Units.SI.MassFlowRate mWatFloRat1[n]={mAirFloRat1[1]*0.3*(
      35 - 12.88)/4.2/20,mAirFloRat1[2]*0.3*(35 - 12.88)/4.2/20,mAirFloRat1[3]*
      0.3*(35 - 12.88)/4.2/20} "mass flow rate for vav 1";
  parameter Modelica.Units.SI.MassFlowRate mWatFloRat2[n]={mAirFloRat2[1]*0.3*(
      35 - 12.88)/4.2/20,mAirFloRat2[2]*0.3*(35 - 12.88)/4.2/20,mAirFloRat2[3]*
      0.3*(35 - 12.88)/4.2/20} "mass flow rate for vav 2";
  parameter Modelica.Units.SI.MassFlowRate mWatFloRat3[n]={mAirFloRat3[1]*0.3*(
      35 - 12.88)/4.2/20,mAirFloRat3[2]*0.3*(35 - 12.88)/4.2/20,mAirFloRat3[3]*
      0.3*(35 - 12.88)/4.2/20} "mass flow rate for vav 3";
  parameter Modelica.Units.SI.MassFlowRate mWatFloRat4[n]={mAirFloRat4[1]*0.3*(
      35 - 12.88)/4.2/20,mAirFloRat4[2]*0.3*(35 - 12.88)/4.2/20,mAirFloRat4[3]*
      0.3*(35 - 12.88)/4.2/20} "mass flow rate for vav 4";
  parameter Modelica.Units.SI.MassFlowRate mWatFloRat5[n]={mAirFloRat5[1]*0.3*(
      35 - 12.88)/4.2/20,mAirFloRat5[2]*0.3*(35 - 12.88)/4.2/20,mAirFloRat5[3]*
      0.3*(35 - 12.88)/4.2/20} "mass flow rate for vav 5";
  parameter Modelica.Units.SI.Pressure PreDroAir1=200
    "Pressure drop in the air side of vav 1";
  parameter Modelica.Units.SI.Pressure PreDroWat1=79712/2
    "Pressure drop in the water side of vav 1";
  parameter Modelica.Units.SI.Efficiency eps1(max=1) = 0.8
    "Heat exchanger effectiveness of vav 1";
  parameter Modelica.Units.SI.Pressure PreDroAir2=124
    "Pressure drop in the air side of vav 2";
  parameter Modelica.Units.SI.Pressure PreDroWat2=79712/2
    "Pressure drop in the water side of vav 2";
  parameter Modelica.Units.SI.Efficiency eps2(max=1) = 0.8
    "Heat exchanger effectiveness of vav 2";
  parameter Modelica.Units.SI.Pressure PreDroAir3=124
    "Pressure drop in the air side of vav 3";
  parameter Modelica.Units.SI.Pressure PreDroWat3=79712/2
    "Pressure drop in the water side of vav 3";
  parameter Modelica.Units.SI.Efficiency eps3(max=1) = 0.8
    "Heat exchanger effectiveness of vav 1";
  parameter Modelica.Units.SI.Pressure PreDroAir4=124
    "Pressure drop in the air side of vav 4";
  parameter Modelica.Units.SI.Pressure PreDroWat4=79712/2
    "Pressure drop in the water side of vav 4";
  parameter Modelica.Units.SI.Efficiency eps4(max=1) = 0.8
    "Heat exchanger effectiveness of vav 1";
  parameter Modelica.Units.SI.Pressure PreDroAir5=124
    "Pressure drop in the air side of vav 1";
  parameter Modelica.Units.SI.Pressure PreDroWat5=79712/2
    "Pressure drop in the water side of vav 1";
  parameter Modelica.Units.SI.Efficiency eps5(max=1) = 0.8
    "Heat exchanger effectiveness of vav 1";
  MultizoneOfficeComplexAir.BaseClasses.BuildingControlEmulator.Systems.Floor floor1(
    redeclare package MediumAir = MediumAir,
    redeclare package MediumHeaWat = MediumHeaWat,
    PreDroCoiAir=PreDroCoiAir,
    PreDroMixingBoxAir=PreDroMixingBoxAir,
    PreDroCooWat=PreDroCooWat,
    TemEcoHig=TemEcoHig,
    TemEcoLow=TemEcoLow,
    MixingBoxDamMin=MixingBoxDamMin,
    waitTime=900,
    HydEff=HydEff[1,:],
    MotEff=MotEff[1,:],
    VolFloCur=VolFloCur[1,:],
    SupPreCur=SupPreCur[1,:],
    RetPreCur=RetPreCur[1,:],
    PreAirDroMai1=PreAirDroMai1,
    PreAirDroMai2=PreAirDroMai2,
    PreAirDroMai3=PreAirDroMai3,
    PreAirDroMai4=PreAirDroMai4,
    PreAirDroBra1=PreAirDroBra1,
    PreAirDroBra2=PreAirDroBra2,
    PreAirDroBra3=PreAirDroBra3,
    PreAirDroBra4=PreAirDroBra4,
    PreAirDroBra5=PreAirDroBra5,
    PreWatDroMai1=PreWatDroMai1,
    PreWatDroMai2=PreWatDroMai2,
    PreWatDroMai3=PreWatDroMai3,
    PreWatDroMai4=PreWatDroMai4,
    PreWatDroBra1=PreWatDroBra1,
    PreWatDroBra2=PreWatDroBra2,
    PreWatDroBra3=PreWatDroBra3,
    PreWatDroBra4=PreWatDroBra4,
    PreWatDroBra5=PreWatDroBra5,
    mAirFloRat1=mAirFloRat1[1],
    mAirFloRat2=mAirFloRat2[1],
    mAirFloRat3=mAirFloRat3[1],
    mAirFloRat4=mAirFloRat4[1],
    mAirFloRat5=mAirFloRat5[1],
    mWatFloRat1=mWatFloRat1[1],
    mWatFloRat2=mWatFloRat2[1],
    mWatFloRat3=mWatFloRat3[1],
    mWatFloRat4=mWatFloRat4[1],
    mWatFloRat5=mWatFloRat5[1],
    PreDroAir1=PreDroAir1,
    PreDroWat1=PreDroWat1,
    eps1=eps1,
    PreDroAir2=PreDroAir2,
    PreDroWat2=PreDroWat2,
    eps2=eps2,
    PreDroAir3=PreDroAir3,
    PreDroWat3=PreDroWat3,
    eps3=eps3,
    PreDroAir4=PreDroAir4,
    PreDroWat4=PreDroWat4,
    eps4=eps4,
    PreDroAir5=PreDroAir5,
    PreDroWat5=PreDroWat5,
    eps5=eps5,
    duaFanAirHanUnit(
      Coi_k=0.1,
      MixingBox_k=0.1,
      MixingBox_Ti=600,
      Fan_k=0.001, Fan_Ti=600,
      booleanExpression(y=floor1.duaFanAirHanUnit.On)),
    redeclare package MediumCooWat = MediumCHW,
    fivZonVAV(vol(V=200000), each vAV(Dam(riseTime=15))))
    annotation (Placement(transformation(extent={{114,20},{164,62}})));

  MultizoneOfficeComplexAir.BaseClasses.BuildingControlEmulator.Systems.Floor floor2(
    redeclare package MediumAir = MediumAir,
    redeclare package MediumHeaWat = MediumHeaWat,
    PreDroCoiAir=PreDroCoiAir,
    PreDroMixingBoxAir=PreDroMixingBoxAir,
    PreDroCooWat=PreDroCooWat,
    TemEcoHig=TemEcoHig,
    TemEcoLow=TemEcoLow,
    MixingBoxDamMin=MixingBoxDamMin,
    waitTime=900,
    HydEff=HydEff[2,:],
    MotEff=MotEff[2,:],
    VolFloCur=VolFloCur[2,:],
    SupPreCur=SupPreCur[2,:],
    RetPreCur=RetPreCur[2,:],
    PreAirDroMai1=PreAirDroMai1,
    PreAirDroMai2=PreAirDroMai2,
    PreAirDroMai3=PreAirDroMai3,
    PreAirDroMai4=PreAirDroMai4,
    PreAirDroBra1=PreAirDroBra1,
    PreAirDroBra2=PreAirDroBra2,
    PreAirDroBra3=PreAirDroBra3,
    PreAirDroBra4=PreAirDroBra4,
    PreAirDroBra5=PreAirDroBra5,
    PreWatDroMai1=PreWatDroMai1,
    PreWatDroMai2=PreWatDroMai2,
    PreWatDroMai3=PreWatDroMai3,
    PreWatDroMai4=PreWatDroMai4,
    PreWatDroBra1=PreWatDroBra1,
    PreWatDroBra2=PreWatDroBra2,
    PreWatDroBra3=PreWatDroBra3,
    PreWatDroBra4=PreWatDroBra4,
    PreWatDroBra5=PreWatDroBra5,
    mAirFloRat1=mAirFloRat1[2],
    mAirFloRat2=mAirFloRat2[2],
    mAirFloRat3=mAirFloRat3[2],
    mAirFloRat4=mAirFloRat4[2],
    mAirFloRat5=mAirFloRat5[2],
    mWatFloRat1=mWatFloRat1[2],
    mWatFloRat2=mWatFloRat2[2],
    mWatFloRat3=mWatFloRat3[2],
    mWatFloRat4=mWatFloRat4[2],
    mWatFloRat5=mWatFloRat5[2],
    PreDroAir1=PreDroAir1,
    PreDroWat1=PreDroWat1,
    eps1=eps1,
    PreDroAir2=PreDroAir2,
    PreDroWat2=PreDroWat2,
    eps2=eps2,
    PreDroAir3=PreDroAir3,
    PreDroWat3=PreDroWat3,
    eps3=eps3,
    PreDroAir4=PreDroAir4,
    PreDroWat4=PreDroWat4,
    eps4=eps4,
    PreDroAir5=PreDroAir5,
    PreDroWat5=PreDroWat5,
    eps5=eps5,
    duaFanAirHanUnit(
      Coi_k=0.1,
      MixingBox_k=0.1,
      MixingBox_Ti=600,
      Fan_k=0.001, Fan_Ti=600,
      booleanExpression(y=floor2.duaFanAirHanUnit.On)),
    redeclare package MediumCooWat = MediumCHW,
    fivZonVAV(vol(V=200000), each vAV(Dam(riseTime=15))))
    annotation (Placement(transformation(extent={{114,20},{164,62}})));

  MultizoneOfficeComplexAir.BaseClasses.BuildingControlEmulator.Systems.Floor floor3(
    redeclare package MediumAir = MediumAir,
    redeclare package MediumHeaWat = MediumHeaWat,
    PreDroCoiAir=PreDroCoiAir,
    PreDroMixingBoxAir=PreDroMixingBoxAir,
    PreDroCooWat=PreDroCooWat,
    TemEcoHig=TemEcoHig,
    TemEcoLow=TemEcoLow,
    MixingBoxDamMin=MixingBoxDamMin,
    waitTime=900,
    HydEff=HydEff[3,:],
    MotEff=MotEff[3,:],
    VolFloCur=VolFloCur[3,:],
    SupPreCur=SupPreCur[3,:],
    RetPreCur=RetPreCur[3,:],
    PreAirDroMai1=PreAirDroMai1,
    PreAirDroMai2=PreAirDroMai2,
    PreAirDroMai3=PreAirDroMai3,
    PreAirDroMai4=PreAirDroMai4,
    PreAirDroBra1=PreAirDroBra1,
    PreAirDroBra2=PreAirDroBra2,
    PreAirDroBra3=PreAirDroBra3,
    PreAirDroBra4=PreAirDroBra4,
    PreAirDroBra5=PreAirDroBra5,
    PreWatDroMai1=PreWatDroMai1,
    PreWatDroMai2=PreWatDroMai2,
    PreWatDroMai3=PreWatDroMai3,
    PreWatDroMai4=PreWatDroMai4,
    PreWatDroBra1=PreWatDroBra1,
    PreWatDroBra2=PreWatDroBra2,
    PreWatDroBra3=PreWatDroBra3,
    PreWatDroBra4=PreWatDroBra4,
    PreWatDroBra5=PreWatDroBra5,
    mAirFloRat1=mAirFloRat1[3],
    mAirFloRat2=mAirFloRat2[3],
    mAirFloRat3=mAirFloRat3[3],
    mAirFloRat4=mAirFloRat4[3],
    mAirFloRat5=mAirFloRat5[3],
    mWatFloRat1=mWatFloRat1[3],
    mWatFloRat2=mWatFloRat2[3],
    mWatFloRat3=mWatFloRat3[3],
    mWatFloRat4=mWatFloRat4[3],
    mWatFloRat5=mWatFloRat5[3],
    PreDroAir1=PreDroAir1,
    PreDroWat1=PreDroWat1,
    eps1=eps1,
    PreDroAir2=PreDroAir2,
    PreDroWat2=PreDroWat2,
    eps2=eps2,
    PreDroAir3=PreDroAir3,
    PreDroWat3=PreDroWat3,
    eps3=eps3,
    PreDroAir4=PreDroAir4,
    PreDroWat4=PreDroWat4,
    eps4=eps4,
    PreDroAir5=PreDroAir5,
    PreDroWat5=PreDroWat5,
    eps5=eps5,
    duaFanAirHanUnit(
      Coi_k=0.1,
      MixingBox_k=0.1,
      MixingBox_Ti=600,
      Fan_k=0.001, Fan_Ti=600,
      booleanExpression(y=floor3.duaFanAirHanUnit.On)),
    redeclare package MediumCooWat = MediumCHW,
    fivZonVAV(vol(V=200000), each vAV(Dam(riseTime=15)))) "Top Floor"
    annotation (Placement(transformation(extent={{114,20},{164,62}})));

  Buildings.Fluid.Sources.Boundary_pT   sou[n](
    nPorts=3,
    redeclare package Medium = MediumAir,
    each p(displayUnit="Pa") = 100000,
    use_T_in=true) "Source"
    annotation (Placement(transformation(extent={{40,30},{60,50}})));

  Modelica.Blocks.Sources.Constant TSupAirSet[n](k=273.15 + 12.88)
    "AHU supply air temperature setpoint"
    annotation (Placement(transformation(extent={{-70,46},{-50,66}})));
  Modelica.Blocks.Sources.Constant dpStaSet[n](k=400)
    "AHU static ressure setpoint"
    annotation (Placement(transformation(extent={{-70,16},{-50,36}})));
  Modelica.Blocks.Sources.BooleanExpression onZon[n](each y=true)
    "Zone VAV terminal on signal"
    annotation (Placement(transformation(extent={{40,62},{60,82}})));
  MultizoneOfficeComplexAir.BaseClasses.BuildingControlEmulator.Devices.AirSide.Terminal.Controls.ZonCon
    zonVAVCon[15](
    MinFlowRateSetPoi=0.3,
    HeatingFlowRateSetPoi=0.5,
    heaCon(Ti=60, yMin=0.01),
    cooCon(k=11, Ti=60))
    "Zone terminal VAV controller (airflow rate, reheat valve)l "
    annotation (Placement(transformation(extent={{60,90},{80,110}})));

  MultizoneOfficeComplexAir.BaseClasses.BuildingControlEmulator.Subsystems.AirHanUnit.BaseClasses.SetPoi TZonAirSet[15](
    n=2,
    setpoint_on={{273.15 + 24,273.15 + 20} for i in linspace(
        1,
        15,
        15)},
    setpoint_off={{273.15 + 26.7,273.15 + 15.6} for i in linspace(
        1,
        15,
        15)})
    "Zone air temperature setpoint controllers based on the occupancy signal"
    annotation (Placement(transformation(extent={{0,90},{20,110}})));
  Modelica.Blocks.Routing.BooleanReplicator booRep(nout=15)
    "Replicate the Occ signal to 15 zones"
    annotation (Placement(transformation(extent={{-30,90},{-10,110}})));
  Modelica.Blocks.Interfaces.RealInput Occ "Occupancy signal"
    annotation (Placement(transformation(extent={{-128,86},{-100,114}}),
        iconTransformation(extent={{-128,66},{-100,94}})));
  Modelica.Blocks.Math.RealToBoolean reaToBooOcc
    "Convert real signal to boolean signal for occupancy signal"
    annotation (Placement(transformation(extent={{-60,90},{-40,110}})));
  Buildings.Utilities.IO.SignalExchange.Overwrite oveFloor1TDisAir(description="Floor 1 AHU supply air temperature setpoint", u(
      max=273.15 + 20,
      unit="K",
      min=273.15 + 8))
    annotation (Placement(transformation(extent={{-40,46},{-20,66}})));
  Buildings.Utilities.IO.SignalExchange.Overwrite oveFloor2TDisAir(description="Floor 2 AHU supply air temperature setpoint", u(
      max=273.15 + 20,
      unit="K",
      min=273.15 + 8))
    annotation (Placement(transformation(extent={{-40,46},{-20,66}})));
  Buildings.Utilities.IO.SignalExchange.Overwrite oveFloor3TDisAir(description="Floor 3 AHU supply air temperature setpoint", u(
      max=273.15 + 20,
      unit="K",
      min=273.15 + 8))
    "AHU supply air temperature overwritten block"
    annotation (Placement(transformation(extent={{-40,46},{-20,66}})));
  Modelica.Blocks.Continuous.FirstOrder firOrd(T=1)
    "First order to smooth the occupancy signal"
    annotation (Placement(transformation(extent={{-90,90},{-70,110}})));
  Modelica.Blocks.Math.Gain loaMulMidFlo[5](k=10) "Load multiplier"
    annotation (Placement(transformation(extent={{-94,54},{-82,66}})));
equation

   connect(sou[1].T_in, TDryBul)
   annotation (Line(points={{38,44},{-38,44},{-38,1.77636e-15},{-114,
          1.77636e-15}},  color={0,0,127}));
   connect(floor1.port_Exh_Air, sou[1].ports[1]) annotation (Line(
      points={{114,34},{90,34},{90,42.6667},{60,42.6667}},
      color={0,140,72},
      thickness=0.5));
   connect(floor1.port_Fre_Air, sou[1].ports[2]) annotation (Line(
      points={{114,52.6667},{90,52.6667},{90,40},{60,40}},
      color={0,140,72},
      thickness=0.5));
  connect(dpStaSet[1].y, floor1.PreSetPoi) annotation (Line(points={{-49,26},{
          102,26},{102,45.6667},{111.5,45.6667}},
                                        color={0,0,127}));
   connect(oveFloor1TDisAir.y, floor1.DisTemPSetPoi) annotation (Line(points={{-19,56},
          {100,56},{100,57.3333},{111.5,57.3333}},
                                                 color={0,0,127}));
  connect(reaToBooOcc.y, floor1.OnFan) annotation (Line(points={{-39,100},{-36,
          100},{-36,86},{106,86},{106,31.6667},{111.5,31.6667}},
                                                      color={255,0,255}));
  connect(floor1.OnZon, onZon[1].y) annotation (Line(points={{111.5,22.3333},{
          108,22.3333},{108,22},{104,22},{104,72},{61,72}},
                                                      color={255,0,255}));
   for j in 1:5 loop
    connect(floor1.TZon[j], zonVAVCon[(1 - 1)*5 + j].T) annotation (Line(points={{166.5,
            43.3333},{180,43.3333},{180,84},{50,84},{50,100},{58,100}},
          color={0,0,127}));
    connect(zonVAVCon[(1 - 1)*5 + j].yAirFlowSetPoi, floor1.AirFlowRatSetPoi[j])
      annotation (Line(points={{81.2,106},{100,106},{100,41},{111.5,41}},
          color={0,0,127}));
    connect(zonVAVCon[(1 - 1)*5 + j].yValPos, floor1.yVal[j]) annotation (Line(
          points={{81.2,94},{102,94},{102,27},{111.5,27}},         color={0,0,127}));
    connect(loa[(1 - 1)*5 + j], floor1.Q_flow[j]);
    connect(floor1.TZon[j], TZon[(1-1)*5+j]);
    connect(TZonAirSet[(1 - 1)*5 + j].SetPoi[1], zonVAVCon[(1 - 1)*5 + j].TCooSetPoi)
      annotation (Line(points={{22,99},{22,102},{32,102},{32,106},{58,106}},
          color={0,0,127}));
    connect(TZonAirSet[(1 - 1)*5 + j].SetPoi[2], zonVAVCon[(1 - 1)*5 + j].THeaSetPoi)
      annotation (Line(points={{22,101},{22,100},{36,100},{36,94},{58,94}},
          color={0,0,127}));
    connect(TZonAirSet[(1 - 1)*5 + j].SetPoi[1], floor1.ZonCooTempSetPoi[j])
      annotation (Line(points={{22,99},{32,99},{32,66.6667},{111.5,66.6667}},
                                                                    color={0,0,127}));
    connect(TZonAirSet[(1 - 1)*5 + j].SetPoi[2], floor1.ZonHeaTempSetPoi[j])
      annotation (Line(points={{22,101},{34,101},{34,82},{98,82},{98,62},{111.5,
            62}},                                                         color=
           {0,0,127}));
   end for;

   for i in 1:5 loop
    connect(loa[(2 - 1)*5 + i], loaMulMidFlo[i].u)
      annotation (Line(points={{-114,60},{-95.2,60}}, color={0,0,127}));
   end for;
   connect(sou[2].T_in, TDryBul);
   connect(floor2.port_Exh_Air, sou[2].ports[1]);
   connect(floor2.port_Fre_Air, sou[2].ports[2]);
  connect(dpStaSet[2].y, floor2.PreSetPoi);
   connect(oveFloor2TDisAir.y, floor2.DisTemPSetPoi);
  connect(reaToBooOcc.y, floor2.OnFan);
  connect(floor2.OnZon, onZon[2].y);
   for j in 1:5 loop
    connect(floor2.TZon[j], zonVAVCon[(2 - 1)*5 + j].T);
    connect(zonVAVCon[(2 - 1)*5 + j].yAirFlowSetPoi, floor2.AirFlowRatSetPoi[j]);
    connect(zonVAVCon[(2 - 1)*5 + j].yValPos, floor2.yVal[j]);
    connect(loaMulMidFlo[j].y, floor2.Q_flow[j]) annotation (Line(points={{-81.4,
            60},{-76,60},{-76,2},{142,2},{142,17.6667},{141.5,17.6667}},
                                                                   color={0,0,127}));
    connect(floor2.TZon[j], TZon[(2-1)*5+j]);
    connect(TZonAirSet[(2 - 1)*5 + j].SetPoi[1], zonVAVCon[(2 - 1)*5 + j].TCooSetPoi);
    connect(TZonAirSet[(2 - 1)*5 + j].SetPoi[2], zonVAVCon[(2 - 1)*5 + j].THeaSetPoi);
    connect(TZonAirSet[(2 - 1)*5 + j].SetPoi[1], floor2.ZonCooTempSetPoi[j]);
    connect(TZonAirSet[(2 - 1)*5 + j].SetPoi[2], floor2.ZonHeaTempSetPoi[j]);
   end for;

   connect(sou[3].T_in, TDryBul);
   connect(floor3.port_Exh_Air, sou[3].ports[1]);
   connect(floor3.port_Fre_Air, sou[3].ports[2]);
  connect(dpStaSet[3].y, floor3.PreSetPoi);
   connect(oveFloor3TDisAir.y, floor3.DisTemPSetPoi);
  connect(reaToBooOcc.y, floor3.OnFan);
  connect(floor3.OnZon, onZon[3].y);
   for j in 1:5 loop
    connect(floor3.TZon[j], zonVAVCon[(3 - 1)*5 + j].T);
    connect(zonVAVCon[(3 - 1)*5 + j].yAirFlowSetPoi, floor3.AirFlowRatSetPoi[j]);
    connect(zonVAVCon[(3 - 1)*5 + j].yValPos, floor3.yVal[j]);
    connect(loa[(3 - 1)*5 + j], floor3.Q_flow[j]);
    connect(floor3.TZon[j], TZon[(3-1)*5+j]);
    connect(TZonAirSet[(3 - 1)*5 + j].SetPoi[1], zonVAVCon[(3 - 1)*5 + j].TCooSetPoi);
    connect(TZonAirSet[(3 - 1)*5 + j].SetPoi[2], zonVAVCon[(3 - 1)*5 + j].THeaSetPoi);
    connect(TZonAirSet[(3 - 1)*5 + j].SetPoi[1], floor3.ZonCooTempSetPoi[j]);
    connect(TZonAirSet[(3 - 1)*5 + j].SetPoi[2], floor3.ZonHeaTempSetPoi[j]);
   end for;
  connect(booRep.y, TZonAirSet.Occ)
    annotation (Line(points={{-9,100},{-2,100}}, color={255,0,255}));
  connect(floor1.TOut, TDryBul) annotation (Line(points={{134,17.6667},{134,0},
          {-84,0},{-84,1.77636e-15},{-114,1.77636e-15}},
                                color={0,0,127}));
  connect(floor2.TOut, TDryBul);
  connect(floor3.TOut, TDryBul);
  connect(TSupAirSet[1].y, oveFloor1TDisAir.u)
    annotation (Line(points={{-49,56},{-42,56}}, color={0,0,127}));
  connect(TSupAirSet[2].y, oveFloor2TDisAir.u);
  connect(TSupAirSet[3].y, oveFloor3TDisAir.u);
  connect(firOrd.y, reaToBooOcc.u)
    annotation (Line(points={{-69,100},{-62,100}}, color={0,0,127}));
  connect(firOrd.u, Occ)
    annotation (Line(points={{-92,100},{-114,100}}, color={0,0,127}));

  connect(reaToBooOcc.y, booRep.u)
    annotation (Line(points={{-39,100},{-32,100}}, color={255,0,255}));


  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}),                                        graphics={
          Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={28,108,200},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),
    Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-20},{200,120}}), graphics={
          Text(
          extent={{130,108},{180,94}},
          lineColor={0,0,0},
          fontSize=10,
          textStyle={TextStyle.Bold},
          textString="Airside")}),
    experiment(
      StartTime=14515200,
      StopTime=14860800,
      __Dymola_NumberOfIntervals=1440,
      __Dymola_Algorithm="Cvode"));
end AirSide;
