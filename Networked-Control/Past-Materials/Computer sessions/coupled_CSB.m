function [Atot,Bdec,Cdec,Ftot, Gdec,Hdec]=coupled_CSB(N,coupling,h)
% Defines the model of N coupled (through dumpers) Cart Stick Balancers
% Inputs: 
% - N (number of subsystems)
% - coupling (coupling value, e.g., 1,2,...)
% - h (sampling time)
% Outputs:
% - Atot: CT system matrix
% - Bdec: CT input matrices (i.e., Bdec{1},..., Bdec{N} are the input matrices of the decomposed system, one for each channel)
% - Cdec: CT output matrices (i.e., Cdec{1},..., Cdec{N} are the output matrices of the decomposed system, one for each channel)
% - Ftot: DT system matrix
% - Gdec: DT input matrices (i.e., Gdec{1},..., Gdec{N} are the input matrices of the decomposed system, one for each channel)
% - Hdec: DT output matrices (i.e., Hdec{1},..., Hdec{N} are the output matrices of the decomposed system, one for each channel)

% continuous-time system dynamics of a cart-stick balancer
A=[0 1 0; 31.33 0 0.016;-31.33 0 -0.216];
B=[0;-0.649;8.649];
L=abs(A(3,3)/A(2,3));

Atot=[];
Btot=[];
for i=1:N
    Ac=A;
    if (i==1)||(i==N)
        Ac(2,3)=A(2,3)+coupling/L;
        Ac(3,3)=A(3,3)-coupling;
    else
        Ac(2,3)=A(2,3)+2*coupling/L;
        Ac(3,3)=A(3,3)-2*coupling;
    end
    Atot=blkdiag(Ac,Atot);
    if i>1
        Atot(2,6)=-coupling/L;
        Atot(3,6)=coupling/L;
        Atot(5,3)=-coupling/L;
        Atot(6,3)=coupling/L;
    end
    Btot=blkdiag(B,Btot);
end
Ctot=eye(size(Atot,2));

[Ftot,Gtot,Htot,Ltot,h]=ssdata(c2d(ss(Atot,Btot,Ctot,[]),h));

for i=1:N
    Bdec{i}=Btot(:,i);
    Cdec{i}=Ctot(3*(i-1)+1:3*i,:);
    Gdec{i}=Gtot(:,i);
    Hdec{i}=Htot(3*(i-1)+1:3*i,:);
end