% Simulator of the cart-stick balancer NCS 
clear all
clc
close all

% continuous-time system dynamics of the cart-stick balancer
A=[0 1 0; 31.33 0 0.016;-31.33 0 -0.216];
B=[0;-0.649;8.649];
C=[70      30     0.1];

% Discrete-time system with uniform sampling rate

h=0.01;
K=10;

% h=0.1;
% K=1;

F=expm(A*h);
G=A\(expm(A*h)-eye(3))*B;
H=C;

F_CL=F+G*K*H;
disp(max(abs(eig(F_CL))))
% % initial state at time 0
x0=[1;0;0];
umax=100;
xQ=x0;

kmax=3000; % number of samples
x=x0;
for k=1:kmax
    x(:,k+1)=F_CL*x(:,k);
    xQ(:,k+1)=F*xQ(:,k)+G*umax*sign(H*xQ(:,k));
end

figure
subplot(2,1,1)
hold on
grid on
plot([0:kmax]*h,xQ(1,:),'k','linewidth',2)
plot([0:kmax]*h,x(1,:),'b','linewidth',2)
ylabel('\theta [rad]')
subplot(2,1,2)
hold on
grid on
plot([0:kmax]*h,umax*sign(C*xQ),'k','linewidth',2)
plot([0:kmax]*h,K*C*x,'b','linewidth',2)
ylabel('u')
