function H=matrix(gammaL)
global EI L m k1 k2

gamma = gammaL/L;
cc1 = k1/(EI*gamma^3);
cc2 = k2/(EI*gamma^3);
H=[-1 0 1 0 0 0 0 0;
    cc1 -1 cc1 1 0 0 0 0;
    -cos(gammaL) -sin(gammaL) cosh(gammaL) sinh(gammaL) 0 0 0 0;
    cos(gammaL) sin(gammaL) cosh(gammaL) sinh(gammaL) 0 0 0 0;
    0 0 0 0 -1 0 1 0;
    0 0 0 0 1 0 1 0;
    0 0 0 0 -cos(gammaL) -sin(gammaL) cosh(gammaL) sinh(gammaL);
    0 0 0 0 sin(gammaL)-cc2*cos(gammaL) -cos(gammaL)-cc2*sin(gammaL) sinh(gammaL)-cc2*cosh(gammaL) cosh(gammaL)-cc2*sinh(gammaL)];

end
