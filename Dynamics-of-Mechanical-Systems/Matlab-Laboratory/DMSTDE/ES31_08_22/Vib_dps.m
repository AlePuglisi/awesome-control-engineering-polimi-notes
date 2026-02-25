close all
clear all

%% 1. global variables

global EI L m k1 k2
global namefunc

%%  2. parameters of the system

m=10;
EI=1e5;
L=2;
k1=5e6;
k2=2e6;

namefunc='func100123';



%% 3. first section that have NOT to be modified
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

%Define frequency range for the search of natural frequencies and modal shapes
fmax=input('Maximum frequency of the analysis [Hz] ');
gammamax=sqrt(2*pi*fmax*sqrt(m/EI));
gammaLvet=[1:1:1000]*gammamax*L/1000;

% isolate the eigensolutions
ii=isolate_modes(gammaLvet);
nmodes=length(ii);
fprintf(1,'Number of natural frequencies found: %d \n',nmodes)
pause

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
    [x,w(imode,:),wp(imode,:),wpp(imode,:)]=modeshapes(ndom,imode,gammas,coef,natfreq(imode));
end

%% 4. computation of the modal mass, modal stiffness and modal damping


    ind1=1;
    ind2=length(x);
    ind_force=floor(length(x)/4)+1;

for imode=1:nmodes
    funct=m*w(imode,:).*w(imode,:);
    beam_modal_mass=trapz(x,funct);
    modal_mass(imode)=beam_modal_mass;%+ M*w(imode,ind1)^2 +J*wp(imode,ind1)^2;
    funct=EI*wpp(imode,:).*wpp(imode,:);
    modal_stiff(imode)=trapz(x,funct) + k1*w(imode,ind1)^2 +k2*w(imode,ind2)^2;
end

natfreq2=sqrt(modal_stiff./modal_mass)/2/pi
h=ones(1,nmodes)*0.01; %non dimensional damping factor goes here
c_crit=2*sqrt(modal_mass.*modal_stiff)
modal_damp=h.*c_crit;

%% 5. FRF
 
F0=1;
vett_f=0:0.1:fmax;
nf=length(vett_f);
vett_w=zeros(1,nf);
i=sqrt(-1);
for imode=1:nmodes
    Qm=w(imode,ind_force)*F0;         % input: force at centre of first beam
    ome=2*pi*vett_f; 
    q=Qm./(-ome.^2*modal_mass(imode)+i*ome*modal_damp(imode)+modal_stiff(imode));
    ww=q*w(imode,ind_force);         % output: transversal displacement at centre of left beam
    figure;semilogy(vett_f,abs(ww));grid;title(['FRF mode # ' num2str(imode)]);
    vett_w=vett_w+ww;
end
figure;semilogy(vett_f,abs(vett_w));grid;title('FRF')