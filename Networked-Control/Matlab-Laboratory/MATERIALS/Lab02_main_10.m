clear all
close all
clc

N=10;
%N=10;
%coupling=1;
%coupling=4;
coupling=2;
%h=0.1; %sampling time
h=0.01; %sampling time

[Atot, Bdec,Cdec,Ftot, Gdec,Hdec] = coupled_CSB(N,coupling,h);

% centralized control
ContStruc=ones(N,N);
[cfm]=di_fixed_modes(Atot,Bdec,Cdec,N,ContStruc,3);
[cfm_DT]=di_fixed_modes(Ftot,Gdec,Hdec,N,ContStruc,3);
[K_c,rho_c,feas_c]=LMI_CT_DeDicont(Atot,Bdec,Cdec,N,ContStruc);
[K_c_DT,rho_c_DT,feas_c_DT]=LMI_DT_DeDicont(Ftot,Gdec,Hdec,N,ContStruc);

% decentralized control
ContStruc=diag(ones(N,1));

[Dfm]=di_fixed_modes(Atot,Bdec,Cdec,N,ContStruc,3);
[Dfm_DT]=di_fixed_modes(Ftot,Gdec,Hdec,N,ContStruc,3);
[K_De,rho_De,feas_De]=LMI_CT_DeDicont(Atot,Bdec,Cdec,N,ContStruc);
[K_De_DT,rho_De_DT,feas_De_DT]=LMI_DT_DeDicont(Ftot,Gdec,Hdec,N,ContStruc);


% distributed control (string)
ContStruc=eye(N);
for i=1:N-1
    ContStruc(i,i+1)=1;
    ContStruc(i+1,i)=1;
end

[string_fm]=di_fixed_modes(Atot,Bdec,Cdec,N,ContStruc,3);
[string_fm_DT]=di_fixed_modes(Ftot,Gdec,Hdec,N,ContStruc,3);                    
[K_string,rho_string,feas_string]=LMI_CT_DeDicont(Atot,Bdec,Cdec,N,ContStruc);
[K_string_DT,rho_string_DT,feas_string_DT]=LMI_DT_DeDicont(Ftot,Gdec,Hdec,N,ContStruc);

% distributed control (star bi)
ContStruc=eye(N);
for i=2:N
    ContStruc(1,i)=1;
    ContStruc(i,1)=1;
end

[star_fm]=di_fixed_modes(Atot,Bdec,Cdec,N,ContStruc,3);
[star_fm_DT]=di_fixed_modes(Ftot,Gdec,Hdec,N,ContStruc,3);
[K_star,rho_star,feas_star]=LMI_CT_DeDicont(Atot,Bdec,Cdec,N,ContStruc);
[K_star_DT,rho_star_DT,feas_star_DT]=LMI_DT_DeDicont(Ftot,Gdec,Hdec,N,ContStruc);


clc
disp('Results (Continuous-time):')
disp(['-  Centralized: Feasibility=',num2str(feas_c),', rho=',num2str(rho_c),', FM=',num2str(cfm),'.'])
disp(['-  Decentralized: Feasibility=',num2str(feas_De),', rho=',num2str(rho_De),', FM=',num2str(Dfm),'.'])
disp(['-  Distributed (string): Feasibility=',num2str(feas_string),', rho=',num2str(rho_string),', FM=',num2str(string_fm),'.'])
disp(['-  Distributed (star): Feasibility=',num2str(feas_star),', rho=',num2str(rho_star),', FM=',num2str(star_fm),'.'])

disp('Results (Discrete-time):')
disp(['-  Centralized: Feasibility=',num2str(feas_c_DT),', rho=',num2str(rho_c_DT),', FM=',num2str(cfm_DT),'.'])
disp(['-  Decentralized: Feasibility=',num2str(feas_De_DT),', rho=',num2str(rho_De_DT),', FM=',num2str(Dfm_DT),'.'])
disp(['-  Distributed (string): Feasibility=',num2str(feas_string_DT),', rho=',num2str(rho_string_DT),', FM=',num2str(string_fm_DT),'.'])
disp(['-  Distributed (star): Feasibility=',num2str(feas_star_DT),', rho=',num2str(rho_star_DT),', FM=',num2str(star_fm_DT),'.'])

%%%%%%%%%%%%%
%   Plots   %
%%%%%%%%%%%%%

Gtot=[];
Htot=[];
Btot=[];
Ctot=[];
for i=1:N
    Btot=[Btot,Bdec{i}];
    Ctot=[Ctot
        Cdec{i}];
    Gtot=[Gtot,Gdec{i}];
    Htot=[Htot
        Hdec{i}];
end

% simulation data
Tfinal=6;
T=[0:0.01:Tfinal];
%xi0=[1;0;0];
x0=[];
for i=1:N
    x0=[x0;randn(3,1)];
end

k=0;
for t=T
    k=k+1;
    x_c(:,k)=expm((Atot+Btot*K_c)*t)*x0;
    x_De(:,k)=expm((Atot+Btot*K_De)*t)*x0;
    x_string(:,k)=expm((Atot+Btot*K_string)*t)*x0;
    x_star(:,k)=expm((Atot+Btot*K_star)*t)*x0;
end

for k=1:Tfinal/h
    x_c_DT(:,k)=((Ftot+Gtot*K_c_DT)^k)*x0;
    x_De_DT(:,k)=((Ftot+Gtot*K_De_DT)^k)*x0;
    x_string_DT(:,k)=((Ftot+Gtot*K_string_DT)^k)*x0;
    x_star_DT(:,k)=((Ftot+Gtot*K_star_DT)^k)*x0;
end

figure
for i=1:N
    subplot(N,2,2*(i-1)+1)
    hold on
    grid on
    title(['\theta_{',num2str(i),'}'])
    plot(T,[x_c((i-1)*3+1,:)],'k')
    plot(T,[x_De((i-1)*3+1,:)],'m')
    plot(T,[x_string((i-1)*3+1,:)],'b')
    plot(T,[x_star((i-1)*3+1,:)],'r')
    axis([0 T(end) min(x0)-4 max(x0)+4])
    
    subplot(N,2,2*i)
    hold on
    grid on
    title(['\theta_{',num2str(i),'}'])
    plot([h:h:Tfinal],[x_c_DT((i-1)*3+1,:)],'k.-')
    plot([h:h:Tfinal],[x_De_DT((i-1)*3+1,:)],'m.-')
    plot([h:h:Tfinal],[x_string_DT((i-1)*3+1,:)],'b.-')
    plot([h:h:Tfinal],[x_star_DT((i-1)*3+1,:)],'r.-')
    axis([0 T(end) min(x0)-4 max(x0)+4])
end
legend('Centralized','Decentralized','Distributed (string)','Distributed (star)')
