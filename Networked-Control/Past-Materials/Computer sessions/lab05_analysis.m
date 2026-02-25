function lab05_analysis(K,h,tau_dropout,AnalysisType)
% Analysis of the cart-stick balancer NCS 
% Inputs:
% - K: output feedback static control gain;
% - h: sampling time
% - tau_dropout: delay in the case of dropouts
% - AnalysisType:
% -- 0: all
% -- 1: spectral radius of the NCS in absence of delays and packet dropouts
% -- 2: maximum allowed constant delay
% -- 3: maximum allowed variable delay
% -- 4: maximal allowable deterministic dropout rate with a constant delay tau_dropout
% -- 5: maximal allowable stochastic dropout probability with a constant delay tau_dropout

% continuous-time system dynamics of the cart-stick balancer
A=[0 1 0; 31.33 0 0.016;-31.33 0 -0.216];
B=[0;-0.649;8.649];
C=[70      30     0.1];


% Discrete-time system with uniform sampling rate

F=expm(A*h);
G=A\(expm(A*h)-eye(3))*B;
H=C;

np=size(C,1)+size(C,2);

% closed loop system matrix
F_CL=F+G*K*H;
rho_FCL=max(abs(eig(F_CL)));

taumin=0*h;
if (AnalysisType==0)||(AnalysisType==2)
    % compute numerically the maximum allowed constant delay
    flag=0;
    tauv=h*[1:-0.01:0];
    i=0;
    while flag==0
        i=i+1;
        tau=tauv(i);
        Phi=Phi_build(A,B,C,K,h,tau,1);
        if max(abs(eig(Phi)))<1
            flag=1;
        end
    end
    taumax_const=tau;
end

if (AnalysisType==0)||(AnalysisType==3)
    % compute numerically taumax in case of time-varying delays
    flag=0;
    taumaxv=h*[1:-0.01:0];
    ngrid=10;
    i=0;
    taumax=h;
    while (flag==0)&&(taumax~=taumin+0.01*h)
        i=i+1;
        taumax=taumaxv(i);
        tauv=[taumin:(taumax-taumin)/ngrid:taumax];
        yalmip clear
        P=sdpvar(np);
        L=[P>=1e-8*eye(np)];
        for igrid=1:ngrid+1
            tau=tauv(igrid);
            Phi=Phi_build(A,B,C,K,h,tau,1);
            L=L+[Phi'*P*Phi-P<=-0.001*eye(np)];
        end
        prob3=optimize(L);
        if prob3.problem==0
            flag=1;
        end
        P=double(P);
    end
    taumax_var=taumax;
end

if (AnalysisType==0)||(AnalysisType>=4)
    
    % Dropouts
    tau=tau_dropout;
    Phi0=Phi_build(A,B,C,K,h,tau,0);
    Phi1=Phi_build(A,B,C,K,h,tau,1);
    
    if (AnalysisType==4)||(AnalysisType==0)
        
        % Deterministic dropouts
        sp0=max(abs(eig(Phi0)));
        sp1=max(abs(eig(Phi1)));
        d1=(1-sp1^2)/100;
        beta1v=[sp1^2:d1:1];
        feasibility=0;
        counter=1;
        beta1=beta1v(counter);
        while (feasibility==0)&&(beta1<1)
            yalmip clear
            P=sdpvar(np);
            L=[P>=1e-8*eye(np)];
            L=L+[Phi1'*P*Phi1-beta1*P<=0];
            diagnostics_prob=optimize(L);
            if diagnostics_prob.problem==0
                feasibility=1;
                Ps=double(P);
            else
                counter=counter+1;
                beta1=beta1v(counter);
            end
        end
        
        if feasibility==1
            beta1min=beta1;
            beta0=sdpvar(1,1);
            J=beta0;
            L0=[beta0>=0]+[Phi0'*Ps*Phi0<=beta0*Ps];
            optimize(L0);
            beta0bar=double(beta0);
            rbar=1/(1-log(beta0bar)/log(beta1min));
        end
        
        if feasibility==1
            beta0max=beta0bar;
            d2=(1-beta1min)/20;
            beta1v2= [beta1min:d2:1-d2];
            d0=(beta0max-sp0^2)/20;
            beta0v= [sp0^2:d0:beta0max+d0];
            i=0;
            yalmip clear
            for beta1=beta1v2
                i=i+1;
                j=1;
                feasibility=0;
                beta0=beta0v(j);
                while (beta0<=beta0max)&&(feasibility==0)
                    P=sdpvar(np);
                    L=[P>=1e-8*eye(np)]+[Phi0'*P*Phi0<=beta0*P]+[Phi1'*P*Phi1<=beta1*P];
                    diagnostics_prob=optimize(L);
                    if diagnostics_prob.problem==0
                        feasibility=1;
                        betapair(:,i)=[beta0;beta1];
                    else
                        j=j+1;
                        beta0=beta0v(j);
                    end
                end
            end
            for i=1:size(betapair,2)
                r(i)=1/(1-log(betapair(1,i))/log(betapair(2,i)));
            end
            rbar=max(r);
        end
    end
    if (AnalysisType==0)||(AnalysisType==5)
        % Stochastic dropouts
        pv=[0:0.01:1.01];
        feasibility=1;
        cont=0;
        p=0;
        while (p<=1)&&feasibility==1
            yalmip clear
            cont=cont+1;
            p=pv(cont);
            Z=sdpvar(np);
            L=[[Z sqrt(p)*(Phi0*Z)' sqrt(1-p)*(Phi1*Z)'
                sqrt(p)*(Phi0*Z) Z zeros(np,np)
                sqrt(1-p)*(Phi1*Z) zeros(np,np) Z]>=1e-8]+[Z>=1e-8*eye(np,np)];
            diagnostics_prob=optimize(L);
            if diagnostics_prob.problem~=0
                feasibility=0;
            end
        end
        pbar=p;
    end
end
clc
if (AnalysisType==0)||(AnalysisType==1)
    disp(['In absence of delays and packet dropouts, the transition matrix has spectral radius ',num2str(rho_FCL)])
end
if (AnalysisType==0)||(AnalysisType==2)
    disp(['The maximum allowed constant delay is ',num2str(taumax_const)])
end
if (AnalysisType==0)||(AnalysisType==3)
    disp(['The maximum allowed variable delay is ',num2str(taumax_var)])
end
if (AnalysisType==0)||(AnalysisType==4)
    disp(['With a constant delay of ',num2str(tau),' s, the - computed -  maximal allowable deterministic dropout rate is ',num2str(rbar)])
end
if (AnalysisType==0)||(AnalysisType==5)
    disp(['With a constant delay of ',num2str(tau),' s, the - computed -  maximal allowable stochastic dropout probability is ',num2str(pbar)])
end
