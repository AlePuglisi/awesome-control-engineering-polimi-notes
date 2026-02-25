% From Siljac book
% Marcello Farina, 19/12/2019

Atot =[0 1 0 0 1 2
    2 3 2 -1 3 4
    0 0 0 1 1 0
    2 1 -1 -2 2 1
    3 0 1 5 0 1
    2 1 4 6 3 4];
         
Bdec{1}=[0 1 0 0 0 0
    0 1 0 1 0 0]';
Bdec{2}=[0 0 0 0 0 1]';
    
Ctot=eye(6);
Cdec{1}=Ctot(1:4,:);
Cdec{2}=Ctot(5:6,:);
         
     