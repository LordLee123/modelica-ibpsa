within Annex60.Experimental.Pipe.Examples.UseCaseAachen.Components;
model PipeA60 "Wrapper around A60 pipe model"
  extends Annex60.Fluid.Interfaces.PartialTwoPort_vector;

  replaceable package Medium =
      Modelica.Media.Interfaces.PartialMedium "Medium in the component"
      annotation (choicesAllMatching = true);

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal
    "Nominal mass flow rate" annotation (Dialog(group="Nominal condition"));

  parameter Modelica.SIunits.MassFlowRate m_flow_small(min=0) = 1E-4*abs(
    m_flow_nominal) "Small mass flow rate for regularization of zero flow"
    annotation (Dialog(tab="Advanced"));

  parameter Modelica.SIunits.Height roughness=2.5e-5
    "Average height of surface asperities (default: smooth steel pipe)"
    annotation (Dialog(group="Geometry"));


  final parameter Modelica.SIunits.Pressure dpStraightPipe_nominal=
      Modelica.Fluid.Pipes.BaseClasses.WallFriction.Detailed.pressureLoss_m_flow(
      m_flow=m_flow_nominal,
      rho_a=rho_default,
      rho_b=rho_default,
      mu_a=mu_default,
      mu_b=mu_default,
      length=length,
      diameter=diameter,
      roughness=roughness,
      m_flow_small=m_flow_small)
    "Pressure loss of a straight pipe at m_flow_nominal";

  parameter Modelica.SIunits.Length length "Length of the pipe";

  parameter Modelica.SIunits.Diameter diameter "Diameter of the pipe";

  parameter Modelica.SIunits.Length thicknessIns "Thickness of pipe insulation";

  parameter Modelica.SIunits.ThermalConductivity lambdaIns
    "Thermal conductivity of pipe insulation";

  parameter Modelica.SIunits.Temperature T_amb = 283.15
    "Ambient temperature around pipe";

protected
  parameter Medium.ThermodynamicState sta_default=Medium.setState_pTX(
      T=Medium.T_default,
      p=Medium.p_default,
      X=Medium.X_default) "Default medium state";

  parameter Modelica.SIunits.Density rho_default=Medium.density_pTX(
      p=Medium.p_default,
      T=Medium.T_default,
      X=Medium.X_default)
    "Default density (e.g., rho_liquidWater = 995, rho_air = 1.2)"
    annotation (Dialog(group="Advanced", enable=use_rho_nominal));

  parameter Modelica.SIunits.DynamicViscosity mu_default=
      Medium.dynamicViscosity(Medium.setState_pTX(
      p=Medium.p_default,
      T=Medium.T_default,
      X=Medium.X_default))
    "Default dynamic viscosity (e.g., mu_liquidWater = 1e-3, mu_air = 1.8e-5)"
    annotation (Dialog(group="Advanced", enable=use_mu_default));

public
  Annex60.Fluid.Sensors.TemperatureTwoPort senTem_a(redeclare package Medium =
        Medium, m_flow_nominal=m_flow_nominal,
    T_start=333.15)                            "Temperature at pipe's port a"
    annotation (Placement(transformation(extent={{-86,-10},{-66,10}})));
  PipeHeatLossMod pipe(
  redeclare package Medium = Medium,
  diameter=diameter,
  length=length,
  thicknessIns=thicknessIns,
  m_flow_nominal=m_flow_nominal,
  m_flow_small=m_flow_small,
  roughness=roughness,
  lambdaI=lambdaIns,
  from_dp=true,
    nPorts=nPorts,
    T_ini_in=333.15,
    T_ini_out=333.15,
    initDelay=true,
    m_flowInit=0.45)
  "Pipe model for district heating connection"
  annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=283.15)
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
equation

  connect(port_a, senTem_a.port_a)
    annotation (Line(points={{-100,0},{-94,0},{-86,0}}, color={0,127,255}));
connect(senTem_a.port_b, pipe.port_a)
  annotation (Line(points={{-66,0},{-10,0}},         color={0,127,255}));
connect(fixedTemperature.port, pipe.heatPort)
  annotation (Line(points={{-20,50},{0,50},{0,10}},   color={191,0,0}));
  connect(pipe.ports_b[:], ports_b[:])
    annotation (Line(points={{10,0},{10,0},{100,0}},color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={Rectangle(
          extent={{-90,24},{90,-26}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid)}), Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
  Documentation(revisions="<html>
<ul>
<li>December 12, 2016 by Marcus Fuchs:<br>First implementation. </li>
</ul>
</html>"));
end PipeA60;
