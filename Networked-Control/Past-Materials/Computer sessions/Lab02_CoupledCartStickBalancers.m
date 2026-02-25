
% continuous-time system dynamics of a cart-stick balancer
A=[0 1 0; 31.33 0 0.016;-31.33 0 -0.216];
B=[0;-0.649;8.649];

L=abs(A(3,3)/A(2,3));

% Nc coupled (through dumpers) cart-stick balancers
Nc=3;
coupling=3.45;

Atot=[];
Btot=[];
for i=1:Nc
    Ac=A;
    if (i==1)||(i==Nc)
        Ac(2,3)=A(2,3)+coupling/L;
        Ac(3,3)=A(3,3)-coupling;
    else
        Ac(2,3)=A(2,3)+2*coupling/L;
        Ac(3,3)=A(3,3)-2*coupling;
    end
    Atot=blkdiag(Ac,Atot);
    if i>1
        Atot(2,6)=-coupling/L;
        Atot(3,6)=coupling/L;
        Atot(5,3)=-coupling/L;
        Atot(6,3)=coupling/L;
    end
    Btot=blkdiag(B,Btot);
end
Ctot=eye(size(Atot,2));

for i=1:Nc
    Bdec{i}=Btot(:,i);
    Cdec{i}=Ctot(3*(i-1)+1:3*i,:);
end



% centralized solution
yalmip clear
Y=[];
L=[];
Y=sdpvar(3*Nc);
L=sdpvar(Nc,3*Nc);
LMIconstr=[Y*Atot'+Atot*Y+Btot*L+L'*Btot'<-1e-2*eye(Nc*3)]+[Y>1e-2*eye(Nc*3)];
options=sdpsettings('solver','sedumi');
Jcentr=solvesdp(LMIconstr,[],options);
feasC=Jcentr.problem;
% pause
L=double(L);
Y=double(Y);

Kc=L/Y;
rhoc=max(real(eig(Atot+Btot*Kc)));
% 
% decentralized solution
yalmip clear
Y=[];
L=[];
for i=1:Nc
    Y=blkdiag(Y,sdpvar(3));
    L=blkdiag(L,sdpvar(1,3));
end
LMIconstr=[Y*Atot'+Atot*Y+Btot*L+L'*Btot'<-1e-2*eye(Nc*3)]+[Y>1e-2*eye(Nc*3)];
options=sdpsettings('solver','sedumi');
Jdec=solvesdp(LMIconstr,[],options);
feasD=Jdec.problem;
L=double(L);
Y=double(Y);

Kd=L/Y;
rhod=max(real(eig(Atot+Btot*Kd)));

% distributed solution (banded)
yalmip clear
Y=[];
L=[];
for i=1:Nc
    Y=blkdiag(Y,sdpvar(3));
    L=blkdiag(sdpvar(1,3),L);
    if i>1
        L(1,4:6)=sdpvar(1,3);
        L(2,1:3)=sdpvar(1,3);
    end
end
LMIconstr=[Y*Atot'+Atot*Y+Btot*L+L'*Btot'<-1e-2*eye(Nc*3)]+[Y>1e-2*eye(Nc*3)];
options=sdpsettings('solver','sedumi');
Jdistr=solvesdp(LMIconstr,[],options);
feasDi=Jdistr.problem;
L=double(L);
Y=double(Y);

KD=L/Y;
rhoD=max(real(eig(Atot+Btot*KD)));


% distributed (star) solution
yalmip clear
Y=[];
L=[];
for i=1:Nc
    Y=blkdiag(Y,sdpvar(3));
    L=blkdiag(sdpvar(1,3),L);
end
L(1,:)=sdpvar(1,Nc*3);
L(:,1:3)=sdpvar(Nc,3);
LMIconstr=[Y*Atot'+Atot*Y+Btot*L+L'*Btot'<-1e-2*eye(Nc*3)]+[Y>1e-2*eye(Nc*3)];
options=sdpsettings('solver','sedumi');
Jdistr2=solvesdp(LMIconstr,[],options);
feasDi2=Jdistr2.problem;
L=double(L);
Y=double(Y);

KS=L/Y;
rhoS=max(real(eig(Atot+Btot*KS)));

clc

[cfm,dfm]=fixed_modes(Atot,Bdec,Cdec,Nc);
disp('The spectral abscissae are:')
disp(['- rhoc=',num2str(rhoc),'. Feas. problem:',num2str(feasC)])
disp(['- rhod=',num2str(rhod),'. Feas. problem:',num2str(feasD)])
disp(['- rhoD=',num2str(rhoD),'. Feas. problem:',num2str(feasDi)])
disp(['- rhoS=',num2str(rhoD),'. Feas. problem:',num2str(feasDi2)])

