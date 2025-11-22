model Prova
  Modelica.Blocks.Logical.Switch switch3 annotation(
    Placement(visible = true, transformation(origin = {-368, -74}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch annotation(
    Placement(visible = true, transformation(origin = {-368, -74}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanExpression Bconfig(y = true) annotation(
    Placement(visible = true, transformation(origin = {-388, 44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanExpression booleanExpression(y = true) annotation(
    Placement(visible = true, transformation(origin = {-388, 44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanExpression booleanExpression1(y = true) annotation(
    Placement(visible = true, transformation(origin = {-388, 44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanExpression booleanExpression2(y = true) annotation(
    Placement(visible = true, transformation(origin = {-388, 44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanExpression booleanExpression3(y = true) annotation(
    Placement(visible = true, transformation(origin = {-378, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  VariableTF variableTF(a1 = {1}, a2 = {1}, b1 = {1}, b2 = {10})  annotation(
    Placement(visible = true, transformation(origin = {-12, 26}, extent = {{-28, -28}, {28, 28}}, rotation = 0)));
  Modelica.Blocks.Continuous.TransferFunction transferFunction(a = {1}, b = {1})  annotation(
    Placement(visible = true, transformation(origin = {76, 26}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanExpression booleanExpression4(y = if time > 0 then false else true)  annotation(
    Placement(visible = true, transformation(origin = {-64, 16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpression annotation(
    Placement(visible = true, transformation(origin = {-14, 72}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(visible = true, transformation(origin = {36, 26}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(transferFunction.y, variableTF.u) annotation(
    Line(points = {{88, 26}, {110, 26}, {110, -30}, {-84, -30}, {-84, 38}, {-34, 38}}, color = {0, 0, 127}));
  connect(booleanExpression4.y, variableTF.BoolChoice) annotation(
    Line(points = {{-53, 16}, {-34, 16}}, color = {255, 0, 255}));
  connect(variableTF.y, feedback.u1) annotation(
    Line(points = {{12, 26}, {28, 26}}, color = {0, 0, 127}));
  connect(feedback.y, transferFunction.u) annotation(
    Line(points = {{46, 26}, {64, 26}}, color = {0, 0, 127}));
  connect(feedback.u2, realExpression.y) annotation(
    Line(points = {{36, 18}, {54, 18}, {54, 72}, {-2, 72}}, color = {0, 0, 127}));
  annotation(
    uses(Modelica(version = "4.0.0")));
end Prova;
