function [sys,x0] = motoresfun(t,x,u,flag)
% -------------------------
% Prof. Marco Mauri
% Ing. Mattia Rossi
% -------------------------
npoli = 6;
rif =1;
% informazioni strutturali
if flag == 0
   % [numero degli stati continui; 
   %  numero degli stati discreti
   %  numero delle uscite
   %  numero degli ingressi
   %  numero radici discontinue
   %  gestione dei loop algebrici]
   
   sys = [1;0;0;4;0;0];
   x0 = 0;
   

    
    % flag == 1 derivata degli stati continui
elseif flag == 1
    
    sys = 0;
    h = findobj('Tag','Figmotore');
    if isempty(h)
            
        
    else
     
        h1 = findobj('Tag','motore');
		Ra = pi/2 + pi/npoli;

        modulo = sqrt(u(1)^2+u(2)^2);
		fase = atan2(u(1),u(2));
        modulorot = sqrt(u(3)^2+u(4)^2);
        faserot = atan2(u(3),u(4));
               
		fasevera = fase/(npoli/2)+Ra;
		faserotvera = faserot/(npoli/2)+Ra;
        
    
        xx = (30+5*(modulo/rif)*cos(npoli/2*(0:2*pi/100:2*pi))).*cos(0+fasevera:2*pi/100:2*pi+fasevera);
        yy = (30+5*(modulo/rif)*cos(npoli/2*(0:2*pi/100:2*pi))).*sin(0+fasevera:2*pi/100:2*pi+fasevera);    
        set(findobj('Tag','Statore'),'Xdata',xx,'Ydata',yy);
            
        xx = (20+5*(modulorot/rif)*cos(npoli/2*(0:2*pi/100:2*pi))).*cos(0+faserotvera:2*pi/100:2*pi+faserotvera);
        yy = (20+5*(modulorot/rif)*cos(npoli/2*(0:2*pi/100:2*pi))).*sin(0+faserotvera:2*pi/100:2*pi+faserotvera);    
        set(findobj('Tag','Rotore'),'Xdata',xx,'Ydata',yy);
        
        set(findobj('Tag','Rs'),'Xdata',[0 40*cos(fase)],'Ydata',[0 40*sin(fase)]);
        set(findobj('Tag','Rr'),'Xdata',[0 25*cos(faserot)],'Ydata',[0 25*sin(faserot)]);
    end
%flag == 2 stato x(n+1) discreto
%flag == 3 le uscite
elseif flag == 3
    
        %pause(0.01);
        
       

end
%flag == 4 successivo istante di campionamento discreto
%flag == 5 singolarità
%flag == 9 operazioni da compiere alla fine della simualzione