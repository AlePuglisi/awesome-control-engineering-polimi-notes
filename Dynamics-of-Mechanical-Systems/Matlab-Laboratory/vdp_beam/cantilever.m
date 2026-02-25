function H=cantilever(gammaL)
%global EI L m 

% cantilever beam with uniform section 
H=[     1            0           1            0;
        0            1           0            1;
 -cos(gammaL) -sin(gammaL) cosh(gammaL) sinh(gammaL);
  sin(gammaL) -cos(gammaL) sinh(gammaL) cosh(gammaL)];