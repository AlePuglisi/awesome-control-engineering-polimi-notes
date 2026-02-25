function H=func310123(gammaL)
global EI L m
global M J


gamma=gammaL/L;
c1=M*gamma/m;
c2=J*gamma^3/m;
H=[1        0           1           0           0           0           0           0;
   0        1           0           1           0           0           0           0;
   cos(gammaL)  sin(gammaL)   cosh(gammaL)   sinh(gammaL)   -1   0    -1   0;
   -sin(gammaL)  cos(gammaL)  sinh(gammaL)   cosh(gammaL)    0   -1    0   -1;
   sin(gammaL)  -cos(gammaL)  sinh(gammaL)   cosh(gammaL)    c1   1    c1  -1;
   -cos(gammaL)  -sin(gammaL)  cosh(gammaL)  sinh(gammaL)   -1   c2   1    c2;
   0          0         0           0       -cos(gammaL) -sin(gammaL)  cosh(gammaL)  sinh(gammaL);
   0          0         0           0        sin(gammaL) -cos(gammaL)  sinh(gammaL)  cosh(gammaL)];
end

