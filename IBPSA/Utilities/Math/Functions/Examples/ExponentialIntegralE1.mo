within IBPSA.Utilities.Math.Functions.Examples;
model ExponentialIntegralE1
  "Test case for the exponential integral, E1"
  extends Modelica.Icons.Example;

  Real E1 "Exponential integral E1";

equation

  E1 = IBPSA.Utilities.Math.Functions.exponentialIntegralE1(time + Modelica.Constants.small);

  annotation (
    __Dymola_Commands(file=
          "modelica://IBPSA/Resources/Scripts/Dymola/Utilities/Math/Functions/Examples/ExponentialIntegralE1.mos"
        "Simulate and plot"),
    experiment(Tolerance=1e-6, StopTime=3.0),
    Documentation(info="<html>
<p>
This example demonstrates the use of the function for the exponential integral,
E1.
</p>
</html>", revisions="<html>
<ul>
<li>
June 6, 2018, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end ExponentialIntegralE1;
