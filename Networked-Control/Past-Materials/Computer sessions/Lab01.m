clear all 
clc
close all

%% Exercise 1

n=2;
A=[-1 0;0.2 -0.2];
B=[1;0.1];
C=[0,1];
D=0;

eigenvaluesA=eig(A);
rho=max(real(eig(A))); % spectral abscissa
Tfinal=30;
T=[0:0.01:Tfinal];
x0=[1;0];
i=0;
ubar=1;
for t=T
    i=i+1;
    yfree(i)=C*expm(A*t)*x0;
    yforced(i)=C/A*(expm(A*t)-eye(n))*B*ubar;
end

figure
hold on
grid on
title('Continuous-time responses')
plot(T,yfree,'k:','linewidth',2)
plot(T,yforced,'k--','linewidth',2)
plot(T,yfree+yforced,'k','linewidth',2)
legend('free motion','forced motion','output')
xlabel('t [s]')

xbar=-C/A*B*ubar;

yalmip clear
P=sdpvar(n);
L=[A'*P+P*A<=-eye(n)]+[P>=eye(2)];
%J=-trace(A'*P+P*A);
%J=trace(P);
result=optimize(L);
P_CT=double(P);


%% Exercise 2

h=1; % sampling time
F=expm(A*h);
G=A\(expm(A*h)-eye(n))*B;
H=C;

eigenvalues=eig(F);
rho_r=max(abs(eig(F))); % spectral radius
steps=[0:Tfinal/h]; % Tfinal/h steps with sampling time h
x0=[1;0];
i=0;
for k=steps
    i=i+1;
    yfree_D(i)=H*(F^k)*x0;
    yforced_D(i)=H/(eye(n)-F)*(eye(n)-F^k)*G*ubar;
end

figure
hold on
grid on
title('Discrete-time responses')
plot(steps*h,yfree_D,'k*','linewidth',2)
plot(steps*h,yforced_D,'k.','linewidth',2)
plot(steps*h,yfree_D+yforced_D,'ko')
legend('free motion','forced motion','output')
xlabel('t [s]')

xbar_D=H/(eye(n)-F)*G*ubar;

figure
hold on
grid on
title('Comparisons')
plot(steps*h,yfree_D,'k*')
plot(steps*h,yforced_D,'k.')
plot(steps*h,yfree_D+yforced_D,'ko')
legend('free motion','forced motion','output')
plot(T,yfree,'k:')
plot(T,yforced,'k--')
plot(T,yfree+yforced,'k')
xlabel('t [s]')

yalmip clear
P=sdpvar(n);
L=[F'*P*F-P<=-eye(n)]+[P>=eye(n)];
J=trace(P);
optimize(L,J)
P_DT=double(P)

%%

clear all 
clc
close all

%% Exercise 3

n=2;
A=[0 0;0 -1];
B=[1;1];
C=[1,1];
D=0;

eigenvaluesA=eig(A);
rho=max(real(eig(A))); % spectral abscissa
Tfinal=20;
T=[0:0.01:Tfinal];
x0=[1;0];
i=0;
ubar=1;
for t=T
    i=i+1;
    yfree(i)=C*expm(A*t)*x0;
end
systemCT=ss(A,B,C,D);
yforced=step(systemCT,T)'*ubar;

figure
hold on
grid on
title('Continuous-time responses')
plot(T,yfree,'k:')
plot(T,yforced,'k--')
plot(T,yfree+yforced,'k')
legend('free motion','forced motion','output')
xlabel('t [s]')

yalmip clear
P=sdpvar(n);
L=[A'*P+P*A<=-eye(n)]+[P>=eye(n)];
optimize(L)


%% Exercise 4

h=1; % sampling time
systemDT=c2d(systemCT,h);
[F,G,H,L]=ssdata(systemDT);

eigenvaluesA=eig(F);
rho_r=max(abs(eig(F))); % spectral radius
steps=[0:Tfinal/h]; % Tfinal/h steps with sampling time h
x0=[1;0];
i=0;
for k=steps
    i=i+1;
    yfree_D(i)=H*(F^k)*x0;
end
yforced_D=step(systemDT,steps)'*ubar;

figure
hold on
grid on
title('Discrete-time responses')
plot(steps*h,yfree_D,'k*')
plot(steps*h,yforced_D,'k.')
plot(steps*h,yfree_D+yforced_D,'ko')
legend('free motion','forced motion','output')
xlabel('t [s]')


figure
hold on
grid on
title('Comparisons')
plot(steps*h,yfree_D,'k*')
plot(steps*h,yforced_D,'k.')
plot(steps*h,yfree_D+yforced_D,'ko')
legend('free motion','forced motion','output')
plot(T,yfree,'k:')
plot(T,yforced,'k--')
plot(T,yfree+yforced,'k')
xlabel('t [s]')

yalmip clear
P=sdpvar(n);
L=[F'*P*F-P<=-eye(n)]+[P>=eye(n)];
optimize(L)