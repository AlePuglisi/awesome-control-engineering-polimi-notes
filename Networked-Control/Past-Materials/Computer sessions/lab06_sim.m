function lab06_sim(caseC,K,h,taumax,r,tau_dropout)
% Simulator of the cart-stick balancer NCS 
% Inputs:
% - caseC: 
% -- if caseC=1 C=[70      30     0.1] (output feedback static control);
% -- if caseC=2 C=I (state-feedback control).
% - K: 
% -- if caseC=1 K is the output feedback static control gain;
% -- if caseC=2 K are the eigenvalues of the closed-loop control system, assigned using 'place'.
% - h: sampling time
% - taumax: delay tau used in the simulation in case of constant delay, and
% maxumum delay used in the simulations in case of time-varying delay
% - r: packet dropout probability
% - tau_dropout: delay in the simulations with dropouts

% continuous-time system dynamics of the cart-stick balancer
A=[0 1 0; 31.33 0 0.016;-31.33 0 -0.216];
B=[0;-0.649;8.649];

switch caseC
    case 1
        C=[70      30     0.1];
    case 2
        C=eye(3);
end

% Discrete-time system with uniform sampling rate

F=expm(A*h);
G=A\(expm(A*h)-eye(3))*B;
H=C;

if caseC==2
    eigs_CL=K;
    K =-place(F,G,eigs_CL);
end

% delays and packet dropout rate
taumin=0*h;
Nmc=20; % montecarlo runs

% initial state at time 0 
x0=[0.2;0;0];
kmax=1000; % number of samples

% closed loop system matrix
F_CL=F+G*K*H;
tau=taumax;
Phi=Phi_build(A,B,C,K,h,tau,1);
x=x0;
z=[x0;C*x0];
for k=1:kmax
    x(:,k+1)=F_CL*x(:,k);
    z(:,k+1)=Phi*z(:,k);
end

% simulations with time-varying delays
for imc=1:Nmc
    zmc{imc}=[x0;C*x0];
    tau_v=taumin+(taumax-taumin)*rand(kmax);
    for k=1:kmax
        tau=tau_v(k);
        Phi=Phi_build(A,B,C,K,h,tau,1);
        zmc{imc}(:,k+1)=Phi*zmc{imc}(:,k);
    end
end
% 
% simulations with packet losses
tau=tau_dropout;
for imc=1:Nmc
    zpl{imc}=[x0;C*x0];
    rand_num=rand(kmax);
    for k=1:kmax
        if rand_num(k)<r
            theta=0;
        else
            theta=1;
        end
        Phi=Phi_build(A,B,C,K,h,tau,theta);
        zpl{imc}(:,k+1)=Phi*zpl{imc}(:,k);
    end
end

figure
subplot(4,1,1)
hold on
grid on
title('No delays - no dropouts')
plot([0:kmax]*h,x(1,:),'k')
ylabel('\theta [rad]')
subplot(4,1,2)
hold on
grid on
title(['Constant delay ',num2str(taumax)])
plot([0:kmax]*h,z(1,:),'k')
ylabel('\theta [rad]')
subplot(4,1,3)
hold on
grid on
title(['Variable delay in [',num2str(taumin),',',num2str(taumax),']'])
for imc=1:Nmc
    plot([0:kmax]*h,zmc{imc}(1,:),'k')
end
ylabel('\theta [rad]')
% 
subplot(4,1,4)
hold on
grid on
title(['Constant delay ',num2str(tau),' and packet dropout rate ',num2str(r)])
for imc=1:Nmc
    plot([0:kmax]*h,zpl{imc}(1,:),'k')
end
xlabel('time [s]')
ylabel('\theta [rad]')