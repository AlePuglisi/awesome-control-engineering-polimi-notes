%% PARAMETERS

q = 100;          % q:	liquid volumetric flow rate         [L/min]
V = 100;          % V:	tank's capacity                     [L]
ko = 7.2*10^10;   % ko:	constant                            [1/min]
ER = 8750;        % E/R: 	constant                        [K]
Tf = 350;         % Tf:	temperature at the inlet            [K]
DH = -5*10^4;     % DH:   tank's specific entalpy           [J/mol]
r = 1000;         % r:	density of the liquid               [g/L]
cp = 0.239;       % cp:	specific heat of the liquid 	    [J/gK]
UA = 5*10^4;      % UA:	heat exchange coefficient           [J/minK]

%% 1) Computation of the equilibrium
T_bar = 350;    % Desired temperature in the tank
c_bar = 0.5;    % Desired concentration

% cf_bar = ...;
% Tc_bar = ...;



%% Check the trajectories using pplane
% pplane10b



%% 2) Linearization of the system

% A = ...
% B = ...
% C = ...
% D = ...

% Open-loop transfer function 
% G_ol = ...

% Is it stable?
% eig_ol = ...



%% 3a) PI + PP design
% Check Pole Placement's conditions

% Compute the Pole Placement gain
% Kpp = ...

% Find the transfer function of the Linearized System in closed loop with the Pole Placement law
% Hint: notice its structure
% G_cl = ...




%% 3b) Compare the open-loop Singular Values to the closed-loop ones
% Use function `sigma` to plot the singular values



%% 3c) Design the outer PI regulators for performances




%% Implement the Control Scheme (3) in Simulink




%% 4a) Augment the linearized system with integrators
% Verify the conditions under which the system can be enlarged with integrators

% A_tilde = ...
% B_tilde = ...



%% 4b) Compute the Pole Placement control law for the enlarged system

% Ken = ...

%% Implement the Control Scheme (4) in Simulink




