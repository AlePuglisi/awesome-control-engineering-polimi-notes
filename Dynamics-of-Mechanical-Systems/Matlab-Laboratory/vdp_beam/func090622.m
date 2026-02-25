function  H=func090622(gammaL)
global EI L m
global M J 
global k

gamma=gammaL/L;
c1=J*gamma^3/m;
c2=k/(EI*gamma^3)-M*gamma/m;

H=[     cos(gammaL)     sin(gammaL)     cosh(gammaL)        sinh(gammaL);
        -cos(gammaL)    -sin(gammaL)      cosh(gammaL)      sinh(gammaL);
        -1              c1                  1               c1;
        c2              -1                  c2              1];
end

