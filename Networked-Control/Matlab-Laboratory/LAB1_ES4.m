%EXERCISE 4:
%SYSTEM DEFINITION
A=[0, 0; 0, -1];
B=[1; 1];
C=[1 1];
D=[0];

System = ss(A,B,C,D);
%DISCRETIZATION:
h=1;
SystemDT = c2d(System,1);
[F,G,H,L,TS] = ssdata(SystemDT);

% A) Compute  the  eigenvalues  and  the  spectral  radius  of  the  system.  
% Is the system open-loop asymptotically stable?
[V,D] = eig(F);
D
rho = max(abs(eig(F)))

% B) Plot  the  free,  forced,  and  total  motions  of  the  output  of  the  system 
% starting from  the initial condition 𝑥0=[1,0]^T  and  with input 𝑢(k)=1 for all 𝑘∈ℕ


x0=[1;0];
u=1;
n=size(F,1);
t = 0:1:50;
for k=1:1:length(t) 
    y_free(k) = H*(F)^k*x0;
end
y_forced = step(SystemDT, t)*u;

figure("Name", "Free responce")
stairs(t,y_free);

figure("Name", "Forced responce")
stairs(t,y_forced);

% C) Set  up  and  solve  an  LMI  feasibility  problem  for  
% checking  the  stability of the open-loop dynamics.

yalmip clear
P = sdpvar(n);
L= [P>=eye(n)*10^-5];
L= L + [F'*P*F - P <= - eye(n)*10^-5];

optimize(L);
P=double(P)