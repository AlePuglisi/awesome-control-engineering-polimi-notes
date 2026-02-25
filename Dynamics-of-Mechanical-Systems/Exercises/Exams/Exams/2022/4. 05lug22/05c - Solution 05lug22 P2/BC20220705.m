function H=BC20220705(gammaL)
global EI L m 
global M J

gamma=gammaL/L;
cc1=J/m*gamma^3;
cc2=M/m*gamma;

%simply supported beam continuous over 2*L with central mass
H=[     1            0           1            0            0             0            0           0;
       -1            0           1            0            0             0            0           0; 
  cos(gammaL)  sin(gammaL) cosh(gammaL) sinh(gammaL)      -1             0           -1           0;
 -sin(gammaL)  cos(gammaL) sinh(gammaL) cosh(gammaL)       0            -1            0          -1;
 -cos(gammaL) -sin(gammaL) cosh(gammaL) sinh(gammaL)       1           -cc1          -1         -cc1; 
  sin(gammaL) -cos(gammaL) sinh(gammaL) cosh(gammaL)      cc2            1           cc2         -1;
        0            0            0            0      cos(gammaL)  sin(gammaL) cosh(gammaL) sinh(gammaL);
        0            0            0            0     -cos(gammaL) -sin(gammaL) cosh(gammaL) sinh(gammaL)];
    


