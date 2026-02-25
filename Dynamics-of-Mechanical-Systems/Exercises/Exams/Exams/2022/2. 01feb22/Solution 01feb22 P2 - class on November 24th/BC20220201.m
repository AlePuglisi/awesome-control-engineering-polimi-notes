function H=BC20220201(gammaL)
global EI L m 
global k kt

% beam with constant section constrained by a clamp and connected to a linear spring
gamma=gammaL/L;
cc=k/EI/gamma^3

%Problem 2 Feb. 1st 2022
H=[     0            1           0            1            0             0            0           0;
        0           -1           0            1            0             0            0           0; 
  cos(gammaL)  sin(gammaL) cosh(gammaL) sinh(gammaL)      -1             0           -1           0;
 -sin(gammaL)  cos(gammaL) sinh(gammaL) cosh(gammaL)       0            -1            0          -1;
 -cos(gammaL) -sin(gammaL) cosh(gammaL) sinh(gammaL)       1             0           -1           0; 
  sin(gammaL) -cos(gammaL) sinh(gammaL) cosh(gammaL)     -cc             1          -cc          -1;
        0            0            0            0     -cos(gammaL) -sin(gammaL) cosh(gammaL) sinh(gammaL);
        0            0            0            0      sin(gammaL) -cos(gammaL) sinh(gammaL) cosh(gammaL)];
   pp= kt/(EI*gamma)
H(7,:)=H(7,:)+kt/(EI*gamma)*[0            0            0            0     -sin(gammaL)  cos(gammaL) sinh(gammaL) cosh(gammaL)];

    
% H=[     0            1           0            1;
%         K          -cc           K           cc;
%   cos(gammaL)  sin(gammaL) cosh(gammaL) sinh(gammaL);
%  -sin(gammaL)  cos(gammaL) sinh(gammaL) cosh(gammaL)];

end