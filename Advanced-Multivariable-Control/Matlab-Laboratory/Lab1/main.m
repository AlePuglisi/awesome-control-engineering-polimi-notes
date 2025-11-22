clear, clc;

%% Equilibrium
g=9.81;
y1_bar = 1;
y2_bar = 0;
u_bar = g*2*(1+y1_bar)^2; %from SS representation 

% Backstepping
K = 2;      % Backstepping parameter

disp('Now run pplane10b -> Load -> "levitation_clBACK.pps"');

%% Linearization

A = [  0     1;
        g   -1];
B = [ 0;    -1/8];
C = [ 1   0];
D =  0 ;

G = tf(ss(A, B, C, D))
poles = eig(A) 

%% P controller design
Reg = -1;   % Since the gain of G(s) is negative, the first guess is to take
            % R(s) = -1, so that the dynamic gain of L(s) is positive
            
rltool(G, Reg);


Reg_P = -80.4;      % Result of Root Locus tool

disp('Now run pplane10b -> Load -> "levitation_clPROP.pps"');

%% PI controller design

s = tf('s');
Reg = -1 * (1 + 4*s) / s;   % We start from a regulator with unitary static gain,
                            % a pole in the origin (integrator) and a zero
                            % in -0.25
                            
rltool(G, Reg);

Reg_PI = -245*(s+0.25)/s ;     % Result of Root Locus tool