model Configurationchngtest2
  Modelica.Blocks.Math.Gain beta1A(k = 0.66) annotation(
    Placement(visible = true, transformation(origin = {-138, 26}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Math.Gain fb12(k = -1) annotation(
    Placement(visible = true, transformation(origin = {44, -150}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain beta2A(k = 0.33) annotation(
    Placement(visible = true, transformation(origin = {-54, 24}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Math.Gain Pn1(k = 100) annotation(
    Placement(visible = true, transformation(origin = {62, -52}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add Ptot annotation(
    Placement(visible = true, transformation(origin = {102, -72}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.TransferFunction g1(a = {10, 1}, b = {1}) annotation(
    Placement(visible = true, transformation(origin = {28, -52}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator CsA(k = 0.016) annotation(
    Placement(visible = true, transformation(origin = {-220, 12}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.TransferFunction Cp1A(a = {1}, b = {133*10/1250}) annotation(
    Placement(visible = true, transformation(origin = {-172, -58}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.TransferFunction Cp2A(a = {1}, b = {677327/100000/10}) annotation(
    Placement(visible = true, transformation(origin = {-172, -138}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain Pn2(k = 50) annotation(
    Placement(visible = true, transformation(origin = {62, -92}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add as2 annotation(
    Placement(visible = true, transformation(origin = {-12, -92}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add as1 annotation(
    Placement(visible = true, transformation(origin = {-54, -52}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback Pbal annotation(
    Placement(visible = true, transformation(origin = {142, -72}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Continuous.TransferFunction g2(a = {5, 1}, b = {1}) annotation(
    Placement(visible = true, transformation(origin = {28, -92}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanExpression Bconfig(y = if (time < 100 or time > 500) then false else true)  "True when we are on config B, otherwise A" annotation(
    Placement(visible = true, transformation(origin = {-388, 44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch1 annotation(
    Placement(visible = true, transformation(origin = {-134, -34}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Modelica.Blocks.Math.Gain fb3(k = -1) annotation(
    Placement(visible = true, transformation(origin = {-90, 122}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.TransferFunction Cp3A(a = {1.67, 1, 0}, b = 2*{9.56, 0.6883, 0.01052}) annotation(
    Placement(visible = true, transformation(origin = {-240, 194}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.TransferFunction g3(a = {20, 1}, b = {1}) annotation(
    Placement(visible = true, transformation(origin = {-68, 162}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator N_IsA(k = 1/6.573) annotation(
    Placement(visible = true, transformation(origin = {88, 162}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch2 annotation(
    Placement(visible = true, transformation(origin = {274, -42}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator N_NetA(k = 1/2960.88) annotation(
    Placement(visible = true, transformation(origin = {176, -72}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain Pn3(k = 150) annotation(
    Placement(visible = true, transformation(origin = {-18, 162}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.TransferFunction Cp1B(a = {1}, b = {1788*10/34375}) annotation(
    Placement(visible = true, transformation(origin = {-174, -16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.TransferFunction Cp2B(a = {1}, b = {1396*10/103125}) annotation(
    Placement(visible = true, transformation(origin = {-172, -98}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch4 annotation(
    Placement(visible = true, transformation(origin = {-134, -114}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator CsB(k = 1777/137500) annotation(
    Placement(visible = true, transformation(origin = {-222, 66}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch5 annotation(
    Placement(visible = true, transformation(origin = {-160, 58}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Modelica.Blocks.Continuous.TransferFunction Cp3B(a = {1}, b = {184012/61875/5}) annotation(
    Placement(visible = true, transformation(origin = {-262, 150}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add annotation(
    Placement(visible = true, transformation(origin = {-226, 144}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch6 annotation(
    Placement(visible = true, transformation(origin = {-174, 182}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Modelica.Blocks.Math.Gain beta1B(k = 2/5) annotation(
    Placement(visible = true, transformation(origin = {-102, 24}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Logical.Switch switch7 annotation(
    Placement(visible = true, transformation(origin = {-88, -12}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Modelica.Blocks.Math.Gain beta2B(k = 1/5) annotation(
    Placement(visible = true, transformation(origin = {-4, 26}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Logical.Switch switch8 annotation(
    Placement(visible = true, transformation(origin = {-14, -20}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Modelica.Blocks.Math.Gain beta3B(k = 2/5) annotation(
    Placement(visible = true, transformation(origin = {-260, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Math.Feedback feedback1 annotation(
    Placement(visible = true, transformation(origin = {40, 162}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpression(y = 0) annotation(
    Placement(visible = true, transformation(origin = {54, 92}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpression1(y = 0) annotation(
    Placement(visible = true, transformation(origin = {-378, 200}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch11 annotation(
    Placement(visible = true, transformation(origin = {-296, 156}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch12 annotation(
    Placement(visible = true, transformation(origin = {-316, 194}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch14 annotation(
    Placement(visible = true, transformation(origin = {-304, -14}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch16 annotation(
    Placement(visible = true, transformation(origin = {-306, -98}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression DPe3(y = if (time < 100 or time > 500) then 50 else 60) annotation(
    Placement(visible = true, transformation(origin = {-4, 208}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression DPe12(y = if (time < 100 or time > 500) then 100 else 160) annotation(
    Placement(visible = true, transformation(origin = {98, -28}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch13 annotation(
    Placement(visible = true, transformation(origin = {186, 150}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
equation
  connect(Ptot.y, Pbal.u1) annotation(
    Line(points = {{113, -72}, {133, -72}}, color = {0, 0, 127}));
  connect(as2.y, g2.u) annotation(
    Line(points = {{-1, -92}, {16, -92}}, color = {0, 0, 127}));
  connect(g2.y, Pn2.u) annotation(
    Line(points = {{39, -92}, {49, -92}}, color = {0, 0, 127}));
  connect(Pn1.y, Ptot.u1) annotation(
    Line(points = {{73, -52}, {81, -52}, {81, -66}, {89, -66}}, color = {0, 0, 127}));
  connect(Pn2.y, Ptot.u2) annotation(
    Line(points = {{73, -92}, {81, -92}, {81, -78}, {89, -78}}, color = {0, 0, 127}));
  connect(as1.y, g1.u) annotation(
    Line(points = {{-43, -52}, {16, -52}}, color = {0, 0, 127}));
  connect(g1.y, Pn1.u) annotation(
    Line(points = {{39, -52}, {49, -52}}, color = {0, 0, 127}));
  connect(switch2.y, fb12.u) annotation(
    Line(points = {{282, -42}, {292, -42}, {292, -150}, {56, -150}}, color = {0, 0, 127}));
  connect(switch2.u2, Bconfig.y) annotation(
    Line(points = {{264, -42}, {208, -42}, {208, -40}, {156, -40}, {156, 44}, {-376, 44}}, color = {255, 0, 255}));
  connect(g3.y, Pn3.u) annotation(
    Line(points = {{-57, 162}, {-31, 162}}, color = {0, 0, 127}));
  connect(Cp1B.y, switch1.u1) annotation(
    Line(points = {{-162, -16}, {-152, -16}, {-152, -28}, {-144, -28}}, color = {0, 0, 127}));
  connect(Cp1A.y, switch1.u3) annotation(
    Line(points = {{-160, -58}, {-152, -58}, {-152, -40}, {-144, -40}}, color = {0, 0, 127}));
  connect(switch1.y, as1.u2) annotation(
    Line(points = {{-126, -34}, {-90, -34}, {-90, -58}, {-66, -58}}, color = {0, 0, 127}));
  connect(Cp2B.y, switch4.u1) annotation(
    Line(points = {{-160, -98}, {-152, -98}, {-152, -108}, {-144, -108}}, color = {0, 0, 127}));
  connect(Cp2A.y, switch4.u3) annotation(
    Line(points = {{-160, -138}, {-152, -138}, {-152, -122}, {-144, -122}, {-144, -120}}, color = {0, 0, 127}));
  connect(switch4.y, as2.u2) annotation(
    Line(points = {{-126, -114}, {-38, -114}, {-38, -98}, {-24, -98}}, color = {0, 0, 127}));
  connect(CsB.y, switch5.u1) annotation(
    Line(points = {{-211, 66}, {-188, 66}, {-188, 62}, {-174, 62}, {-174, 64}, {-170, 64}}, color = {0, 0, 127}));
  connect(Cp3B.y, add.u1) annotation(
    Line(points = {{-251, 150}, {-238, 150}}, color = {0, 0, 127}));
  connect(switch6.y, g3.u) annotation(
    Line(points = {{-166, 182}, {-114, 182}, {-114, 162}, {-80, 162}}, color = {0, 0, 127}));
  connect(CsA.y, switch5.u3) annotation(
    Line(points = {{-209, 12}, {-188, 12}, {-188, 52}, {-170, 52}}, color = {0, 0, 127}));
  connect(beta1B.y, switch7.u1) annotation(
    Line(points = {{-102, 13}, {-102, -6}, {-98, -6}}, color = {0, 0, 127}));
  connect(beta1A.y, switch7.u3) annotation(
    Line(points = {{-138, 16}, {-138, -18}, {-98, -18}}, color = {0, 0, 127}));
  connect(switch7.y, as1.u1) annotation(
    Line(points = {{-80, -12}, {-74, -12}, {-74, -46}, {-66, -46}}, color = {0, 0, 127}));
  connect(switch8.y, as2.u1) annotation(
    Line(points = {{-6, -20}, {2, -20}, {2, -70}, {-38, -70}, {-38, -86}, {-24, -86}}, color = {0, 0, 127}));
  connect(beta2A.y, switch8.u3) annotation(
    Line(points = {{-54, 14}, {-54, -26}, {-24, -26}}, color = {0, 0, 127}));
  connect(beta2B.y, switch8.u1) annotation(
    Line(points = {{-4, 16}, {-4, 0}, {-34, 0}, {-34, -14}, {-24, -14}}, color = {0, 0, 127}));
  connect(switch5.y, beta2B.u) annotation(
    Line(points = {{-152, 58}, {-4, 58}, {-4, 38}}, color = {0, 0, 127}));
  connect(switch5.y, beta2A.u) annotation(
    Line(points = {{-152, 58}, {-54, 58}, {-54, 36}}, color = {0, 0, 127}));
  connect(switch5.y, beta1B.u) annotation(
    Line(points = {{-152, 58}, {-102, 58}, {-102, 36}}, color = {0, 0, 127}));
  connect(switch5.y, beta1A.u) annotation(
    Line(points = {{-152, 58}, {-138, 58}, {-138, 38}}, color = {0, 0, 127}));
  connect(beta3B.y, add.u2) annotation(
    Line(points = {{-270, 100}, {-286, 100}, {-286, 130}, {-246, 130}, {-246, 138}, {-238, 138}}, color = {0, 0, 127}));
  connect(CsB.y, beta3B.u) annotation(
    Line(points = {{-211, 66}, {-188, 66}, {-188, 100}, {-248, 100}}, color = {0, 0, 127}));
  connect(Pn3.y, feedback1.u1) annotation(
    Line(points = {{-6, 162}, {32, 162}}, color = {0, 0, 127}));
  connect(Bconfig.y, switch1.u2) annotation(
    Line(points = {{-376, 44}, {-286, 44}, {-286, -34}, {-144, -34}}, color = {255, 0, 255}));
  connect(Bconfig.y, switch4.u2) annotation(
    Line(points = {{-376, 44}, {-286, 44}, {-286, -114}, {-144, -114}}, color = {255, 0, 255}));
  connect(Bconfig.y, switch5.u2) annotation(
    Line(points = {{-376, 44}, {-192, 44}, {-192, 58}, {-170, 58}}, color = {255, 0, 255}));
  connect(Bconfig.y, switch6.u2) annotation(
    Line(points = {{-376, 44}, {-338, 44}, {-338, 176}, {-216, 176}, {-216, 182}, {-184, 182}}, color = {255, 0, 255}));
  connect(Bconfig.y, switch7.u2) annotation(
    Line(points = {{-376, 44}, {-174, 44}, {-174, 4}, {-114, 4}, {-114, -12}, {-98, -12}}, color = {255, 0, 255}));
  connect(Bconfig.y, switch8.u2) annotation(
    Line(points = {{-376, 44}, {-38, 44}, {-38, -20}, {-24, -20}}, color = {255, 0, 255}));
  connect(add.y, switch6.u1) annotation(
    Line(points = {{-214, 144}, {-196, 144}, {-196, 188}, {-184, 188}}, color = {0, 0, 127}));
  connect(Cp3A.y, switch6.u3) annotation(
    Line(points = {{-229, 194}, {-204, 194}, {-204, 176}, {-184, 176}}, color = {0, 0, 127}));
  connect(Bconfig.y, switch11.u2) annotation(
    Line(points = {{-376, 44}, {-338, 44}, {-338, 156}, {-306, 156}}, color = {255, 0, 255}));
  connect(Bconfig.y, switch12.u2) annotation(
    Line(points = {{-376, 44}, {-338, 44}, {-338, 194}, {-326, 194}}, color = {255, 0, 255}));
  connect(Bconfig.y, switch14.u2) annotation(
    Line(points = {{-376, 44}, {-338, 44}, {-338, -14}, {-314, -14}}, color = {255, 0, 255}));
  connect(Bconfig.y, switch16.u2) annotation(
    Line(points = {{-376, 44}, {-338, 44}, {-338, -98}, {-316, -98}}, color = {255, 0, 255}));
  connect(realExpression1.y, switch12.u1) annotation(
    Line(points = {{-366, 200}, {-326, 200}}, color = {0, 0, 127}));
  connect(switch12.y, Cp3A.u) annotation(
    Line(points = {{-307, 194}, {-252, 194}}, color = {0, 0, 127}));
  connect(switch11.y, Cp3B.u) annotation(
    Line(points = {{-288, 156}, {-278, 156}, {-278, 150}, {-274, 150}}, color = {0, 0, 127}));
  connect(fb3.y, switch12.u3) annotation(
    Line(points = {{-101, 122}, {-352, 122}, {-352, 188}, {-326, 188}}, color = {0, 0, 127}));
  connect(fb3.y, switch11.u1) annotation(
    Line(points = {{-100, 122}, {-324, 122}, {-324, 162}, {-306, 162}}, color = {0, 0, 127}));
  connect(realExpression1.y, switch11.u3) annotation(
    Line(points = {{-366, 200}, {-360, 200}, {-360, 150}, {-306, 150}}, color = {0, 0, 127}));
  connect(realExpression1.y, switch14.u1) annotation(
    Line(points = {{-366, 200}, {-360, 200}, {-360, -8}, {-314, -8}}, color = {0, 0, 127}));
  connect(realExpression1.y, switch16.u3) annotation(
    Line(points = {{-366, 200}, {-360, 200}, {-360, -104}, {-316, -104}}, color = {0, 0, 127}));
  connect(fb12.y, switch14.u3) annotation(
    Line(points = {{34, -150}, {-346, -150}, {-346, -20}, {-314, -20}}, color = {0, 0, 127}));
  connect(fb12.y, switch16.u1) annotation(
    Line(points = {{34, -150}, {-328, -150}, {-328, -92}, {-316, -92}}, color = {0, 0, 127}));
  connect(switch16.y, Cp2B.u) annotation(
    Line(points = {{-297, -98}, {-184, -98}}, color = {0, 0, 127}));
  connect(switch16.y, Cp1B.u) annotation(
    Line(points = {{-297, -98}, {-260, -98}, {-260, -16}, {-186, -16}}, color = {0, 0, 127}));
  connect(switch16.y, CsB.u) annotation(
    Line(points = {{-297, -98}, {-260, -98}, {-260, 66}, {-234, 66}}, color = {0, 0, 127}));
  connect(switch14.y, CsA.u) annotation(
    Line(points = {{-296, -14}, {-272, -14}, {-272, 12}, {-232, 12}}, color = {0, 0, 127}));
  connect(switch14.y, Cp1A.u) annotation(
    Line(points = {{-296, -14}, {-272, -14}, {-272, -58}, {-184, -58}}, color = {0, 0, 127}));
  connect(switch14.y, Cp2A.u) annotation(
    Line(points = {{-296, -14}, {-272, -14}, {-272, -138}, {-184, -138}}, color = {0, 0, 127}));
  connect(DPe3.y, feedback1.u2) annotation(
    Line(points = {{8, 208}, {40, 208}, {40, 170}}, color = {0, 0, 127}));
  connect(DPe12.y, Pbal.u2) annotation(
    Line(points = {{109, -28}, {142, -28}, {142, -64}}, color = {0, 0, 127}));
  connect(feedback1.y, N_IsA.u) annotation(
    Line(points = {{50, 162}, {76, 162}}, color = {0, 0, 127}));
  connect(Pbal.y, N_NetA.u) annotation(
    Line(points = {{152, -72}, {164, -72}}, color = {0, 0, 127}));
  connect(N_NetA.y, switch2.u3) annotation(
    Line(points = {{188, -72}, {234, -72}, {234, -48}, {264, -48}}, color = {0, 0, 127}));
  connect(N_IsA.y, switch13.u3) annotation(
    Line(points = {{100, 162}, {156, 162}, {156, 144}, {176, 144}}, color = {0, 0, 127}));
  connect(switch13.y, fb3.u) annotation(
    Line(points = {{194, 150}, {218, 150}, {218, 122}, {-78, 122}}, color = {0, 0, 127}));
  annotation(
    uses(Modelica(version = "4.0.0")),
    Diagram(coordinateSystem(extent = {{-400, 220}, {300, -160}})),
    version = "");end Configurationchngtest2;
