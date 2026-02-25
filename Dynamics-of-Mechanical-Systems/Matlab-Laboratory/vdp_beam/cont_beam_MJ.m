function H=cont_beam_MJ(gammaL)
global EI L m 
global M J

% beam with constant section constrained by a clamp and with a mass at the right extremity
gamma=gammaL/L;
h1=J/m*gamma^3;
h2=M/m*gamma;

H=[     1            0              1            0             0               0               0            0;
       -1            0              1            0             0               0               0            0;
        0            0              0            0          cos(gammaL)    sin(gammaL)    cosh(gammaL)   sinh(gammaL);
        0            0              0            0          -cos(gammaL)   -sin(gammaL)    cosh(gammaL)   sinh(gammaL);
      cos(gammaL)   sin(gammaL)  cosh(gammaL)   sinh(gammaL)    -1             0                -1          0;
      -sin(gammaL)   cos(gammaL)    sinh(gammaL)   cosh(gammaL)   0            -1                0         -1;
      cos(gammaL)   sin(gammaL)  -cosh(gammaL)   -sinh(gammaL)   -1             h1               1          h1;
      sin(gammaL)  -cos(gammaL)   sinh(gammaL)  cosh(gammaL)  h2           1                h2         -1];



