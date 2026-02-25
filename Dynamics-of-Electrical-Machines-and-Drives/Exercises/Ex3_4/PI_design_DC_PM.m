
% ------------------------------------------------------------------------------------------
% Exercise taken from book:
% "Introduction to Microcontroller Programming for Power Electronics Control Applications"
% M.Rossi, N.Toscani, F.Castelli Dezza, M.Mauri (2020)
% check: https://www.amazon.it/gp/product/B0933J7KNN/ref=dbs_a_def_rwt_hsch_vapi_tkin_p1_i0
% ------------------------------------------------------------------------------------------

%% PM DC Motor Control
clear all
close all
clc

%% Systema data
Ra = 0.6;
La = 0.002;
J = 6e-5;
B = 0.01;
Ke = 0.04;
K=Ke;
Le = 0;
Re = 0;

%% Transfer function
s=tf('s');
Gc=1/(Ra+s*La); % or tf(1, [La Ra]);
tauGc=La/Ra;
TaGc=5*tauGc;
Gm=1/(B+s*J);
tauGm=J/B;
TaGm=5*tauGm;

%% Anti-windup for PI blocks with back-calculation
kb_speed=1/tauGm;
kb_curr=1/tauGc;

%% System transfer functions check 
figure
subplot 121
bode(Gc)
grid on
subplot 122
bode(Gm)
grid on

%% Possible solution 1: zero/pole cancellation. We assure a phase margin of 90°

% current controller Rc
Tad=TaGc/10;
wi = 5/Tad;

kp_curr = wi*La;
ki_curr = wi*Ra;

Rc=kp_curr+ki_curr/s;

% speed controller Rw
ws = wi/10;

kp_speed = ws*J;
ki_speed = ws*B;

Rw=kp_curr+ki_curr/s;

%% Possibile solution 2: pidtune matlab function. We can manuallt set the phase margin that we want.

%PI_tuning_pidtool
phase_m = 80;
opt = pidtuneOptions('PhaseMargin',phase_m);

Ccurr = pidtune(Gc,'pi',wi,opt);
Cspeed = pidtune(Gm,'pi',ws,opt);

kp_speed=Cspeed.Kp;
ki_speed=Cspeed.Ki;
kp_curr =Ccurr.Kp;
ki_curr =Ccurr.Ki;
