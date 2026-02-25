%% ESERCIZIO LAB02
N = 4; % Number of sub-systems
coupling = 3; %coupling factor 
h = 0.01; %sampling time

[A, B, C, F, G, H] = coupled_CSB(N, coupling, h);

%% a) compute continuos-time fixed modes
rounding_n = 3;

%Centralized
ConStruct = ones(N,N);
CFMcont = di_fixed_modes(A,B,C,N,ConStruct, rounding_n);
CFMcont

%Decentralized
ConStruct_dec = diag(ones(N,1));
CFM_deccont = di_fixed_modes(A,B,C,N,ConStruct_dec, rounding_n);
CFM_deccont

%Distrubuted
%(bidirectional star)
ConStruct_dist = [1 1 1 1
                  1 1 0 0
                  1 0 1 0
                  1 0 0 1]; 
CFM_distcont = di_fixed_modes(A,B,C,N,ConStruct_dist, rounding_n);
CFM_distcont

%% b) Compute discrete-time fixed modes
% because we don't find any fixed modes in continuos time we expect to have
% no fixed modes in discrete

%Centralized
ConStruct = ones(N,N);
CFMdT = di_fixed_modes(F,G,H,N,ConStruct, rounding_n);
CFMdT

%Decentralized
ConStruct_dec = diag(ones(N,1));
CFM_decdT = di_fixed_modes(F,G,H,N,ConStruct_dec, rounding_n);
CFM_decdT

%Distrubuted
ConStruct_dist = [1 1 1 1; 
                  1 1 0 0; 
                  1 0 1 0; 
                  1 0 0 1];
CFM_distdT = di_fixed_modes(F,G,H,N,ConStruct_dist, rounding_n);
CFM_distdT

%% c) Compute stabilizing Continuous-time control gain with LMIs
[K,rho,feas] = LMI_CT_DeDicont(A,B,C,N,ConStruct);
[K_dec,rho_dec,feas_dec] = LMI_CT_DeDicont(A,B,C,N,ConStruct_dec);
[K_dist,rho_dist,feas_dist] = LMI_CT_DeDicont(A,B,C,N,ConStruct_dist);

%% d) Compute stabilizing Discrete-time control gain with LMIs
[KdT,rhodT,feasdT] = LMI_DT_DeDicont(F,G,H,N,ConStruct);
[K_decdT,rho_decdT,feas_decdT] = LMI_DT_DeDicont(F,G,H,N,ConStruct_dec);
[K_distdT,rho_distdT,feas_distdT] = LMI_DT_DeDicont(F,G,H,N,ConStruct_dist);

%% e) Compute closed-loop system trajectories, from random initial cond
 % 