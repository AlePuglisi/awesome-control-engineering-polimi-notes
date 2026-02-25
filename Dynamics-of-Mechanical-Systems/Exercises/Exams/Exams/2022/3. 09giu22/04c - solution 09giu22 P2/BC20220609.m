function H=BC20220609(gammaL)
global EI L m 
global K M J

gamma=gammaL/L;
cc1=K/EI/gamma^3;
cc2=-M/m*gamma;
cc3=-J/m*gamma^3;


%Tema d'esame del 09/06/2022 1 tratto con corpo rigido M,J + molla K in
%x=0, appoggio in x=L
H=[  cc1+cc2        -1        cc1+cc2         1;
       -1          -cc3          1          -cc3;
  cos(gammaL)  sin(gammaL) cosh(gammaL) sinh(gammaL);
 -cos(gammaL) -sin(gammaL) cosh(gammaL) sinh(gammaL)]; %commentare questa riga e sostituirla con quella sotto per trasformare appoggio in incastro

%  -sin(gammaL)  cos(gammaL) sinh(gammaL) cosh(gammaL)];

    


