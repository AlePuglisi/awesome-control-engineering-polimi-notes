function H=BC20220831(gammaL)
global EI L m 
global k kt

gamma=gammaL/L;
cc1=kt/EI/gamma;
cc2=k/EI/gamma^3;

%simply supported beam continuous over 2*L with central mass
H=[    -1          -cc1          1          -cc1  ;
        0           -1           0            1   ;
 -cos(gammaL) -sin(gammaL) cosh(gammaL) sinh(gammaL);       
  sin(gammaL) -cos(gammaL) sinh(gammaL) cosh(gammaL)];
H(4,:)=H(4,:)-cc2*[cos(gammaL)  sin(gammaL) cosh(gammaL) sinh(gammaL)];
