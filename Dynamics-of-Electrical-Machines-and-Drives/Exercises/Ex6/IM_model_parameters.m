clc
clear
close all

%% IM PARAMETERS
Rs   = 0.24; 
Ls   = 59.4e-3;
Lr   = 59.1e-3;
Lm   = 57e-3;
Rr   = 0.175;
np   = 3;
n    = 6;
vsat = 380;

% additional
J   = 0.4;
B   = 0.068;  % Stima
Lks = Ls- Lm^2/Lr;

%% Plot of torque and speed from the "to workspace" in the simulink.
% if you uncomment this section, you will have to run it seprately using 
% "run section" after the run of the simulink file because the variables 
% speed and torque are saved in the workspace from simulink.

% V=220;
% 
% Lkr = Ls*(Ls*Lr - Lm^2)/Lm^2;
% Xk = 2*pi*50*Lkr;
% 
% wb=2*pi*50/np;
% 
% coppia = @(wr) 3*(Rr./((wb - wr)/wb)).*((V^2)./(((Rr./((wb - wr)/wb)).^2+(Xk)^2)*wb));
% 
% plot(speed,torque,'k',0:0.1:wb,coppia(0:0.1:wb),'r','LineWidth',1)
% grid on;
