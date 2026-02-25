close all
clear all

global EI L m 
global k
global namefunc
global M J

% 0. parameters of the system
% Values below are for a beam with section IPE 80, steel material
EI = 4e5;
m = 10;
L = 2;
M = 20;
J = 0.6;
% k=0;
% namefunc='simplysupported';
% namefunc='cantilever';
% namefunc='clampspring';
% namefunc='clamphinge';
% namefunc='cont_beam';
% namefunc='ex_11_12_Nov';
% namefunc='ex_11_12_Nov_v2';
namefunc='cantilever_MJ';

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
    funct=m*w(imode,:).*w(imode,:);
    modal_mass(imode)=trapz(x,funct);
    modal_mass(imode)=modal_mass(imode)+M*w(imode,end)^2+J*wp(imode,end)^2;
    funct=EI*wpp(imode,:).*wpp(imode,:);
    modal_stiff(imode)=trapz(x,funct);
end

natfreq
natfreq2=sqrt(modal_stiff./modal_mass)/2/pi
h=ones(1,nmodes)*0.01;
c_crit=2*sqrt(modal_mass.*modal_stiff)
modal_damp=h.*c_crit;

% % modal approach 
%     F0=1;
%     vett_f=0:0.1:fmax;
%     nf=length(vett_f);
%     vett_w=zeros(1,nf);
%     i=sqrt(-1);
%     ind_input =length(x); % input: force at right end
%     ind_output=length(x); % output: displacement at right end
% 
%     for imode=1:nmodes
%         Qm=w(imode,ind_input)*F0;
%         ome=2*pi*vett_f;
%         q=Qm./(-ome.^2*modal_mass(imode)+i*ome*modal_damp(imode)+modal_stiff(imode));
%         ww=q*w(imode,ind_output);
%         figure;semilogy(vett_f,abs(ww));grid;title(['FRF mode # ' num2str(imode)]);
%         vett_w=vett_w+ww;
%     end
%     figure;semilogy(vett_f,abs(vett_w));grid;title('FRF')