% Temperature control example
% Marcello Farina, 19/12/2018, updated on 25/10/2020

gamma_1=6.22e-4;
gamma_2=2.5e-4;
gamma_e=2.5e-4;
gamma_ol=gamma_1+gamma_2+gamma_e;

A=[-gamma_ol gamma_2 gamma_1 0
    gamma_2 -gamma_ol 0 gamma_1
    gamma_1 0 -gamma_ol gamma_2
    0 gamma_1 gamma_2 -gamma_ol];
B=eye(4);
C=eye(4);