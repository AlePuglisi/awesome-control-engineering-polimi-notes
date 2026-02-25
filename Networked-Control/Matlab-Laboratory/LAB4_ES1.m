clear all
close all
clc

% MODEL DEFINITION
A = [0  1   0; 31.33   0    0.016 ; -31.33   0   -0.216];
B = [0  -0.649  8.649]';
C = [70   30    0.1];
D = 0;
n = 3;

h = 0.01;
% h = 0.01;

% DISCRETIZE
F=expm(A*h);
G=A\(expm(A*h)-eye(n))*B;
H=C;

K = 1;
F_CL = (F + G*K*H);

eig(F_CL)

Tfinal = 20;
steps=[0:h:Tfinal/h]; % Tfinal/h steps with sampling time h
x0=[1;0;0];

x(:,1) = x0;
for k =1:length(steps)
    x(:,k+1) = F_CL*x(:,k);
end

figure
hold on
grid on
title('Closed loop response')
plot(steps,x(1,:)*10,'b','linewidth',2)

xlabel('t [s]')
ylabel('\theta [rad]')


