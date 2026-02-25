function H=clampspring(gammaL)
global EI L
global K

gamma=gammaL/L;
cc=K/EI/gamma^3;
H=[     1            0           1            0;
        0            1           0            1;
  sin(gammaL) -cos(gammaL) sinh(gammaL) cosh(gammaL);
 -cos(gammaL) -sin(gammaL) cosh(gammaL) sinh(gammaL)];
H(3,:)=H(3,:)-cc*[cos(gammaL)  sin(gammaL) cosh(gammaL) sinh(gammaL)];

end