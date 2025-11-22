model ProvaPunto2
  Modelica.Blocks.Math.Gain beta1(k = 0.66) annotation(
    Placement(visible = true, transformation(origin = {-84, 64}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Continuous.TransferFunction g2(a = {5, 1}, b = {1}) annotation(
    Placement(visible = true, transformation(origin = {30, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add Ptot annotation(
    Placement(visible = true, transformation(origin = {106, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.TransferFunction Cp1(a = {1}, b = {133*10/1250}) annotation(
    Placement(visible = true, transformation(origin = {-108, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.TransferFunction Cp2(a = {1}, b = {677327/100000/10}) annotation(
    Placement(visible = true, transformation(origin = {-114, -78}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain beta2(k = 0.33) annotation(
    Placement(visible = true, transformation(origin = {-42, 62}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Math.Feedback Pbal annotation(
    Placement(visible = true, transformation(origin = {154, -10}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator Cs(k = 0.016) annotation(
    Placement(visible = true, transformation(origin = {-128, 84}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain Pn1(k = 100) annotation(
    Placement(visible = true, transformation(origin = {68, 14}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator N(k = 1/2960.88) annotation(
    Placement(visible = true, transformation(origin = {184, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain Pn2(k = 50) annotation(
    Placement(visible = true, transformation(origin = {66, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.TransferFunction g1(a = {10, 1}, b = {1}) annotation(
    Placement(visible = true, transformation(origin = {26, 14}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.CombiTimeTable Pe(columns = {2}, extrapolation = Modelica.Blocks.Types.Extrapolation.HoldLastPoint, offset = {0}, smoothness = Modelica.Blocks.Types.Smoothness.ConstantSegments, table = [0, 60; 1800, 70; 3600, 120; 7200, 110; 9000, 60], tableOnFile = false, verboseRead = false) annotation(
    Placement(visible = true, transformation(origin = {132, 38}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add3 add3 annotation(
    Placement(visible = true, transformation(origin = {-72, 14}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add3 add31 annotation(
    Placement(visible = true, transformation(origin = {-16, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain fb(k = -1) annotation(
    Placement(visible = true, transformation(origin = {58, -96}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.CombiTimeTable Bias1(columns = {2}, extrapolation = Modelica.Blocks.Types.Extrapolation.HoldLastPoint, offset = {0}, smoothness = Modelica.Blocks.Types.Smoothness.ConstantSegments, table = [0, 0.6; 1800, 0.7; 3600, 0.8; 7200, 0.73; 9000, 0.6], tableOnFile = false, verboseRead = false) annotation(
    Placement(visible = true, transformation(origin = {-166, 14}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.CombiTimeTable Bias2(columns = {2}, extrapolation = Modelica.Blocks.Types.Extrapolation.HoldLastPoint, offset = {0}, smoothness = Modelica.Blocks.Types.Smoothness.ConstantSegments, table = [0, 0; 1800, 0; 3600, 0.81; 7200, 0.74; 9000, 0], tableOnFile = false, verboseRead = false) annotation(
    Placement(visible = true, transformation(origin = {-164, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(Pn2.y, Ptot.u2) annotation(
    Line(points = {{77, -30}, {85, -30}, {85, -16}, {93, -16}}, color = {0, 0, 127}));
  connect(g2.y, Pn2.u) annotation(
    Line(points = {{41, -50}, {46, -50}, {46, -30}, {53, -30}}, color = {0, 0, 127}));
  connect(Ptot.y, Pbal.u1) annotation(
    Line(points = {{118, -10}, {146, -10}}, color = {0, 0, 127}));
  connect(Pbal.y, N.u) annotation(
    Line(points = {{163, -10}, {172, -10}}, color = {0, 0, 127}));
  connect(Cp2.u, Cp1.u) annotation(
    Line(points = {{-126, -78}, {-144, -78}, {-144, -30}, {-120, -30}}, color = {0, 0, 127}));
  connect(g1.y, Pn1.u) annotation(
    Line(points = {{37, 14}, {56, 14}}, color = {0, 0, 127}));
  connect(Cs.y, beta1.u) annotation(
    Line(points = {{-117, 84}, {-84, 84}, {-84, 76}}, color = {0, 0, 127}));
  connect(Pn1.y, Ptot.u1) annotation(
    Line(points = {{79, 14}, {85, 14}, {85, -4}, {93, -4}}, color = {0, 0, 127}));
  connect(Cs.y, beta2.u) annotation(
    Line(points = {{-117, 84}, {-42, 84}, {-42, 74}}, color = {0, 0, 127}));
  connect(Cp1.y, add3.u3) annotation(
    Line(points = {{-97, -30}, {-92, -30}, {-92, 4.875}, {-84, 4.875}, {-84, 6}}, color = {0, 0, 127}));
  connect(add31.u3, Cp2.y) annotation(
    Line(points = {{-28, -58}, {-63.5, -58}, {-63.5, -78}, {-103, -78}}, color = {0, 0, 127}));
  connect(g2.u, add31.y) annotation(
    Line(points = {{18, -50}, {-5, -50}}, color = {0, 0, 127}));
  connect(g1.u, add3.y) annotation(
    Line(points = {{14, 14}, {-61, 14}}, color = {0, 0, 127}));
  connect(N.y, fb.u) annotation(
    Line(points = {{195, -10}, {210, -10}, {210, -96}, {70, -96}}, color = {0, 0, 127}));
  connect(fb.y, Cp2.u) annotation(
    Line(points = {{47, -96}, {-144, -96}, {-144, -78}, {-126, -78}}, color = {0, 0, 127}));
  connect(Pe.y[1], Pbal.u2) annotation(
    Line(points = {{143, 38}, {154, 38}, {154, -2}}, color = {0, 0, 127}));
  connect(beta2.y, add31.u1) annotation(
    Line(points = {{-42, 51}, {-42, -42}, {-28, -42}}, color = {0, 0, 127}));
  connect(Bias2.y[1], add31.u2) annotation(
    Line(points = {{-153, -50}, {-28, -50}}, color = {0, 0, 127}));
  connect(Bias1.y[1], add3.u2) annotation(
    Line(points = {{-155, 14}, {-84, 14}}, color = {0, 0, 127}));
  connect(beta1.y, add3.u1) annotation(
    Line(points = {{-84, 53}, {-84, 22}}, color = {0, 0, 127}));
  connect(Cs.u, Cp1.u) annotation(
    Line(points = {{-140, 84}, {-144, 84}, {-144, -30}, {-120, -30}}, color = {0, 0, 127}));
  annotation(
    Diagram(coordinateSystem(extent = {{-130, -100}, {100, 100}})),
    uses(Modelica(version = "4.0.0")));
end ProvaPunto2;
