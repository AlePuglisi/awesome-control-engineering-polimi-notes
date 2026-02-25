function H=cont_beam(gammaL)

%continuous beam on three pins
H=[     1            0           1            0            0             0            0           0;
       -1            0           1            0            0             0            0           0; 
  cos(gammaL)  sin(gammaL) cosh(gammaL) sinh(gammaL)      -1             0           -1           0;
 -sin(gammaL)  cos(gammaL) sinh(gammaL) cosh(gammaL)       0            -1            0          -1;
 -cos(gammaL) -sin(gammaL) cosh(gammaL) sinh(gammaL)       1             0           -1           0;
        0            0            0            0           1             0            1           0;
        0            0            0            0      cos(gammaL)  sin(gammaL) cosh(gammaL) sinh(gammaL);
        0            0            0            0     -cos(gammaL) -sin(gammaL) cosh(gammaL) sinh(gammaL)];
    


