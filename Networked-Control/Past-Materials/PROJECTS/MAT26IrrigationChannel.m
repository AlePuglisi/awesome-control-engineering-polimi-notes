% Irrigation channel
% Marcello Farina, 23/10/2020

N=5;
tauS=4; % min - sampling time
tau=[8 4 16 16 16]; % min - delays in continuous-time
k=tau./tauS; % delays in continuous-time
alpha=[22414,11942,43806,43806,43806]; %m^2
% remark: inputs are expressed in m^3/min

F=[];
G=[];
for i=1:5
    Gc{i}=[];
    for j=1:5
        if j==i
            Delay{i}=zeros(k(i),k(i));
            if k(i)>=2
                Delay{i}(1:end-1,2:end)=eye(k(i)-1);
            end
            Fc{i}=blkdiag([1],Delay{i});
            Fc{i}(1,2)=1;
            Gc{i}=[Gc{i};[zeros(k(i),1);tauS/alpha(i)]];
        elseif j==i-1
            Gc{i}=[Gc{i};[-tauS/alpha(j);zeros(k(j),1)]];
        else
            Gc{i}=[Gc{i};[zeros(k(j)+1,1)]];
        end
    end
    F=blkdiag(F,Fc{i});
    G=[G,Gc{i}];
end

H=eye(size(F,2));