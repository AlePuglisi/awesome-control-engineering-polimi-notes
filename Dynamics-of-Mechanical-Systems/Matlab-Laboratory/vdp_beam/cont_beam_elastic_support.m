function H=cont_beam_elastic_support(gammaL)
global EI L
global K

gamma=gammaL/L;
cc=K/EI/gamma^3;

%simply supported beam continuous over 2*L resting on a lumped spring
H=[     1            0           1            0            0             0            0           0;
       -1            0           1            0            0             0            0           0; 
  cos(gammaL)  sin(gammaL) cosh(gammaL) sinh(gammaL)      -1             0           -1           0;
 -sin(gammaL)  cos(gammaL) sinh(gammaL) cosh(gammaL)       0            -1            0          -1;
 -cos(gammaL) -sin(gammaL) cosh(gammaL) sinh(gammaL)       1             0           -1           0; 
  sin(gammaL) -cos(gammaL) sinh(gammaL) cosh(gammaL)     -cc             1          -cc          -1;
        0            0            0            0      cos(gammaL)  sin(gammaL) cosh(gammaL) sinh(gammaL);
        0            0            0            0     -cos(gammaL) -sin(gammaL) cosh(gammaL) sinh(gammaL)];
    


