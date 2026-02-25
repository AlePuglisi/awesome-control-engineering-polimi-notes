clear all
close all

%firstly we compute the relevant terms to set up the FEM Model analysis
f_max=20;
c=2;
E=2.06e11;
I_240=3.892e-5;
I_500=4.82e-4;
m_240=30.7;
m_500=90.7;

ome_min= 2*pi*f_max*c;
Lmax_240=sqrt(pi^2/ome_min*sqrt(E*I_240/m_240))
Lmax_500=sqrt(pi^2/ome_min*sqrt(E*I_500/m_500))

%upload the FE model matrices:
load("C:\Users\rubbe\OneDrive\Desktop\yearwork\FEM_Structure_mkr.mat");
%Matrix patrtititon :
%having 2 clamps, the last 6 terms correspond to constrained displacement
ndoc=12;
ndof=size(M);ndof=ndof(1)-ndoc;
MFF=M(1:ndof,1:ndof);
CFF=R(1:ndof,1:ndof);
KFF=K(1:ndof,1:ndof);

MFC=M(1:ndof,ndof+1:ndof+ndoc);
CFC=R(1:ndof,ndof+1:ndof+ndoc);
KFC=K(1:ndof,ndof+1:ndof+ndoc);

MCF=M(ndof+1:ndof+ndoc,1:ndof);
CCF=R(ndof+1:ndof+ndoc,1:ndof);
KCF=K(ndof+1:ndof+ndoc,1:ndof);

MCC=M(ndof+1:ndof+ndoc,ndof+1:ndof+ndoc);
CCC=R(ndof+1:ndof+ndoc,ndof+1:ndof+ndoc);
KCC=K(ndof+1:ndof+ndoc,ndof+1:ndof+ndoc);

%than i solve the problem as usal when I am interested on finding the
%constrain forces taking as input contrain displacement.
% natural frequencies and modes of vibration
[eigenvectors eigenvalues]=eig(MFF\KFF);
freq=sqrt(diag(eigenvalues))/2/pi;
eigenvectors;
%FRF
i=sqrt(-1);
vett_f=[0:0.01:20];
y0=[0 0 0 0 0 0 1 0 0 1 0 0]'; %horizontal displacement on both clamps
for k=1:length(vett_f)
    ome=vett_f(k)*2*pi;
    A=-ome^2*MFF+i*ome*CFF+KFF;
    Q0FC=-(-ome^2*MFC+i*ome*CFC+KFC)*y0;
    x=A\Q0FC; 
    Reaction_F=(-ome^2*MCF+i*ome*CCF+KCF)*x+(-ome^2*MCC+i*ome*CCC+KCC)*y0;
    HL=Reaction_F(7); %horizontal reaction on left pillar base 
    ML=Reaction_F(9); %clamping moment on left pillar base
    mod1(k)=abs(HL); fas1(k)=angle(HL);
    mod2(k)=abs(ML); fas2(k)=angle(ML);
end

figure(1)
subplot 211;plot(vett_f,mod1);grid;title('H_{Left Pillar}/y0 (FRF of horizontal reaction force)');
xlabel('Freq. [Hz]');subplot 212;plot(vett_f,fas1);grid;xlabel('Freq. [Hz]');

figure(2)
subplot 211;plot(vett_f,mod2);grid;title('M_{Left Pillar}/y0 (FRF of calmping moment)');
xlabel('Freq. [Hz]');subplot 212;plot(vett_f,fas2);grid;xlabel('Freq. [Hz]');


%POINT 5
% t=[0:1e-3:1.5];
% T=0.3;
% f=1/T;
% ome=2*pi/T;
% Wmax=1000;
% W=1000*sawtooth(2*pi/T*(t+T/4),1/2);
% k_max=floor(f_max/f);
% f_input=0;
% for k=1:k_max
%     b(k)=2/T*(-1000/0.075*(H(-0.075,k,ome)-H(-0.15,k,ome)+H(0.15,k,ome)-H(0.075,k,ome)-H(0.075,k,ome)+H(-0.075,k,ome))+ ...
%         2000*(L(0.15,k,ome)-L(0.075,k,ome)-L(-0.075,k,ome)+L(-0.15,k,ome)));
%     f_input=b(k)*sin(k*ome*t)+f_input;
% end
% figure(3)
% plot(t,W,t,f_input); grid;legend("real signal","fourier approx")
% 
% %than to ocmpute the time history:
% dofy_D=idb(1,2); %identify node (1=D) and dof (y=2)
% Vect_F=zeros(ndof,1);
% yD=0;
% yDdd=0;
% for k=1:k_max
%     omek = ome*k;
%     Vect_F(dofy_D)=b(k)*exp(-i*pi/2); %sinusoidal input of amplitude bk
%     A=-omek^2*MFF+i*omek*CFF+KFF;
%     x0=A\Vect_F;
%     yD=yD+abs(x0(dofy_D))*cos(omek*t+angle(x0(dofy_D)));
%     x0dd=-omek^2*x0;
%     yDdd=yDdd+abs(x0dd(dofy_D))*cos(omek*t+angle(x0dd(dofy_D))); 
% end
% figure(4)
% plot(t,yD); grid; title('yD(t) for triangular periodic signal applyed on D');
% figure(5)
% plot(t,yDdd); grid; title('ayD(t) for triangular periodic signal applyed on D');
% 
% %RESONANCE RESEARCH:
% f=[0:0.01:20];
% F=zeros(ndof,1);F(dofy_D)=1;
% for k=1:length(f)
%     ome=f(k)*2*pi;
%     A=-ome^2*MFF+i*ome*CFF+KFF;
%     x0=A\F;
%     yD=x0(dofy_D);
%     mod1(k)=abs(yD); 
%     fas1(k)=angle(yD);
% end
% figure(6)
% subplot 211;plot(vett_f,mod1);grid;title('FRF yD/fyD');
% xlabel('Freq. [Hz]');subplot 212;plot(vett_f,fas1);grid;xlabel('Freq. [Hz]');
% 
% %POINT 6
% e=5e3;
% m=5;
% i=sqrt(-1);
% f=[0:0.01:20];
% F=zeros(ndof,1);
% dof_xA=idb(7,1); % A = node 7
% dof_yA=idb(7,2);
% dof_xB=idb(2,1); % B = node 2
% dof_yB=idb(2,2);
% dof_xC=idb(17,1); % C = node 17
% dof_yC=idb(17,2);
% 
% for k=1:length(f)
%     ome=2*pi*f(k);
%     A=-ome^2*MFF+i*ome*CFF+KFF;
%     F(dof_xA)=e*m*ome^2;
%     F(dof_yA)=e*m*ome^2*exp(-i*pi/2);
%     x0=A\F;
%     xb=x0(dof_xB); xbdd=-ome^2*xb;
%     yb=x0(dof_yB); ybdd=-ome^2*yb;
%     xc=x0(dof_xC); xcdd=-ome^2*xc;
%     yc=x0(dof_yC); ycdd=-ome^2*yc;
% 
%     mod1(k)=abs(xbdd); fas1(k)=angle(xbdd);
%     mod2(k)=abs(ybdd); fas2(k)=angle(ybdd);
%     mod3(k)=abs(xcdd); fas3(k)=angle(xcdd);
%     mod4(k)=abs(ycdd); fas4(k)=angle(ycdd);
% end
% figure(7)
% subplot 211;plot(vett_f,mod1);grid;title('FRF x_Bdd/F_A');
% xlabel('Freq. [Hz]');subplot 212;plot(vett_f,fas1);grid;xlabel('Freq. [Hz]');
% figure(8)
% subplot 211;plot(vett_f,mod2);grid;title('FRF y_Bdd/F_A');
% xlabel('Freq. [Hz]');subplot 212;plot(vett_f,fas2);grid;xlabel('Freq. [Hz]')
% figure(9)
% subplot 211;plot(vett_f,mod3);grid;title('FRF x_Cdd/F_A');
% xlabel('Freq. [Hz]');subplot 212;plot(vett_f,fas3);grid;xlabel('Freq. [Hz]')
% figure(10)
% subplot 211;plot(vett_f,mod4);grid;title('FRF y_Cdd/F_A');
% xlabel('Freq. [Hz]');subplot 212;plot(vett_f,fas4);grid;xlabel('Freq. [Hz]')
% 
% 
% %function to handle bk evaluation
% function h = H(t,k,ome)
%     h=-t/(k*ome)*cos(k*ome*t)+sin(k*ome*t)/(k*ome)^2;
% end
% function l = L(t,k,ome)
%     l=-cos(k*ome*t)/(k*ome);
% end
% 
% 
% 
