% Formation control
% Marcello Farina, 23/10/2020

N=9;
m=[3 2 3 2 3 2 4 1 2];
h=[0.1 0.2 0.3 0.4 0.5 0.4 0.3 0.2 0.1];
adjx=[0 0 0 0 0 0 0 0 0
   1 0 0 0 0 0 0 0 0
   0 1 0 0 0 0 0 0 0
   1 0 0 0 0 0 0 0 0
   0 0 0 1 0 0 0 0 0
   0 0 0 0 1 0 0 0 0
   0 0 0 1 0 0 0 0 0
   0 0 0 0 0 0 1 0 0
   0 0 0 0 0 0 0 1 0];

adjy=[0 0 0 0 0 0 0 0 0
   1 0 0 0 0 0 0 0 0
   0 1 0 0 0 0 0 0 0
   1 0 0 0 0 0 0 0 0
   0 1 0 0 0 0 0 0 0
   0 0 1 0 0 0 0 0 0
   0 0 0 1 0 0 0 0 0
   0 0 0 0 1 0 0 0 0
   0 0 0 0 0 1 0 0 0];

A=zeros(N*4,N*4);
B=[];
for i=1:N
    for j=1:N
        if i==j
            Axi=[0 1;0 -h(i)/m(i)];
            Ayi=[0 1;0 -h(i)/m(i)];
        else
            Axi=[0 -adjx(i,j);0 0];
            Ayi=[0 -adjy(i,j);0 0];
        end
        Ac{i,j}=blkdiag(Axi,Ayi);
        A((i-1)*4+1:4*i,(j-1)*4+1:4*j)=Ac{i,j};
    end
    B=blkdiag(B,blkdiag([0 1/m(i)]',[0 1/m(i)]'));
end
C=eye(4*N);