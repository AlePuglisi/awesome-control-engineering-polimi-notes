model Islanded_pt1
  Modelica.Blocks.Continuous.Integrator N(k = 1/6.573) annotation(
    Placement(visible = true, transformation(origin = {70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.TransferFunction Cps(a = {1.67, 1, 0}, b = 2*{9.56, 0.6883, 0.01052}) annotation(
    Placement(visible = true, transformation(origin = {-70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Ramp dPe(duration = 10, height = 5/150) annotation(
    Placement(visible = true, transformation(origin = {-10, 38}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.TransferFunction g(a = {20, 1}, b = {1}) annotation(
    Placement(visible = true, transformation(origin = {-10, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain fb(k = -1) annotation(
    Placement(visible = true, transformation(origin = {-10, -30}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback Pbal annotation(
    Placement(visible = true, transformation(origin = {30, 0}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
equation
  connect(Cps.y, g.u) annotation(
    Line(points = {{-58, 0}, {-22, 0}}, color = {0, 0, 127}));
  connect(dPe.y, Pbal.u2) annotation(
    Line(points = {{1, 38}, {30, 38}, {30, 8}}, color = {0, 0, 127}));
  connect(fb.y, Cps.u) annotation(
    Line(points = {{-20, -30}, {-100, -30}, {-100, 0}, {-82, 0}}, color = {0, 0, 127}));
  connect(Pbal.y, N.u) annotation(
    Line(points = {{40, 0}, {58, 0}}, color = {0, 0, 127}));
  connect(N.y, fb.u) annotation(
    Line(points = {{82, 0}, {100, 0}, {100, -30}, {2, -30}}, color = {0, 0, 127}));
  connect(g.y, Pbal.u1) annotation(
    Line(points = {{2, 0}, {22, 0}}, color = {0, 0, 127}));
  annotation(
    uses(Modelica(version = "4.0.0")));end Islanded_pt1;
