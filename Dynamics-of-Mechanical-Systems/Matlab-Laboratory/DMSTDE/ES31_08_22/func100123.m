function H=func100123(gammaL)
global EI L m
global k1 k2

gamma=gammaL/L;
h1=k1/(gamma^3*EI);
h2=k2/(gamma^3*EI);
%CAREFULLY IF DISCONTINUITY: 8x8 MATRIX!, INSTEAD 4x4
H=[ -1               0               1               0               0                        0                      0                               0;
   h1             -1               h1              1               0                        0                       0                               0;
   cos(gammaL)    sin(gammaL)    cosh(gammaL)   sinh(gammaL)      0                       0                       0                              0;
   0               0               0               0               1                        0                       1                               0;
  -cos(gammaL)   -sin(gammaL)    cosh(gammaL)  sinh(gammaL)        0                        0                       0                               0;
   0                0               0               0               -1                      0                       1                               0;
   0                0               0               0            -cos(gammaL)           -sin(gammaL)            cosh(gammaL)                        sinh(gammaL);
   0                0               0               0      sin(gammaL)-h2*cos(gammaL)   -cos(gammaL)-h2*sin(gammaL)  sinh(gammaL)-h2*cosh(gammaL)   cosh(gammaL)-h2*sinh(gammaL)];
end

