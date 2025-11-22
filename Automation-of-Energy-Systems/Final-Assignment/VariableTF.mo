model VariableTF
  parameter Real b1[:]={1};
  parameter Real a1[:]={1};
  parameter Real b2[:]={1};
  parameter Real a2[:]={1};
  
  Modelica.Blocks.Interfaces.RealInput u annotation(
    Placement(visible = true, transformation(origin = {-84, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-78, 40}, extent = {{-12, -12}, {12, 12}}, rotation = 0)));
  Modelica.Blocks.Interfaces.BooleanInput BoolChoice annotation(
    Placement(visible = true, transformation(origin = {-84, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-78, -38}, extent = {{-12, -12}, {12, 12}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput y annotation(
    Placement(visible = true, transformation(origin = {88, 4}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {87, -1}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch annotation(
    Placement(visible = true, transformation(origin = {44, 4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.TransferFunction transferFunction1(a = a1, b = b1)  annotation(
    Placement(visible = true, transformation(origin = {8, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.TransferFunction transferFunction2(a = a2, b = b2)  annotation(
    Placement(visible = true, transformation(origin = {4, -26}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpression(y = 0)  annotation(
    Placement(visible = true, transformation(origin = {-74, 82}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpression1(y = 0) annotation(
    Placement(visible = true, transformation(origin = {-70, -78}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch1 annotation(
    Placement(visible = true, transformation(origin = {-16, 66}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch2 annotation(
    Placement(visible = true, transformation(origin = {-26, -64}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(switch.u2, BoolChoice) annotation(
    Line(points = {{32, 4}, {-50, 4}, {-50, -40}, {-84, -40}}, color = {255, 0, 255}));
  connect(switch.y, y) annotation(
    Line(points = {{55, 4}, {88, 4}}, color = {0, 0, 127}));
  connect(transferFunction1.y, switch.u1) annotation(
    Line(points = {{19, 30}, {22.5, 30}, {22.5, 12}, {32, 12}}, color = {0, 0, 127}));
  connect(realExpression.y, switch1.u1) annotation(
    Line(points = {{-63, 82}, {-38, 82}, {-38, 74}, {-28, 74}}, color = {0, 0, 127}));
  connect(switch2.y, transferFunction2.u) annotation(
    Line(points = {{-14, -64}, {-12, -64}, {-12, -26}, {-8, -26}}, color = {0, 0, 127}));
  connect(switch1.y, transferFunction1.u) annotation(
    Line(points = {{-4, 66}, {4, 66}, {4, 50}, {-14, 50}, {-14, 30}, {-4, 30}}, color = {0, 0, 127}));
  connect(u, switch1.u3) annotation(
    Line(points = {{-84, 40}, {-44, 40}, {-44, 58}, {-28, 58}}, color = {0, 0, 127}));
  connect(u, switch2.u1) annotation(
    Line(points = {{-84, 40}, {-44, 40}, {-44, -56}, {-38, -56}}, color = {0, 0, 127}));
  connect(realExpression1.y, switch2.u3) annotation(
    Line(points = {{-59, -78}, {-43, -78}, {-43, -72}, {-38, -72}}, color = {0, 0, 127}));
  connect(BoolChoice, switch2.u2) annotation(
    Line(points = {{-84, -40}, {-50, -40}, {-50, -64}, {-38, -64}}, color = {255, 0, 255}));
  connect(BoolChoice, switch1.u2) annotation(
    Line(points = {{-84, -40}, {-50, -40}, {-50, 66}, {-28, 66}}, color = {255, 0, 255}));
  connect(transferFunction2.y, switch.u3) annotation(
    Line(points = {{16, -26}, {24, -26}, {24, -4}, {32, -4}}, color = {0, 0, 127}));
  annotation(
    Icon(graphics = {Rectangle(origin = {6, -3}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, lineThickness = 0.5, extent = {{-72, 67}, {72, -67}}), Text(origin = {64, -63}, extent = {{-118, 103}, {0, 29}}, textString = "b(s)/a(s)")}),
    uses(Modelica(version = "4.0.0")));

end VariableTF;
