% third practice session A.Y. 2022-2023
close all
clear all

global EI L
global K
global namefunc

% 0. parameters of the system
% Data
A=7.64*1e-4;
I=80.14*1e-8;
E=2.06e11;rho=7800;
EI=E*I;m=rho*A;
L=2;
k1=1e4;
k2=3e5;

% namefunc='simplysupported';
% namefunc='cantilever';
% namefunc='clamphinge';
% namefunc='clampspring';
% namefunc='cont_beam';
namefunc='bhotry';
K=1e4*6*EI/L^3;

% check H is a square matrix with order integer multiple of 4
eval(['H=' namefunc '(0);']);

[nr nc]=size(H);
if nr ~= nc 
    fprintf(1,'Number of rows and columns in matrix H: nr=%d, nc=%d \n',nr,nc)
    fprintf(1,'Error. H  must be a square matrix \n')
    return
end
ndom=nr/4;

if round(ndom) ~= ndom
    fprintf(1,'Number of rows in matrix H: %d \n',nr)
    fprintf(1,'Error. number of rows must be an integer multiple of 4 \n')
     return
end
fprintf(1,'Number of domains: %d \n',ndom)   

%Step 0: define frequency range for the search of natural ferquencies and modal shapes
fmax=input('Maximum frequency of the analysis [Hz] ');
gammamax=sqrt(2*pi*fmax*sqrt(m/EI));
gammaLvet=[1:1:1000]*gammamax*L/1000;

%Step 1: isolate the eigensolutions
ii=isolate_modes(gammaLvet);
nmodes=length(ii);
fprintf(1,'Number of natural frequencies found: %d \n',nmodes)
%pause

%Step 2: refine the natural frequencies
tol=1.e-5;
for imode=1:nmodes
    gamma1=gammaLvet(ii(imode)-1);
    gamma2=gammaLvet(ii(imode)+2);
    gammas=refine_freqs(gamma1,gamma2,tol);
    natfreq(imode)=1/2/pi*(gammas/L)^2*sqrt(EI/m);

    eval(['H=' namefunc '(gammas);']);
%     detdet=det(H);
%     figure(2)
%     plot(gammas,detdet,'ro')

% Step 3: extract the eigenvectors
    coef=extract_mode(H);

% Step 3b: draw the modal shape
    [x,w(imode,:),wp(imode,:),wpp(imode,:)]= modeshapes(ndom,imode,gammas,coef,natfreq(imode));
end

