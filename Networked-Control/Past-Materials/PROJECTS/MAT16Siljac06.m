% From Siljac book
% Marcello Farina, 19/12/2019

Atot =[0 0 0 0 0 0
    -1 0 0 0 0 0
    0 0 0 0 0 0
    0 0 -1 0 0 -1
    0 -1 0 -1 0 0
    0 0 0 0 0 -1];
         
Bdec{1}=[1 0 0 0 0 0]';
Bdec{2}=[0 0 1 0 0 1]';
Bdec{3}=[0 0 0 0 0 1]';
    
Ctot=eye(6);
Cdec{1}=Ctot(1:2,:);
Cdec{2}=Ctot(3:4,:);
Cdec{3}=Ctot(5:6,:);
         
     
         
     