model Point_3noopt
  Modelica.Blocks.Continuous.TransferFunction Cp1(a = {1}, b = {1788*10/34375}) annotation(
    Placement(visible = true, transformation(origin = {-148, -28}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.TransferFunction g2(a = {5, 1}, b = {1}) annotation(
    Placement(visible = true, transformation(origin = {-8, -56}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain Pn2(k = 50) annotation(
    Placement(visible = true, transformation(origin = {30, -56}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.TransferFunction g1(a = {10, 1}, b = {1}) annotation(
    Placement(visible = true, transformation(origin = {-18, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator Cs(k = 1777/137500) annotation(
    Placement(visible = true, transformation(origin = {-148, 84}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator N(k = 1/3947.8) annotation(
    Placement(visible = true, transformation(origin = {176, -48}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain fb(k = -1) annotation(
    Placement(visible = true, transformation(origin = {58, -92}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain beta1(k = 2/5) annotation(
    Placement(visible = true, transformation(origin = {-112, 50}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Math.Gain Pn1(k = 100) annotation(
    Placement(visible = true, transformation(origin = {36, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain beta2(k = 1/5) annotation(
    Placement(visible = true, transformation(origin = {-72, 50}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Math.Feedback Pbal annotation(
    Placement(visible = true, transformation(origin = {134, -48}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Continuous.TransferFunction Cp2(a = {1}, b = {1396*10/103125}) annotation(
    Placement(visible = true, transformation(origin = {-154, -76}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain beta3(k = 2/5) annotation(
    Placement(visible = true, transformation(origin = {-26, 50}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Continuous.TransferFunction g3(a = {20, 1}, b = {1}) annotation(
    Placement(visible = true, transformation(origin = {36, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain Pn3(k = 150) annotation(
    Placement(visible = true, transformation(origin = {80, 8}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Math.Add3 Ptot annotation(
    Placement(visible = true, transformation(origin = {92, -48}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.TransferFunction Cp3(a = {1}, b = {184012/61875/5}) annotation(
    Placement(visible = true, transformation(origin = {-144, 12}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add2 annotation(
    Placement(visible = true, transformation(origin = {-54, -56}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add1 annotation(
    Placement(visible = true, transformation(origin = {-92, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add3 annotation(
    Placement(visible = true, transformation(origin = {-6, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Ramp dPe(duration = 10, height = 5) annotation(
    Placement(visible = true, transformation(origin = {108, 48}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(Cs.y, beta2.u) annotation(
    Line(points = {{-137, 84}, {-73, 84}, {-73, 62}}, color = {0, 0, 127}));
  connect(N.y, fb.u) annotation(
    Line(points = {{187, -48}, {187, -92}, {70, -92}}, color = {0, 0, 127}));
  connect(Pbal.y, N.u) annotation(
    Line(points = {{143, -48}, {164, -48}}, color = {0, 0, 127}));
  connect(g2.y, Pn2.u) annotation(
    Line(points = {{3, -56}, {18, -56}}, color = {0, 0, 127}));
  connect(Cs.y, beta1.u) annotation(
    Line(points = {{-137, 84}, {-113, 84}, {-113, 62}}, color = {0, 0, 127}));
  connect(g1.y, Pn1.u) annotation(
    Line(points = {{-7, -20}, {24, -20}}, color = {0, 0, 127}));
  connect(beta3.u, Cs.y) annotation(
    Line(points = {{-26, 62}, {-26, 84}, {-137, 84}}, color = {0, 0, 127}));
  connect(Pn3.u, g3.y) annotation(
    Line(points = {{80, 20}, {47, 20}}, color = {0, 0, 127}));
  connect(Pn2.y, Ptot.u3) annotation(
    Line(points = {{41, -56}, {80, -56}}, color = {0, 0, 127}));
  connect(Pn3.y, Ptot.u1) annotation(
    Line(points = {{80, -3}, {80, -40}}, color = {0, 0, 127}));
  connect(Pn1.y, Ptot.u2) annotation(
    Line(points = {{47, -20}, {44, -20}, {44, -48}, {80, -48}}, color = {0, 0, 127}));
  connect(Ptot.y, Pbal.u1) annotation(
    Line(points = {{103, -48}, {126, -48}}, color = {0, 0, 127}));
  connect(Cp2.u, fb.y) annotation(
    Line(points = {{-166, -76}, {-184, -76}, {-184, -92}, {47, -92}}, color = {0, 0, 127}));
  connect(Cp1.u, fb.y) annotation(
    Line(points = {{-160, -28}, {-184, -28}, {-184, -92}, {47, -92}}, color = {0, 0, 127}));
  connect(Cp3.u, fb.y) annotation(
    Line(points = {{-156, 12}, {-184, 12}, {-184, -92}, {47, -92}}, color = {0, 0, 127}));
  connect(Cs.u, fb.y) annotation(
    Line(points = {{-160, 84}, {-184, 84}, {-184, -92}, {47, -92}}, color = {0, 0, 127}));
  connect(add2.y, g2.u) annotation(
    Line(points = {{-43, -56}, {-20, -56}}, color = {0, 0, 127}));
  connect(Cp2.y, add2.u2) annotation(
    Line(points = {{-142, -76}, {-84, -76}, {-84, -62}, {-66, -62}}, color = {0, 0, 127}));
  connect(beta2.y, add2.u1) annotation(
    Line(points = {{-72, 40}, {-72, -50}, {-66, -50}}, color = {0, 0, 127}));
  connect(add1.y, g1.u) annotation(
    Line(points = {{-80, -20}, {-30, -20}}, color = {0, 0, 127}));
  connect(beta1.y, add1.u1) annotation(
    Line(points = {{-112, 40}, {-112, -14}, {-104, -14}}, color = {0, 0, 127}));
  connect(Cp1.y, add1.u2) annotation(
    Line(points = {{-136, -28}, {-112, -28}, {-112, -26}, {-104, -26}}, color = {0, 0, 127}));
  connect(add3.y, g3.u) annotation(
    Line(points = {{6, 20}, {24, 20}}, color = {0, 0, 127}));
  connect(beta3.y, add3.u1) annotation(
    Line(points = {{-26, 40}, {-26, 26}, {-18, 26}}, color = {0, 0, 127}));
  connect(Cp3.y, add3.u2) annotation(
    Line(points = {{-132, 12}, {-26, 12}, {-26, 14}, {-18, 14}}, color = {0, 0, 127}));
  connect(dPe.y, Pbal.u2) annotation(
    Line(points = {{119, 48}, {134, 48}, {134, -40}}, color = {0, 0, 127}));
  annotation(
    Diagram(coordinateSystem(extent = {{-180, 100}, {180, -100}})),
    uses(Modelica(version = "4.0.0")),
  version = "");
end Point_3noopt;
