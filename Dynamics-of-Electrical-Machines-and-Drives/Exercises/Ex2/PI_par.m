%%
% ------------------------------------------------------------------------------------------
% Exercise taken from book:
% "Introduction to Microcontroller Programming for Power Electronics Control Applications"
% M.Rossi, N.Toscani, F.Castelli Dezza, M.Mauri (2020)
% check: https://www.amazon.it/gp/product/B0933J7KNN/ref=dbs_a_def_rwt_hsch_vapi_tkin_p1_i0
% ------------------------------------------------------------------------------------------
close all
clear all
clc

% System Parameters
s=tf('s');

% Gc
Ri    = 0.025;                                           % ohm
Li    = 0.1;                                             % H
tauG  = Li/Ri;                                           % ohm x s / ohm = s
wg    = sqrt(1/(Ri^2)-1)/tauG;                           % rad/s
TaG   = 5*tauG;                                          % s
Gc    = 1/(Ri+s*Li);  

% F = L/(1+L)
TaF   = 1;                                               % s
tauF  = TaF/5;                                           % s
wc    = 1/tauF;                                          % rad/s

% constraints
sat   = 0.3; %0.5;                     % dc voltage limit

%% P (step_1 & step_2)

kp    = 0.9*(Ri+sqrt(2*Ri^2+wc^2*Li^2));                        % ohm
ki    = -wc^2*Li+wc*sqrt(2*wc^2*Li^2-kp^2+Ri^2+2*kp*Ri); 

%% PI parameters (step_3 & step_4)
% pole/zero cancellation
kp    = wc * Li;                  % ohm
ki    = wc * Ri;                  % ohm/s
Kb=(ki/kp);
%% frequency analysis
% transfer functions
Rc    = kp+ki/s;                 % R(s) - PI controller tf
Lc    = Rc*Gc;                    % L(s) - open-loop tf
Fc    = Lc/(1+Lc);               % F(s) - closed-loop tf

% bode
figure
bode(Gc)
margin(Gc)
hold all
bode(Lc)
bode(Fc)
legend({'G(s)','L(s)','F(s)'},'FontSize',15);
grid on
ylim([-100 10])
% nyquist
figure
pzmap(Lc)
grid on
xlim([-.3 .1])
ylim([-.1 .1])

% %% simulation
sim('Exercises_lesson_II.slx');               % simulink file
% sim PI_sat.slx
% sim PI_antiwind_2nd.slx

