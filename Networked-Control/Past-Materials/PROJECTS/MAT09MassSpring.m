% mass spring system
% Marcello Farina, 19/12/2019, modified on 25/10/2020

m=1;
M=10;
alpha=2;
beta=2;

A =[0 1 0 0 0 0
    -(alpha+beta)/m 0 alpha/m 0 beta/m 0
    0 0 0 1 0 0
    alpha/M 0 -2*alpha/M 0 alpha/M 0
    0 0 0 0 0 1
    beta/m 0 alpha/m 0 -(alpha+beta)/m 0];
         
B=[[0 -1/m 0 0 0 0]',[0 0 0 1/M 0 0]',[0 0 0 0 0 -1/m]'];
C=eye(6);      
     