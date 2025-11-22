model Point2
  Modelica.Blocks.Math.Gain fb(k = -1) annotation(
    Placement(visible = true, transformation(origin = {98, -64}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain beta1(k = 0.66) annotation(
    Placement(visible = true, transformation(origin = {-72, 60}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Continuous.TransferFunction g1(a = {10, 1}, b = {1}) annotation(
    Placement(visible = true, transformation(origin = {26, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain beta2(k = 0.33) annotation(
    Placement(visible = true, transformation(origin = {-32, 60}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Math.Feedback Pbal annotation(
    Placement(visible = true, transformation(origin = {146, -10}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain Pn1(k = 100) annotation(
    Placement(visible = true, transformation(origin = {66, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add as2 annotation(
    Placement(visible = true, transformation(origin = {-12, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain Pn2(k = 50) annotation(
    Placement(visible = true, transformation(origin = {66, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.TransferFunction g2(a = {5, 1}, b = {1}) annotation(
    Placement(visible = true, transformation(origin = {26, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator N(k = 1/2960.88) annotation(
    Placement(visible = true, transformation(origin = {188, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator Cs(k = 0.016) annotation(
    Placement(visible = true, transformation(origin = {-114, 86}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.TransferFunction Cp1(a = {1}, b = {133*10/1250}) annotation(
    Placement(visible = true, transformation(origin = {-116, 4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add Ptot annotation(
    Placement(visible = true, transformation(origin = {106, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.TransferFunction Cp2(a = {1}, b = {677327/100000/10}) annotation(
    Placement(visible = true, transformation(origin = {-114, -36}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add as1 annotation(
    Placement(visible = true, transformation(origin = {-50, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Ramp dPe(duration = 10, height = 5) annotation(
    Placement(visible = true, transformation(origin = {106, 46}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(Cs.y, beta1.u) annotation(
    Line(points = {{-103, 86}, {-73, 86}, {-73, 72}}, color = {0, 0, 127}));
  connect(Pn1.y, Ptot.u1) annotation(
    Line(points = {{77, 10}, {85, 10}, {85, -4}, {93, -4}}, color = {0, 0, 127}));
  connect(Pn2.y, Ptot.u2) annotation(
    Line(points = {{77, -30}, {85, -30}, {85, -16}, {93, -16}}, color = {0, 0, 127}));
  connect(beta2.y, as2.u1) annotation(
    Line(points = {{-32, 49}, {-32, -24}, {-24, -24}}, color = {0, 0, 127}));
  connect(fb.y, Cp2.u) annotation(
    Line(points = {{87, -64}, {-137, -64}, {-137, -36}, {-126, -36}}, color = {0, 0, 127}));
  connect(Pbal.y, N.u) annotation(
    Line(points = {{155, -10}, {176, -10}}, color = {0, 0, 127}));
  connect(g1.y, Pn1.u) annotation(
    Line(points = {{37, 10}, {53, 10}}, color = {0, 0, 127}));
  connect(as1.y, g1.u) annotation(
    Line(points = {{-39, 10}, {13, 10}}, color = {0, 0, 127}));
  connect(beta1.y, as1.u1) annotation(
    Line(points = {{-72, 49}, {-72, 16}, {-62, 16}}, color = {0, 0, 127}));
  connect(Cs.y, beta2.u) annotation(
    Line(points = {{-103, 86}, {-33, 86}, {-33, 72}}, color = {0, 0, 127}));
  connect(Cp2.u, Cp1.u) annotation(
    Line(points = {{-126, -36}, {-138, -36}, {-138, 4}, {-128, 4}}, color = {0, 0, 127}));
  connect(as2.y, g2.u) annotation(
    Line(points = {{-1, -30}, {14, -30}}, color = {0, 0, 127}));
  connect(g2.y, Pn2.u) annotation(
    Line(points = {{37, -30}, {53, -30}}, color = {0, 0, 127}));
  connect(Cp2.y, as2.u2) annotation(
    Line(points = {{-103, -36}, {-24, -36}}, color = {0, 0, 127}));
  connect(Cp1.y, as1.u2) annotation(
    Line(points = {{-105, 4}, {-62, 4}}, color = {0, 0, 127}));
  connect(Cp1.u, Cs.u) annotation(
    Line(points = {{-128, 4}, {-138, 4}, {-138, 86}, {-126, 86}}, color = {0, 0, 127}));
  connect(N.y, fb.u) annotation(
    Line(points = {{199, -10}, {212, -10}, {212, -64}, {110, -64}}, color = {0, 0, 127}));
  connect(Ptot.y, Pbal.u1) annotation(
    Line(points = {{118, -10}, {138, -10}}, color = {0, 0, 127}));
  connect(dPe.y, Pbal.u2) annotation(
    Line(points = {{118, 46}, {146, 46}, {146, -2}}, color = {0, 0, 127}));
  annotation(
    uses(Modelica(version = "4.0.0")),
  Diagram(coordinateSystem(extent = {{-140, -80}, {220, 100}}, initialScale = 0.1)),
    version = "",
  Icon(coordinateSystem(extent = {{-140, -80}, {220, 100}}, initialScale = 0.1)));end Point2;
