% From Siljac book
% Marcello Farina, 19/12/2019

Atot =[0     1     0     2     0
     0     0     1     3     4
    -2    -1    -1     2     1
     4     0     0     0     1
     5     6     0    -3    -2];
         
Bdec{1}=[0 0 1 0 0]';
Bdec{2}=[0 0 0 0 1]';
    
Ctot=eye(5);
Cdec{1}=Ctot(1:3,:);
Cdec{2}=Ctot(4:5,:);
         
     
         
     