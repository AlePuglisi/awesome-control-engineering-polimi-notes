function H=func090622(gammaL)
global EI L m
global k

gamma=gammaL/L;
c=k/(EI*gamma^3);
H=[0             1              0                  1;
   c            -1              c                  1;
   -sin(gammaL)  cos(gammaL)   sinh(gammaL)     cosh(gammaL);
   cos(gammaL)  sin(gammaL)   cosh(gammaL)     sinh(gammaL)];
end

