%ESERCIZIO 1:
%SYSTEM DEFINITION
A=[-1, 0; 0.2, -0.2];
B=[1; 0.1];
C=[0 1];
D=[0];

System = ss(A,B,C,D);

% A)Compute  the  eigenvalues  and  the  spectral  abscissa  of  the  system.  
% Is the system open-loop asymptotically stable?
[V,D] = eig(A);
D % eigenvalues
rho = max(real(eig(A))) % spectral ascissa

% B)  Plot the free, forced, and total motions of the output of the system 
% starting from the initial condition 𝑥0 = [1,0]^T and with input 𝑢(𝑡) = 1 for all 𝑡 ≥ 0
x0=[1;0];
u=1;
n=size(A,1);
t = 0:0.01:50;

for i=1:length(t) 
    y_free(i) = C*expm(A*t(i))*x0;
    y_forced(i)= - C/A*(eye(n) - expm(A*t(i)))*B*u;
end

figure("Name", "Free responce")
plot(t,y_free);

figure("Name", "Forced responce")
plot(t,y_forced);

figure("Name", "overall responce")
ytot = y_free + y_forced;
plot(t,ytot);

% C) Compute the equilibrium point of the system when 𝑢(t)=1 for all
% t ≥  0
equilibrium = - C/A*B*u

% D) Set  up  and  solve  an  LMI  feasibility  
% problem  for  checking  the  stability of the open-loop dynamics.

yalmip clear
P = sdpvar(n);
L= [P>=eye(n)*10^-5];
L= L + [A'*P+P*A <= - eye(n)*10^-5];

optimize(L);
P=double(P)