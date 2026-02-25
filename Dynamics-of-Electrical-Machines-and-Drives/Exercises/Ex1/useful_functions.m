% ------------------------------------------------------------------------------------------
% Exercise taken from book:
% "Introduction to Microcontroller Programming for Power Electronics Control Applications"
% M.Rossi, N.Toscani, F.Castelli Dezza, M.Mauri (2020)
% check: https://www.amazon.it/gp/product/B0933J7KNN/ref=dbs_a_def_rwt_hsch_vapi_tkin_p1_i0
% ------------------------------------------------------------------------------------------

clear % all variables in the workspace are deleted
clc % the commands printed in the command windows are deleted

% data

R = 0.025; % [Ohm]
L = 0.1; % [H]

tau_n = L/R; % [s] natural time constant

% desired characteristics

T_A = 1; % [s] desired settling time
tau_F = T_A/5; % [s] desired time constant
wc = 1/tau_F; % [rad/s] desired bandwidth

% tf()

s = tf('s'); % definition of s in the Laplace domain
G = 1/(R+s*L); % defninition of the transfer function V-I of the system

% step()

figure
step(G) % natural step response

kpmax=R+sqrt(2*R^2+wc^2*L^2);
kp = 0.9*kpmax; % proportional gain
ki = -wc^2*L+wc*sqrt(2*wc^2*L^2-kp^2+R^2+2*kp*R); % integral gain
% 
Reg = kp+ki/s; % controller transfer function
% 
L = Reg*G;

% bode

figure
bode(G)

% margin

figure
margin(G)