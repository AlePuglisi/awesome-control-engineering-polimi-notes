function H=clamphinge(gammaL)


% beam with constant section constrained by a clamp and a hinge
H=[     1            0           1            0;
        0            1           0            1;
  cos(gammaL)  sin(gammaL) cosh(gammaL) sinh(gammaL);
 -cos(gammaL) -sin(gammaL) cosh(gammaL) sinh(gammaL)];
