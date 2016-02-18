within Annex60.Fluid.Movers.BaseClasses;
partial model FlowControlled
  "Partial model for fan or pump with ideally controlled mass flow rate or head as input signal"
  extends Annex60.Fluid.Movers.BaseClasses.PartialFlowMachine(
   heaDis(final motorCooledByFluid = per.motorCooledByFluid,
          final delta_V_flow = 1E-3*V_flow_max),
   preSou(final control_m_flow=control_m_flow));

  import cha = Annex60.Fluid.Movers.BaseClasses.Characteristics;

  // Quantity to control
  constant Boolean control_m_flow "= false to control head instead of m_flow";

  replaceable parameter Data.FlowControlled per
    constrainedby Data.FlowControlled "Record with performance data"
    annotation (choicesAllMatching=true,
      Placement(transformation(extent={{60,60},{80,80}})));

  Modelica.SIunits.VolumeFlowRate VMachine_flow = eff.V_flow "Volume flow rate";
  Modelica.SIunits.PressureDifference dpMachine(displayUnit="Pa")=
      -eff.dp "Pressure difference";

protected
  final parameter Medium.AbsolutePressure p_a_default(displayUnit="Pa") = Medium.p_default
    "Nominal inlet pressure for predefined fan or pump characteristics";

  parameter Modelica.SIunits.VolumeFlowRate V_flow_max=m_flow_nominal/rho_default
    "Maximum volume flow rate";

  parameter Medium.ThermodynamicState sta_default = Medium.setState_pTX(
     T=Medium.T_default,
     p=Medium.p_default,
     X=Medium.X_default[1:Medium.nXi]) "Default medium state";

  Modelica.Blocks.Continuous.Filter filter(
     order=2,
     f_cut=5/(2*Modelica.Constants.pi*riseTime),
     final init=init,
     x(each stateSelect=StateSelect.always),
     final analogFilter=Modelica.Blocks.Types.AnalogFilter.CriticalDamping,
     final filterType=Modelica.Blocks.Types.FilterType.LowPass) if
        filteredSpeed
    "Second order filter to approximate valve opening time, and to improve numerics"
    annotation (Placement(transformation(extent={{20,81},{34,95}})));

  Annex60.Fluid.Movers.BaseClasses.EfficiencyInterface eff(
    per(
      final hydraulicEfficiency = per.hydraulicEfficiency,
      final motorEfficiency =     per.motorEfficiency,
      final motorCooledByFluid =  per.motorCooledByFluid))
    "Flow machine interface"
    annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));
equation
  connect(eff.rho, rho_inlet.y) annotation (Line(points={{-22,-50},{-30,-50},{-30,
          -50},{-49,-50}},      color={0,0,127}));
  connect(senMasFlo.m_flow, eff.m_flow) annotation (Line(points={{-60,-11},{-60,
          -26},{-40,-26},{-40,-56},{-22,-56},{-22,-56}},         color={0,0,127}));
  connect(eff.eta, heaDis.eta) annotation (Line(points={{1,-50},{20,-50},{20,
          -40},{38,-40}}, color={0,0,127}));
  connect(heaDis.etaHyd, eff.etaHyd) annotation (Line(points={{38,-43},{32,
          -43},{32,-42},{22,-42},{22,-54.2},{1,-54.2}}, color={0,0,127}));
  connect(heaDis.etaMot, eff.etaMot) annotation (Line(points={{38,-46},{24,
          -46},{24,-58},{1,-58}}, color={0,0,127}));
  connect(heaDis.V_flow, eff.V_flow) annotation (Line(points={{38,-52},{10,
          -52},{10,-40},{6,-40},{6,-41},{1,-41}}, color={0,0,127}));
  connect(heaDis.WFlo, eff.WFlo) annotation (Line(points={{38,-56},{8,-56},{
          8,-44},{1,-44}}, color={0,0,127}));
  connect(heaDis.PEle, eff.PEle) annotation (Line(points={{38,-60},{24,-60},
          {6,-60},{6,-47},{1,-47}}, color={0,0,127}));
  connect(eff.WFlo, PToMedium_flow.u2) annotation (Line(points={{1,-44},{8,-44},
          {8,-88},{38,-88}}, color={0,0,127}));
  annotation (defaultComponentName="fan",
    Documentation(info="<html>
<p>
Partial model for a fan or pump that takes as an input
the head or the mass flow rate.
</p>
</html>",
      revisions="<html>
<ul>
<li>
February 19, 2016, by Michael Wetter:<br/>
Refactored model to make implementation clearer.
This is for
<a href=\"https://github.com/iea-annex60/modelica-annex60/issues/417\">#417</a>.
</li>
<li>
September 2, 2015, by Michael Wetter:<br/>
Changed assignments of parameters of record <code>_perPow</code> to be <code>final</code>
as we want users to change the performance record and not the low level declaration.
</li>      
<li>
January 6, 2015, by Michael Wetter:<br/>
Revised model for OpenModelica.
</li>
<li>
April 19, 2014, by Filip Jorissen:<br/>
Set default values for new parameters in <code>efficiency()</code>.
</li>
<li>
October 8, 2013, by Michael Wetter:<br/>
Removed parameter <code>show_V_flow</code>.
</li>
<li>
September 13, 2013 by Michael Wetter:<br/>
Corrected computation of <code>sta_default</code> to use medium default
values instead of medium start values.
</li>
<li>
December 14, 2012 by Michael Wetter:<br/>
Renamed protected parameters for consistency with the naming conventions.
</li>
<li>
October 11, 2012, by Michael Wetter:<br/>
Added implementation of <code>WFlo = eta * P</code> with
guard against division by zero.
</li>
<li>
May 25, 2011, by Michael Wetter:<br/>
Revised implementation of energy balance to avoid having to use conditionally removed models.
</li>
<li>
November 11, 2010, by Michael Wetter:<br/>
Changed <code>V_flow_max=m_flow_nominal/rho_nominal;</code> to <code>V_flow_max=m_flow_max/rho_nominal;</code>
</li>
<li>
July 27, 2010, by Michael Wetter:<br/>
Redesigned model to fix bug in medium balance.
</li>
<li>
March 24, 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})));
end FlowControlled;
