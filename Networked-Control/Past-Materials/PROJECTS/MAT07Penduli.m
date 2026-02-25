% coupled penduli
% Marcello Farina, 19/12/2019, updated on 25/10/2020

k=0.02; %N/m
% k=2; %N/m
% k=200; %N/m

l=1; %m
m=1; %kg
g=9.8; %m/s2
a=l;


A=[0 1 0 0
    g/l-k*a^2/m/l^2 0 k*a^2/m/l^2 0
    0 0 0 1
    k*a^2/m/l^2 0 g/l-k*a^2/m/l^2 0];
B=[[0 1/m/l^2 0 0]',[0 0 0 1/m/l^2]'];

C=eye(4);
