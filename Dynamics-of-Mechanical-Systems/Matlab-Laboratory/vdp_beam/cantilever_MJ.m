function H=cantilever_MJ(gammaL)
global EI L m 
global M J

% beam with constant section constrained by a clamp and with a mass at the right extremity
gamma=gammaL/L;
const1=J/m*gamma^3;
const2=M/m*gamma;

H=[     1            0           1            0;
        0            1           0            1;
 -cos(gammaL) -sin(gammaL) cosh(gammaL) sinh(gammaL);
  sin(gammaL) -cos(gammaL) sinh(gammaL) cosh(gammaL)];

H(3,:)=H(3,:)-const1*[-sin(gammaL) cos(gammaL) sinh(gammaL) cosh(gammaL)];
H(4,:)=H(4,:)+const2*[cos(gammaL) sin(gammaL) cosh(gammaL) sinh(gammaL)];