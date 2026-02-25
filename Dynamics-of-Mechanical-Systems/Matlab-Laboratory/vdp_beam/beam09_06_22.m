% fourth practice session A.Y. 2022-2023
close all
clear all

global EI L m
global M J
global k
global namefunc

% 0. parameters of the system
% Data
EI = 4e5;
m = 10;
L=2;
M=10;
J=0.1;
k=1.e7;
% namefunc='simplysupported';
% namefunc='cantilever';
% namefunc='clamphinge';
% namefunc='clampspring';
% namefunc='cont_beam';
% namefunc='cont_beam_elastic_support';
namefunc='func090622';

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

% Step 4: compute the modal mass and modal stiffness parameters
    funct=m*w(imode,:).*w(imode,:);
% the two lines below are specific to the cantilever with lumped mass at x=L
    modal_mass(imode)=trapz(x,funct);
    index = 0;
    modal_mass(imode)=modal_mass(imode)+M*w(imode,index)^2+J*wp(imode,index)^2;

    funct=EI*wpp(imode,:).*wpp(imode,:);
    modal_stiff(imode)=trapz(x,funct);
    modal_stiff(imode)=modal_stiff(imode) + k*w(imode,index)^2;
% below additional lines to consider the effect of lumped springs might be needed, depending on the case considered

end

%check the calculation of modal mass and modal stiffness parameters by
%comparing the natural frequencies
natfreq
natfreq2=sqrt(modal_stiff./modal_mass)/2/pi

% define modal damping parameters
h=ones(1,nmodes)*0.02;
c_crit=2*sqrt(modal_mass.*modal_stiff)
modal_damp=h.*c_crit;

% compute the FRF using the modal approach
    F0=1;
    vett_f=0:0.1:fmax;
    nf=length(vett_f);
    vett_w=zeros(1,nf);
    i=sqrt(-1);
    ind_input =length(x)/2; % input: force at the half of beam
    ind_output=0; % output: displacement at half of beam

    for imode=1:nmodes
        Q0=w(imode,ind_input)*F0;
        ome=2*pi*vett_f;
        q0=Q0./(-ome.^2*modal_mass(imode)+i*ome*modal_damp(imode)+modal_stiff(imode));
        w0=q0*w(imode,ind_output);
        figure;semilogy(vett_f,abs(w0));grid;title(['FRF mode # ' num2str(imode)]);
        vett_w=vett_w+w0;
    end
    figure;semilogy(vett_f,abs(vett_w));grid;title('FRF')