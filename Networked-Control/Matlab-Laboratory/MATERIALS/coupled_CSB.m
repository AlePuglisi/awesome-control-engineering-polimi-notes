function [A,B,C,F,G,H]=coupled_CSB(N,coupling,h)
% Defines the model of N coupled (through dumpers) Cart Stick Balancers
% Inputs: 
% - N (number of subsystems)
% - coupling (coupling value, e.g., 1,2,...)
% - h (sampling time)
% Outputs:
% - A: CT system matrix
% - B: CT input matrices (i.e., B{1},..., B{N} are the input matrices of the decomposed system, one for each channel)
% - C: CT output matrices (i.e., C{1},..., C{N} are the output matrices of the decomposed system, one for each channel)
% - F: DT system matrix
% - G: DT input matrices (i.e., G{1},..., G{N} are the input matrices of the decomposed system, one for each channel)
% - H: DT output matrices (i.e., H{1},..., H{N} are the output matrices of the decomposed system, one for each channel)

% continuous-time system dynamics of a cart-stick balancer
Ai=[0 1 0; 31.33 0 0.016;-31.33 0 -0.216];
Bi=[0;-0.649;8.649];
L=abs(Ai(3,3)/Ai(2,3));

A=[];
Btot=[];
for i=1:N
    Ac=Ai;
    if (i==1)||(i==N)
        Ac(2,3)=Ai(2,3)+coupling/L;
        Ac(3,3)=Ai(3,3)-coupling;
    else
        Ac(2,3)=Ai(2,3)+2*coupling/L;
        Ac(3,3)=Ai(3,3)-2*coupling;
    end
    A=blkdiag(Ac,A);
    if i>1
        A(2,6)=-coupling/L;
        A(3,6)=coupling/L;
        A(5,3)=-coupling/L;
        A(6,3)=coupling/L;
    end
    Btot=blkdiag(Bi,Btot);
end
Ctot=eye(size(A,2));

[F,Gtot,Htot,Ltot,h]=ssdata(c2d(ss(A,Btot,Ctot,[]),h));

for i=1:N
    B{i}=Btot(:,i);
    C{i}=Ctot(3*(i-1)+1:3*i,:);
    G{i}=Gtot(:,i);
    H{i}=Htot(3*(i-1)+1:3*i,:);
end