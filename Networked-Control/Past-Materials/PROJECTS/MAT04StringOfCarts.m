% String of carts example
% Marcello Farina, 22/10/2020

N=3;
m=[3 2 3 30 0.1];
k=[0.5 1 1 10];
h=[0.2 0.3 0.3 5];
A=zeros(N*2,N*2);
B=[];
for i=1:N
    for j=1:N
        if i==j
            Ai{i,j}=[0 1;-sum(k(1:N-1))/m(i) -sum(h(1:N-1))/m(i)];
        elseif j==i+1
            Ai{i,j}=[0 0;k(i)/m(i) h(i)/m(i)];        
        elseif j==i-1
            Ai{i,j}=[0 0;k(j)/m(i) h(j)/m(i)];
        else
            Ai{i,j}=zeros(2,2);
        end
        A((i-1)*2+1:2*i,(j-1)*2+1:2*j)=Ai{i,j};
    end
    B=blkdiag(B,[0 1/m(i)]');
end
C=eye(2*N);
