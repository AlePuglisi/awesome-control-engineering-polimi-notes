%PROBLEM 2
close all
clear all

global EI L m 
%global M J if additional mass
global k1 k2
global namefunc

% 0. parameters of the system
% DATI
EI=1e5;
m=10;
L=2;
k1=5e5;
k2=2e6;
namefunc='func100123';

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

%Define frequency range for the search of natural ferquencies and modal shapes
fmax=input('Maximum frequency of the analysis [Hz] ');
gammamax=sqrt(2*pi*fmax*sqrt(m/EI));
gammaLvet=[1:1:1000]*gammamax*L/1000;

% isolate the eigensolutions
ii=isolate_modes(gammaLvet);
nmodes=length(ii);
fprintf(1,'Number of natural frequencies found: %d \n',nmodes)
%pause

tol=1.e-5;
modal_mass=zeros(1,nmodes);
modal_stiff=zeros(1,nmodes);

for imode=1:nmodes
% refine the eigensolutions
    gamma1=gammaLvet(ii(imode)-1);
    gamma2=gammaLvet(ii(imode)+2);
    gammas=refine_freqs(gamma1,gamma2,tol);
    natfreq(imode)=1/2/pi*(gammas/L)^2*sqrt(EI/m);

% extract the modal shape vector
    eval(['H=' namefunc '(gammas);']);
    detdet=det(H);
    figure(2)
    plot(gammas,detdet,'ro')
    coef=extract_mode(H);

% draw the modal shape function
    [x,w(imode,:),wp(imode,:),wpp(imode,:)]= modeshapes(ndom,imode,gammas,coef,natfreq(imode));
    %MODAL APPROACH
    funct=m*w(imode,:).*w(imode,:);
    modal_mass(imode)=trapz(x,funct);
    %massindex= ; where is positioned the mass on the beam
    %modal_mass(imode)=modal_mass(imode)+M*w(imode,massindex)^2+J*wp(imode,massindex)^2
    funct=EI*wpp(imode,:).*wpp(imode,:);
    modal_stiff(imode)=trapz(x,funct);
    index1=1;
    index2=length(x);
    modal_stiff(imode)=modal_stiff(imode) + k1*w(imode,index1)^2 + k2*w(imode,index2)^2;
end


natfreq
natfreq2=sqrt(modal_stiff./modal_mass)/2/pi
h=ones(1,nmodes)*0.01; %depending on dumping ratio given!
c_crit=2*sqrt(modal_mass.*modal_stiff);
modal_damp=h.*c_crit;

% modal approach 
    F0=1;
    vett_f=0:0.1:fmax;
    nf=length(vett_f);
    vett_w=zeros(1,nf);
    i=sqrt(-1);
    ind_input = floor(length(x)/4)+1; % input: where act the forcing effect 
    ind_output= ind_input; % output: where I want to measure vertical vibration

    for imode=1:nmodes
        Qm=w(imode,ind_input)*F0;
        ome=2*pi*vett_f;
        q=Qm./(-ome.^2*modal_mass(imode)+i*ome*modal_damp(imode)+modal_stiff(imode));
        ww=q*w(imode,ind_output);
        figure;semilogy(vett_f,abs(ww));grid;title(['FRF mode # ' num2str(imode)]);
        vett_w=vett_w+ww;
    end
    figure;semilogy(vett_f,abs(vett_w));grid;title('FRF')