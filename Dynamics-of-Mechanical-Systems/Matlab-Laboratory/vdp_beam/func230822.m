function H=func230822(gammaL)
global EI L m
global k kt

gamma=gammaL/L;
h1=-k/(EI*gamma^3);
h2=kt/(EI*gamma);
H=[0                        -1                                   0                                  1;
   1                        h2                                  -1                                  h2;
  -cos(gammaL)              -sin(gammaL)                     cosh(gammaL)                        sinh(gammaL);
  sin(gammaL)+h1*cos(gammaL)  -cos(gammaL)+h1*sin(gammaL)     sinh(gammaL)+h1*cosh(gammaL)       cosh(gammaL)+h1*sinh(gammaL)];
end

