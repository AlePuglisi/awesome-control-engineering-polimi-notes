%% LAB DELAY & DROPOUTS
clear 
close all
clc 

% INVERTED PENDULUM DYNAMIC
A = [0      1       0;
    31.33   0       0.016;
    -31.33  0       -0.216];
B = [0      -0.649      8.649]';
C = [70     30      0.1];

h1 = 0.1;
h2 = 0.01;

[F,G,H,L,h] = ssdata(c2d(ss(A,B,C,[]),h1));

% CLOSED LOOP ANALYSIS
%% RANGE OF K SUCH THAT F_CL STABLE
K = [0:0.1:10];
K_stable = [];
for k=K
    if abs(eig(F+G*k*H)) < 1
        K_stable = [K_stable, k];
    end
end

kmin = K_stable(1);
kmax = K_stable(length(K_stable));
disp(['DISCRETE TIME STABILITY FOR:', num2str(kmin), ' <= K <= ',num2str(kmax)]);

%% FIND Tau max such that PHI(h,Tau) ASYMP STABLE, NO DROPOUTS
K = 1;
Tau = [0:0.01:h];
Tau_stable = [];
for tau=Tau
    if abs(eig(Phi_build(A,B,C,K,h,tau,1)))<1
        Tau_stable = [Tau_stable, tau];
    end
end

tau_max = Tau_stable(length(Tau_stable));
disp(['for K=',num2str(K),' the NCS is asymptotically stable for 0 <= tau <= ', num2str(tau_max)]);

%% FOR Tau TIME_VARYING, MAX Tau SUCH THAT NCS ASYMPT STABLE, NO DROPOUTS
yalmip clear
feas = 1;
size_Phi = size(Phi_build(A,B,C,K,h,0,1));

while feas == 1
     yalmip clear
     P = sdpvar(size_Phi(1), size_Phi(2));
     L = [P >= 1e-2*eye(length(P))];
     for tau = Tau
         M = Phi_build(A,B,C,K,h,tau,1)'*P*Phi_build(A,B,C,K,h,tau,1)
         L = L+[M - P <= 1e-2*eye(length(M))];
     end
     result = optimize(L);
     feas = result.problem;
     if feas == 0
         tau_max = Tau(length(Tau));
     else
         Tau = Tau(1:(length(Tau)-1));
     end  
end

tau_max = Tau(length(Tau));
disp(['for K = ',num2str(K),' NCS with variable delay is Asympt stable fro Tau <= ',num2str(tau_max)]);

%% DROPOUTS ANALYSIS, 






