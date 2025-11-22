model ConfigChange2test2
  Modelica.Blocks.Math.Gain Pn3(k = 150) annotation(
    Placement(visible = true, transformation(origin = {88, 26}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain beta3B(k = 2/5) annotation(
    Placement(visible = true, transformation(origin = {4, 126}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Continuous.Integrator N(k = 10^6/(314.16^2)) annotation(
    Placement(visible = true, transformation(origin = {250, -42}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain Pn1(k = 100) annotation(
    Placement(visible = true, transformation(origin = {20, -42}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback Pbal annotation(
    Placement(visible = true, transformation(origin = {198, -42}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Continuous.TransferFunction g2(a = {5, 1}, b = {1}) annotation(
    Placement(visible = true, transformation(origin = {-8, -102}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain beta1B(k = 2/5) annotation(
    Placement(visible = true, transformation(origin = {-198, 134}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Continuous.TransferFunction g1(a = {10, 1}, b = {1}) annotation(
    Placement(visible = true, transformation(origin = {-34, -42}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain Pn2(k = 50) annotation(
    Placement(visible = true, transformation(origin = {42, -102}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator Cs(k = 1) annotation(
    Placement(visible = true, transformation(origin = {-266, 188}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.TransferFunction g3(a = {20, 1}, b = {1}) annotation(
    Placement(visible = true, transformation(origin = {50, 26}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add3 Ptot annotation(
    Placement(visible = true, transformation(origin = {120, -42}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add1 annotation(
    Placement(visible = true, transformation(origin = {-130, -12}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add2 annotation(
    Placement(visible = true, transformation(origin = {-58, -102}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product annotation(
    Placement(visible = true, transformation(origin = {-196, 102}, extent = {{-4, -4}, {4, 4}}, rotation = -90)));
  Modelica.Blocks.Math.Add add annotation(
    Placement(visible = true, transformation(origin = {-179, 77}, extent = {{-5, -5}, {5, 5}}, rotation = -90)));
  Modelica.Blocks.Math.Gain beta1A(k = 0.66) annotation(
    Placement(visible = true, transformation(origin = {-164, 132}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Math.Product product1 annotation(
    Placement(visible = true, transformation(origin = {-158, 100}, extent = {{-4, -4}, {4, 4}}, rotation = -90)));
  Modelica.Blocks.Math.Gain beta2B(k = 1/5) annotation(
    Placement(visible = true, transformation(origin = {-102, 128}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Math.Product product2 annotation(
    Placement(visible = true, transformation(origin = {-96, 102}, extent = {{-4, -4}, {4, 4}}, rotation = -90)));
  Modelica.Blocks.Math.Gain beta2A(k = 0.33) annotation(
    Placement(visible = true, transformation(origin = {-64, 128}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Math.Product product11 annotation(
    Placement(visible = true, transformation(origin = {-60, 102}, extent = {{-4, -4}, {4, 4}}, rotation = -90)));
  Modelica.Blocks.Math.Add add4 annotation(
    Placement(visible = true, transformation(origin = {-71, 81}, extent = {{-5, -5}, {5, 5}}, rotation = -90)));
  Modelica.Blocks.Math.Product product1111 annotation(
    Placement(visible = true, transformation(origin = {10, 98}, extent = {{-4, -4}, {4, 4}}, rotation = -90)));
  Modelica.Blocks.Math.Gain beta1B1(k = 1777/137500) annotation(
    Placement(visible = true, transformation(origin = {-368, 194}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain beta1A1(k = 0.016) annotation(
    Placement(visible = true, transformation(origin = {-366, 142}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product3 annotation(
    Placement(visible = true, transformation(origin = {-334, 148}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));
  Modelica.Blocks.Math.Product product12 annotation(
    Placement(visible = true, transformation(origin = {-336, 186}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));
  Modelica.Blocks.Math.Add add5 annotation(
    Placement(visible = true, transformation(origin = {-309, 167}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Math.Gain Kp3B(k = 184012/61875/5) annotation(
    Placement(visible = true, transformation(origin = {-276, 52}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product121 annotation(
    Placement(visible = true, transformation(origin = {-248, 48}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));
  Modelica.Blocks.Math.Product product31 annotation(
    Placement(visible = true, transformation(origin = {-246, 20}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));
  Modelica.Blocks.Math.Add add51 annotation(
    Placement(visible = true, transformation(origin = {-221, 29}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Math.Gain kp1B(k = 1788*10/34375) annotation(
    Placement(visible = true, transformation(origin = {-276, -38}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain kp1A(k = 133*10/1250) annotation(
    Placement(visible = true, transformation(origin = {-278, -74}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product311 annotation(
    Placement(visible = true, transformation(origin = {-246, -70}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));
  Modelica.Blocks.Math.Product product1211 annotation(
    Placement(visible = true, transformation(origin = {-248, -42}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));
  Modelica.Blocks.Math.Add add511 annotation(
    Placement(visible = true, transformation(origin = {-221, -61}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Math.Gain kp2B(k = 1396*10/103125) annotation(
    Placement(visible = true, transformation(origin = {-274, -118}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain kp2A(k = 677327/100000/10) annotation(
    Placement(visible = true, transformation(origin = {-276, -154}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product12111 annotation(
    Placement(visible = true, transformation(origin = {-246, -122}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));
  Modelica.Blocks.Math.Product product3111 annotation(
    Placement(visible = true, transformation(origin = {-244, -150}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));
  Modelica.Blocks.Math.Add add5111 annotation(
    Placement(visible = true, transformation(origin = {-219, -141}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Math.Product product1212 annotation(
    Placement(visible = true, transformation(origin = {116, 0}, extent = {{-4, -4}, {4, 4}}, rotation = -90)));
  Modelica.Blocks.Math.Gain JtotB(k = 1/(40*10^3)) annotation(
    Placement(visible = true, transformation(origin = {330, -44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain J12A(k = 1/30*10^3) annotation(
    Placement(visible = true, transformation(origin = {328, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product312 annotation(
    Placement(visible = true, transformation(origin = {360, -76}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));
  Modelica.Blocks.Math.Product product1213 annotation(
    Placement(visible = true, transformation(origin = {358, -48}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));
  Modelica.Blocks.Math.Add GEN12 annotation(
    Placement(visible = true, transformation(origin = {385, -67}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Math.Add add31 annotation(
    Placement(visible = true, transformation(origin = {150, -4}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Math.Product product1214 annotation(
    Placement(visible = true, transformation(origin = {164, 24}, extent = {{-4, -4}, {4, 4}}, rotation = 90)));
  Modelica.Blocks.Math.Add add311 annotation(
    Placement(visible = true, transformation(origin = {156, 52}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Math.Feedback pbal annotation(
    Placement(visible = true, transformation(origin = {174, 98}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Math.Product GEN3 annotation(
    Placement(visible = true, transformation(origin = {342, 88}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = 1/(10*10^3)) annotation(
    Placement(visible = true, transformation(origin = {310, 84}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain fb(k = -1) annotation(
    Placement(visible = true, transformation(origin = {14, -218}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression Pe12(y = if (time < 100 or time > 500) then 100 else 160)  annotation(
    Placement(visible = true, transformation(origin = {80, 218}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression Pe34(y = if (time < 100 or time > 500) then 50 else 60)  annotation(
    Placement(visible = true, transformation(origin = {80, 250}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product6 annotation(
    Placement(visible = true, transformation(origin = {154, 244}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));
  Modelica.Blocks.Math.Add add7 annotation(
    Placement(visible = true, transformation(origin = {181, 225}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanExpression BTrue(y = if (time < 100 or time > 500) then false else true)  annotation(
    Placement(visible = true, transformation(origin = {-538, 262}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.BooleanToReal booleanToReal(realFalse = 0, realTrue = 1)  annotation(
    Placement(visible = true, transformation(origin = {-494, 262}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add9 annotation(
    Placement(visible = true, transformation(origin = {-488, 130}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Sources.RealExpression realExpression1(y = +1)  annotation(
    Placement(visible = true, transformation(origin = {-520, 170}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product10 annotation(
    Placement(visible = true, transformation(origin = {-467, 185}, extent = {{-7, -7}, {7, 7}}, rotation = -90)));
  Modelica.Blocks.Sources.RealExpression realExpression11(y = -1) annotation(
    Placement(visible = true, transformation(origin = {-500, 200}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.TransferFunction transferFunction(a = {1.67, 1}, b = {14.253, 1})  annotation(
    Placement(visible = true, transformation(origin = {-276, 12}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain fb1(k = -1) annotation(
    Placement(visible = true, transformation(origin = {12, -264}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product101 annotation(
    Placement(visible = true, transformation(origin = {-267, -235}, extent = {{-7, -7}, {7, 7}}, rotation = 180)));
  Modelica.Blocks.Math.Add3 add3 annotation(
    Placement(visible = true, transformation(origin = {-12, 26}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator cs(k = 0.02104) annotation(
    Placement(visible = true, transformation(origin = {-84, 228}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add512 annotation(
    Placement(visible = true, transformation(origin = {-303, 15}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Math.Add add5121 annotation(
    Placement(visible = true, transformation(origin = {-311, 49}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Math.Product product12141 annotation(
    Placement(visible = true, transformation(origin = {220, 94}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));
equation
  connect(g2.y, Pn2.u) annotation(
    Line(points = {{3, -102}, {30, -102}}, color = {0, 0, 127}));
  connect(g1.y, Pn1.u) annotation(
    Line(points = {{-23, -42}, {8, -42}}, color = {0, 0, 127}));
  connect(Cs.y, beta1B.u) annotation(
    Line(points = {{-255, 188}, {-198, 188}, {-198, 146}}, color = {0, 0, 127}));
  connect(add2.y, g2.u) annotation(
    Line(points = {{-47, -102}, {-20, -102}}, color = {0, 0, 127}));
  connect(Pn1.y, Ptot.u2) annotation(
    Line(points = {{31, -42}, {108, -42}}, color = {0, 0, 127}));
  connect(Pbal.y, N.u) annotation(
    Line(points = {{207, -42}, {238, -42}}, color = {0, 0, 127}));
  connect(Pn2.y, Ptot.u3) annotation(
    Line(points = {{53, -102}, {64.5, -102}, {64.5, -50}, {108, -50}}, color = {0, 0, 127}));
  connect(Pn3.u, g3.y) annotation(
    Line(points = {{76, 26}, {61, 26}}, color = {0, 0, 127}));
  connect(add1.y, g1.u) annotation(
    Line(points = {{-119, -12}, {-73, -12}, {-73, -42}, {-46, -42}}, color = {0, 0, 127}));
  connect(Ptot.y, Pbal.u1) annotation(
    Line(points = {{131, -42}, {190, -42}}, color = {0, 0, 127}));
  connect(beta1B.y, product.u2) annotation(
    Line(points = {{-198, 123}, {-198, 107}}, color = {0, 0, 127}));
  connect(product.y, add.u2) annotation(
    Line(points = {{-196, 98}, {-196, 90}, {-182, 90}, {-182, 83}}, color = {0, 0, 127}));
  connect(Cs.y, beta1A.u) annotation(
    Line(points = {{-255, 188}, {-198, 188}, {-198, 152}, {-164, 152}, {-164, 144}}, color = {0, 0, 127}));
  connect(beta1A.y, product1.u2) annotation(
    Line(points = {{-164, 122}, {-164, 113.5}, {-160, 113.5}, {-160, 105}}, color = {0, 0, 127}));
  connect(product1.y, add.u1) annotation(
    Line(points = {{-158, 96}, {-158, 89}, {-176, 89}, {-176, 83}}, color = {0, 0, 127}));
  connect(add.y, add1.u1) annotation(
    Line(points = {{-179, 71.5}, {-179, -6}, {-142, -6}}, color = {0, 0, 127}));
  connect(Cs.y, beta2B.u) annotation(
    Line(points = {{-255, 188}, {-102, 188}, {-102, 140}}, color = {0, 0, 127}));
  connect(Cs.y, beta2A.u) annotation(
    Line(points = {{-255, 188}, {-102, 188}, {-102, 148}, {-64, 148}, {-64, 140}}, color = {0, 0, 127}));
  connect(beta2B.y, product2.u2) annotation(
    Line(points = {{-102, 118}, {-102, 110}, {-98, 110}, {-98, 106}}, color = {0, 0, 127}));
  connect(beta2A.y, product11.u2) annotation(
    Line(points = {{-64, 118}, {-64, 110}, {-62, 110}, {-62, 106}}, color = {0, 0, 127}));
  connect(product2.y, add4.u2) annotation(
    Line(points = {{-96, 98}, {-96, 92}, {-74, 92}, {-74, 87}}, color = {0, 0, 127}));
  connect(product11.y, add4.u1) annotation(
    Line(points = {{-60, 98}, {-60, 92}, {-68, 92}, {-68, 87}}, color = {0, 0, 127}));
  connect(add4.y, add2.u1) annotation(
    Line(points = {{-71, 75.5}, {-72, 75.5}, {-72, -96}, {-70, -96}}, color = {0, 0, 127}));
  connect(beta3B.y, product1111.u2) annotation(
    Line(points = {{4, 116}, {4, 106}, {8, 106}, {8, 103}}, color = {0, 0, 127}));
  connect(beta1B1.y, product12.u1) annotation(
    Line(points = {{-356, 194}, {-344, 194}, {-344, 188}, {-340, 188}}, color = {0, 0, 127}));
  connect(beta1A1.y, product3.u2) annotation(
    Line(points = {{-354, 142}, {-342, 142}, {-342, 146}, {-338, 146}}, color = {0, 0, 127}));
  connect(product3.y, add5.u2) annotation(
    Line(points = {{-330, 148}, {-324, 148}, {-324, 164}, {-314, 164}}, color = {0, 0, 127}));
  connect(product12.y, add5.u1) annotation(
    Line(points = {{-332, 186}, {-322, 186}, {-322, 172}, {-314, 172}, {-314, 170}}, color = {0, 0, 127}));
  connect(add5.y, Cs.u) annotation(
    Line(points = {{-304, 168}, {-290, 168}, {-290, 188}, {-278, 188}}, color = {0, 0, 127}));
  connect(beta3B.u, Cs.y) annotation(
    Line(points = {{4, 138}, {4, 188}, {-255, 188}}, color = {0, 0, 127}));
  connect(Kp3B.y, product121.u1) annotation(
    Line(points = {{-265, 52}, {-257, 52}, {-257, 50}, {-253, 50}}, color = {0, 0, 127}));
  connect(product31.y, add51.u2) annotation(
    Line(points = {{-241.6, 20}, {-233.6, 20}, {-233.6, 26}, {-225.6, 26}}, color = {0, 0, 127}));
  connect(product121.y, add51.u1) annotation(
    Line(points = {{-243.6, 48}, {-231.6, 48}, {-231.6, 32}, {-225.6, 32}}, color = {0, 0, 127}));
  connect(kp1B.y, product1211.u1) annotation(
    Line(points = {{-264, -38}, {-260, -38}, {-260, -40}, {-252, -40}}, color = {0, 0, 127}));
  connect(kp1A.y, product311.u2) annotation(
    Line(points = {{-266, -74}, {-256, -74}, {-256, -72}, {-250, -72}}, color = {0, 0, 127}));
  connect(product311.y, add511.u2) annotation(
    Line(points = {{-242, -70}, {-232, -70}, {-232, -64}, {-226, -64}}, color = {0, 0, 127}));
  connect(product1211.y, add511.u1) annotation(
    Line(points = {{-244, -42}, {-234, -42}, {-234, -58}, {-226, -58}}, color = {0, 0, 127}));
  connect(add511.y, add1.u2) annotation(
    Line(points = {{-216, -60}, {-178, -60}, {-178, -18}, {-142, -18}}, color = {0, 0, 127}));
  connect(kp2B.y, product12111.u1) annotation(
    Line(points = {{-262, -118}, {-257, -118}, {-257, -120}, {-250, -120}}, color = {0, 0, 127}));
  connect(kp2A.y, product3111.u2) annotation(
    Line(points = {{-264, -154}, {-254, -154}, {-254, -152}, {-248, -152}}, color = {0, 0, 127}));
  connect(product3111.y, add5111.u2) annotation(
    Line(points = {{-240, -150}, {-232, -150}, {-232, -144}, {-224, -144}}, color = {0, 0, 127}));
  connect(product12111.y, add5111.u1) annotation(
    Line(points = {{-242, -122}, {-232, -122}, {-232, -138}, {-224, -138}}, color = {0, 0, 127}));
  connect(add5111.y, add2.u2) annotation(
    Line(points = {{-214, -140}, {-90, -140}, {-90, -108}, {-70, -108}}, color = {0, 0, 127}));
  connect(Pn3.y, product1212.u2) annotation(
    Line(points = {{100, 26}, {114, 26}, {114, 4}}, color = {0, 0, 127}));
  connect(product1212.y, Ptot.u1) annotation(
    Line(points = {{116, -4}, {116, -18}, {88, -18}, {88, -34}, {108, -34}}, color = {0, 0, 127}));
  connect(N.y, JtotB.u) annotation(
    Line(points = {{262, -42}, {318, -42}, {318, -44}}, color = {0, 0, 127}));
  connect(N.y, J12A.u) annotation(
    Line(points = {{262, -42}, {290, -42}, {290, -80}, {316, -80}}, color = {0, 0, 127}));
  connect(JtotB.y, product1213.u1) annotation(
    Line(points = {{342, -44}, {347, -44}, {347, -46}, {354, -46}}, color = {0, 0, 127}));
  connect(J12A.y, product312.u2) annotation(
    Line(points = {{340, -80}, {350, -80}, {350, -78}, {356, -78}}, color = {0, 0, 127}));
  connect(product312.y, GEN12.u2) annotation(
    Line(points = {{364, -76}, {372, -76}, {372, -70}, {379, -70}}, color = {0, 0, 127}));
  connect(product1213.y, GEN12.u1) annotation(
    Line(points = {{362, -48}, {374, -48}, {374, -64}, {379, -64}}, color = {0, 0, 127}));
  connect(Pn2.y, add31.u2) annotation(
    Line(points = {{54, -102}, {152, -102}, {152, -16}, {156, -16}}, color = {0, 0, 127}));
  connect(Pn1.y, add31.u1) annotation(
    Line(points = {{32, -42}, {50, -42}, {50, -84}, {144, -84}, {144, -16}}, color = {0, 0, 127}));
  connect(add31.y, product1214.u1) annotation(
    Line(points = {{150, 8}, {148, 8}, {148, 16}, {162, 16}, {162, 19}}, color = {0, 0, 127}));
  connect(Pn3.y, add311.u1) annotation(
    Line(points = {{100, 26}, {150, 26}, {150, 40}}, color = {0, 0, 127}));
  connect(product1214.y, add311.u2) annotation(
    Line(points = {{164, 28}, {162, 28}, {162, 40}}, color = {0, 0, 127}));
  connect(add311.y, pbal.u1) annotation(
    Line(points = {{156, 64}, {156, 98}, {166, 98}}, color = {0, 0, 127}));
  connect(gain.y, GEN3.u2) annotation(
    Line(points = {{321, 84}, {332, 84}, {332, 86}, {337, 86}}, color = {0, 0, 127}));
  connect(GEN12.y, fb.u) annotation(
    Line(points = {{390.5, -67}, {416, -67}, {416, -218}, {26, -218}}, color = {0, 0, 127}));
  connect(fb.y, kp2A.u) annotation(
    Line(points = {{4, -218}, {-312, -218}, {-312, -154}, {-288, -154}}, color = {0, 0, 127}));
  connect(fb.y, kp2B.u) annotation(
    Line(points = {{4, -218}, {-312, -218}, {-312, -118}, {-286, -118}}, color = {0, 0, 127}));
  connect(fb.y, kp1A.u) annotation(
    Line(points = {{4, -218}, {-312, -218}, {-312, -74}, {-290, -74}}, color = {0, 0, 127}));
  connect(fb.y, kp1B.u) annotation(
    Line(points = {{4, -218}, {-312, -218}, {-312, -38}, {-288, -38}}, color = {0, 0, 127}));
  connect(fb.y, beta1A1.u) annotation(
    Line(points = {{4, -218}, {-398, -218}, {-398, 142}, {-378, 142}}, color = {0, 0, 127}));
  connect(fb.y, beta1B1.u) annotation(
    Line(points = {{4, -218}, {-398, -218}, {-398, 194}, {-380, 194}}, color = {0, 0, 127}));
  connect(product6.y, add7.u1) annotation(
    Line(points = {{158.4, 244}, {170.4, 244}, {170.4, 228}, {175.4, 228}}, color = {0, 0, 127}));
  connect(Pe34.y, product6.u1) annotation(
    Line(points = {{92, 250}, {142, 250}, {142, 246}, {150, 246}}, color = {0, 0, 127}));
  connect(add7.y, Pbal.u2) annotation(
    Line(points = {{186, 226}, {210, 226}, {210, 122}, {198, 122}, {198, -34}}, color = {0, 0, 127}));
  connect(BTrue.y, booleanToReal.u) annotation(
    Line(points = {{-526, 262}, {-506, 262}}, color = {255, 0, 255}));
  connect(booleanToReal.y, product12.u2) annotation(
    Line(points = {{-482, 262}, {-348, 262}, {-348, 184}, {-340, 184}}, color = {0, 0, 127}));
  connect(booleanToReal.y, product.u1) annotation(
    Line(points = {{-482, 262}, {-220, 262}, {-220, 112}, {-194, 112}, {-194, 106}}, color = {0, 0, 127}));
  connect(booleanToReal.y, product2.u1) annotation(
    Line(points = {{-482, 262}, {-124, 262}, {-124, 114}, {-94, 114}, {-94, 106}}, color = {0, 0, 127}));
  connect(booleanToReal.y, product1111.u1) annotation(
    Line(points = {{-482, 262}, {-28, 262}, {-28, 108}, {12, 108}, {12, 103}}, color = {0, 0, 127}));
  connect(booleanToReal.y, product6.u2) annotation(
    Line(points = {{-482, 262}, {50, 262}, {50, 240}, {150, 240}, {150, 242}}, color = {0, 0, 127}));
  connect(booleanToReal.y, product121.u2) annotation(
    Line(points = {{-482, 262}, {-446, 262}, {-446, 78}, {-262, 78}, {-262, 46}, {-252, 46}}, color = {0, 0, 127}));
  connect(booleanToReal.y, product1211.u2) annotation(
    Line(points = {{-482, 262}, {-446, 262}, {-446, -56}, {-258, -56}, {-258, -44}, {-252, -44}}, color = {0, 0, 127}));
  connect(booleanToReal.y, product12111.u2) annotation(
    Line(points = {{-482, 262}, {-446, 262}, {-446, -134}, {-256, -134}, {-256, -124}, {-250, -124}}, color = {0, 0, 127}));
  connect(booleanToReal.y, product1212.u1) annotation(
    Line(points = {{-482, 262}, {22, 262}, {22, 156}, {84, 156}, {84, 50}, {118, 50}, {118, 4}}, color = {0, 0, 127}));
  connect(booleanToReal.y, product1214.u2) annotation(
    Line(points = {{-482, 262}, {244, 262}, {244, 8}, {166, 8}, {166, 20}}, color = {0, 0, 127}));
  connect(booleanToReal.y, product1213.u2) annotation(
    Line(points = {{-482, 262}, {272, 262}, {272, -18}, {350, -18}, {350, -50}, {354, -50}}, color = {0, 0, 127}));
  connect(realExpression1.y, add9.u2) annotation(
    Line(points = {{-508, 170}, {-494, 170}, {-494, 142}}, color = {0, 0, 127}));
  connect(booleanToReal.y, product10.u1) annotation(
    Line(points = {{-482, 262}, {-463, 262}, {-463, 193}}, color = {0, 0, 127}));
  connect(product10.y, add9.u1) annotation(
    Line(points = {{-467, 177}, {-482, 177}, {-482, 142}}, color = {0, 0, 127}));
  connect(realExpression11.y, product10.u2) annotation(
    Line(points = {{-488, 200}, {-471, 200}, {-471, 193}}, color = {0, 0, 127}));
  connect(add9.y, product31.u1) annotation(
    Line(points = {{-488, 119}, {-488, -6}, {-256, -6}, {-256, 22}, {-250, 22}}, color = {0, 0, 127}));
  connect(add9.y, product311.u1) annotation(
    Line(points = {{-488, 119}, {-488, -96}, {-258, -96}, {-258, -68}, {-250, -68}}, color = {0, 0, 127}));
  connect(add9.y, product3111.u1) annotation(
    Line(points = {{-488, 119}, {-488, -180}, {-256, -180}, {-256, -148}, {-248, -148}}, color = {0, 0, 127}));
  connect(add9.y, product3.u1) annotation(
    Line(points = {{-488, 119}, {-488, 46}, {-350, 46}, {-350, 150}, {-338, 150}}, color = {0, 0, 127}));
  connect(add9.y, product1.u1) annotation(
    Line(points = {{-488, 119}, {-488, 104}, {-230, 104}, {-230, 160}, {-136, 160}, {-136, 112}, {-156, 112}, {-156, 104}}, color = {0, 0, 127}));
  connect(add9.y, product11.u1) annotation(
    Line(points = {{-488, 119}, {-488, 88}, {-220, 88}, {-220, 66}, {-42, 66}, {-42, 112}, {-58, 112}, {-58, 106}}, color = {0, 0, 127}));
  connect(add9.y, GEN3.u1) annotation(
    Line(points = {{-488, 119}, {-488, 104}, {-230, 104}, {-230, 188}, {236, 188}, {236, 50}, {328, 50}, {328, 90}, {337, 90}}, color = {0, 0, 127}));
  connect(add9.y, product312.u1) annotation(
    Line(points = {{-488, 119}, {-488, -180}, {346, -180}, {346, -74}, {356, -74}}, color = {0, 0, 127}));
  connect(transferFunction.y, product31.u2) annotation(
    Line(points = {{-264, 12}, {-250, 12}, {-250, 18}}, color = {0, 0, 127}));
  connect(fb1.u, GEN3.y) annotation(
    Line(points = {{24, -264}, {436, -264}, {436, 88}, {346, 88}}, color = {0, 0, 127}));
  connect(fb.y, product101.u2) annotation(
    Line(points = {{4, -218}, {-226, -218}, {-226, -231}, {-259, -231}}, color = {0, 0, 127}));
  connect(product101.u1, booleanToReal.y) annotation(
    Line(points = {{-258, -240}, {-250, -240}, {-250, -278}, {-446, -278}, {-446, 262}, {-482, 262}}, color = {0, 0, 127}));
  connect(add51.y, add3.u3) annotation(
    Line(points = {{-216, 30}, {-54, 30}, {-54, 18}, {-24, 18}}, color = {0, 0, 127}));
  connect(product1111.y, add3.u2) annotation(
    Line(points = {{10, 94}, {10, 50}, {-44, 50}, {-44, 26}, {-24, 26}}, color = {0, 0, 127}));
  connect(add3.y, g3.u) annotation(
    Line(points = {{-1, 26}, {38, 26}}, color = {0, 0, 127}));
  connect(cs.y, add3.u1) annotation(
    Line(points = {{-72, 228}, {-36, 228}, {-36, 34}, {-24, 34}}, color = {0, 0, 127}));
  connect(GEN3.y, cs.u) annotation(
    Line(points = {{346, 88}, {352, 88}, {352, 198}, {-104, 198}, {-104, 228}, {-96, 228}}, color = {0, 0, 127}));
  connect(product101.y, add512.u2) annotation(
    Line(points = {{-274, -234}, {-324, -234}, {-324, 12}, {-308, 12}}, color = {0, 0, 127}));
  connect(fb1.y, add512.u1) annotation(
    Line(points = {{2, -264}, {-330, -264}, {-330, 18}, {-308, 18}}, color = {0, 0, 127}));
  connect(add512.y, transferFunction.u) annotation(
    Line(points = {{-298, 16}, {-288, 16}, {-288, 12}}, color = {0, 0, 127}));
  connect(add5121.y, Kp3B.u) annotation(
    Line(points = {{-306, 50}, {-288, 50}, {-288, 52}}, color = {0, 0, 127}));
  connect(add5121.u2, product101.y) annotation(
    Line(points = {{-316, 46}, {-342, 46}, {-342, -232}, {-274, -232}, {-274, -234}}, color = {0, 0, 127}));
  connect(fb1.y, add5121.u1) annotation(
    Line(points = {{2, -264}, {-346, -264}, {-346, 52}, {-316, 52}}, color = {0, 0, 127}));
  connect(Pe12.y, add7.u2) annotation(
    Line(points = {{92, 218}, {166, 218}, {166, 222}, {176, 222}}, color = {0, 0, 127}));
  connect(Pe34.y, pbal.u2) annotation(
    Line(points = {{92, 250}, {134, 250}, {134, 142}, {174, 142}, {174, 106}}, color = {0, 0, 127}));
  connect(product12141.y, gain.u) annotation(
    Line(points = {{224, 94}, {280, 94}, {280, 84}, {298, 84}}, color = {0, 0, 127}));
  connect(pbal.y, product12141.u1) annotation(
    Line(points = {{184, 98}, {216, 98}, {216, 96}}, color = {0, 0, 127}));
  connect(N.y, product12141.u2) annotation(
    Line(points = {{262, -42}, {264, -42}, {264, 78}, {202, 78}, {202, 92}, {216, 92}}, color = {0, 0, 127}));
  annotation(
    uses(Modelica(version = "4.0.0")),
    Diagram(coordinateSystem(extent = {{-560, 280}, {460, -300}}), graphics = {Bitmap(extent = {{-268, 190}, {-268, 190}})}),
    version = "");
end ConfigChange2test2;
