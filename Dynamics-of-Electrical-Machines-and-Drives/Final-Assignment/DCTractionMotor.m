%DC MOTOR for Traction, "Carelli 1928"
clc
clear 
close all

%*DATA*
Vn=600;      % Line voltage, equals to Van
eta=0.9;     % Efficiency
wn=314;      % Rated speed [rad/s]
vn=60;       % Rated speed [km/h]
tau_a=10e-3; % Armature time constant
tau_e=1;     % Excitation time constant
Ven=120;     % Excitation rated voltage
Ien=1;       % Excitation rated current
mp=80;       % Mass of std passenger
Np=200;      % Number of passengers
Mt=10000;    % Tramway mass
Dta=25;      % time of acceleration

%*MOTOR PARAMETERS DESIGN*
M=Mt+mp*Np;            % Total mass
v_max=vn*1000/3600;    % Rated speed [m/s]
a=v_max/Dta;           % acceleration
Ftrac=M*a;             % Traction force
Ptrac=Ftrac*v_max;     % Traction power
Ptot=Ptrac + Ptrac/3;  % Total power (friction power 1/3*traction)
Pel=Ptot/eta;          % Electrical power
Tn=Ptot/wn;            % Rated torque
In=Pel/Vn;             % Rated (armature) current
K=Tn/(In*Ien);         % DC machine coefficient for Torque and Emf
Ra=(Pel-Ptot)/In^2;    % Armature resistance
La=Ra*tau_a;           % Armature inductance, from time constant
En=eta*Vn;             % Rated emf, from Vn=Ra*In+En and Pel=Vn*In
Re=Ven/Ien;             % Excitation resistance
Le=Re*tau_e;           % Excitation inductance, again from time constant
J=M*v_max^2/wn^2;      % Equivalent inertia of the motor
beta=Ptrac/3/wn^2;     % Damping factor, from Tfric=Pfric/wn=beta*wn

%*CONTROL TUNING*
%TF (if we need some testing on bode diagram)
s=tf('s');
Ga = 1/(Ra + s*La);  % Armature winding tf (ia responce)
F  = 1/(beta + s*J); % mechanical load (speed responce)
Ge = 1/(Re + s*Le);  % excitation winding tf (ie response)
tauF = J/beta;       % time constant of mechanical load
%TUNING:

% Aramture current controller:
% notice,all PI tuned by cancellation, imposing the cut off frequency 
% according to our design choice and obtaining approximatively 90
% deg of phase margin!
new_tau = tau_a/5;   % make 5 times faster than electric dynamic
wc_i = 1/new_tau;     % current loop cut off frequency 
kp_a = wc_i*La;
ki_a = wc_i*Ra;
Reg_ia = kp_a + ki_a/s;

% Speed controller:
wc_o = wc_i/100;  % nested loop thumb rule, inner loop at least 10 times faster
kp_speed = wc_o*J;
ki_speed = wc_o*beta;
Reg_speed = kp_speed + ki_speed/s;

% Excitation current controller:
wc_e = wc_i/10; % make it 10 times slower than armature winding
kp_e = wc_e*Le;
ki_e= wc_e*Re;
Reg_ie = kp_e + ki_e/s;

%*CONVERSION CONSTANT*
C1=v_max/wn; %from [rad/s] to [m/s]
C2=wn/vn;  % from [km/h] to [rad/s]

%Checking Results on bode diagram
% armature current loop
figure(1)
L_ia = Ga*Reg_ia;
bode(L_ia)
title("armature current loop tf: L_{ia}(s)")
grid on
% speed loop, comparing with the "real" one
figure(2)
subplot 121
L_speed_approx = F*Reg_speed;
bode(L_speed_approx)
title("speed loop tf: L_{speed}(s)")
grid on
subplot 122
L_speed_real = F*Reg_speed*(L_ia/(1+L_ia));
bode(L_speed_real)
title("real speed loop tf: L_{speed,real}(s)")
grid on
% excitation current loop 
figure(3)
L_ie = Ge*Reg_ie;
bode(L_ie)
title("excitation current loop tf: L_{ie}(s)")
grid on




