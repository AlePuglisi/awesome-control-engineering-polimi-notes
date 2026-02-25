function []=dataratelimit(a,b,umin,umax,NB,h,init_point,k_end)
% Control under data rate limitation FOR SCALAR SYSTEMS dx/dt=ax+bu
% It applies the control law defined in case we operate at the rate limits.
% Inputs:
% - a: system matrix (scalar)
% - b: input matrix (scalar)
% - umin: minimum value of u
% - umax: maximum value of u
% - NB: n. of bits/packet
% - h: sampling time
% - init_point: initial condition for the simulation
% - k_end: n. of simulation samples

if umin>=umax
    disp('min must be < than umax!')
    return
end
if b<0
    disp('Warning: b<0. For consistency with the assumptions, we se b=|b|>0.')
    b=abs(b);
elseif b==0
    disp('Warning: b=0! The program will stop.')
    return
end
if (a==0)&&((umin>0)||(umax<0))
    disp('Si deve verificare umin<=0<=umax!')
    return
end

xbar=[];
ubar=[];
y=[];
u=[];
if a>0
    xv=[min(init_point,min(-3*b/a*umax,0)):0.0001:max(init_point,max(-3*b/a*umin,0))];
elseif a==0
	xv=[min(init_point,-3*b*h*umax):0.0001:max(init_point,-3*b*h*umin)];
else
    xv=[min(init_point,-3*b/abs(a)*max(abs(umax),abs(umin))):0.0001:max(init_point,3*b/abs(a)*max(abs(umax),abs(umin)))];
end

N=2^NB;
for i=1:N
    ubar(N-i+1)=umin+(i-1)/(N-1)*(umax-umin);
end

if a~=0
    f=exp(a*h);
    g=b/a*(exp(a*h)-1);
    for i=1:N-1
        xbar(i)=-b/abs(a)*umax+b/abs(a)*(umax-umin)*i/N;
    end
else
    f=1;
    g=b*h;
    for i=1:N-1
        xbar(i)=h*(-umax+(umax-umin)*i/N); %arbitrary
    end
end

t=0;
for x=xv
    t=t+1;
    if x<xbar(1)
        u(t)=ubar(1);
    end
    if N>=4
        for k=2:N-1
            if (x<xbar(k))&&(x>=xbar(k-1))
                u(t)=ubar(k);
            end
        end
    end
    if x>=xbar(N-1)
        u(t)=ubar(N);
    end
    y(t)=f*x+g*u(t);
end
figure(1)
hold on 
grid on
plot(xv,u)
hold on 
title('Selection function')
xlabel('x')
ylabel('u=s(x)')


figure(2)
hold on 
grid on
plot(xv,y,'k',xv,xv,'k--')
if a>0
    line([-b/abs(a)*umax -b/abs(a)*umax] ,[-b/abs(a)*umax -b/abs(a)*umin],'linestyle',':','linewidth',2,'Color',[0 0 0])
    line([-b/abs(a)*umax -b/abs(a)*umin] ,[-b/abs(a)*umax -b/abs(a)*umax],'linestyle',':','linewidth',2,'Color',[0 0 0])
    line([-b/abs(a)*umax -b/abs(a)*umin] ,[-b/abs(a)*umin -b/abs(a)*umin],'linestyle',':','linewidth',2,'Color',[0 0 0])
    line([-b/abs(a)*umin -b/abs(a)*umin] ,[-b/abs(a)*umax -b/abs(a)*umin],'linestyle',':','linewidth',2,'Color',[0 0 0])
%    axis([min(0,-3*b/abs(a)*umax),max(0,-3*b/abs(a)*umin),min(0,-3*b/abs(a)*umax),max(0,-3*b/abs(a)*umin)]);
end
% axis([min(0,-3*b*umax),max(0,-3*b*umin),min(0,-3*b*umax),max(0,-3*b*umin)]);


x=init_point;
u=[];
figure(2)
hold on
for t=1:k_end-1
        if x(t)<xbar(1)
        u(t)=ubar(1);
    end
    if N>=4
        for k=2:N-1
            if (x(t)<xbar(k))&&(x(t)>=xbar(k-1))
                u(t)=ubar(k);
            end
        end
    end
    if x(t)>=xbar(N-1)
        u(t)=ubar(N);
    end
    x(t+1)=f*x(t)+g*u(t);
    %pause(0.3)
    if t==1
        line([x(t),x(t)],[0,x(t+1)],'color',[1,0,0])
        plot(x(t),0,'r.')
    else
        line([x(t),x(t)],[x(t),x(t+1)],'color',[1,0,0])
        plot(x(t),x(t),'r.')
    end
    %pause(0.3)
    line([x(t),x(t+1)],[x(t+1),x(t+1)],'color',[1,0,0])
    plot(x(t),x(t+1),'r.')
end
if a>0
    axis([min(0,-3*b/abs(a)*umax),max(0,-3*b/abs(a)*umin),min(0,-3*b/abs(a)*umax),max(0,-3*b/abs(a)*umin)]);
elseif a==0
    axis([-3*b*h*umax,-3*b*umin*h,-3*b*umax*h,-3*b*umin*h]);
else
    axis([-3*b/a*umin,-3*b/a*umax,-3*b/a*umin,-3*b/a*umax]);
end

figure(3)
subplot(2,1,1)
hold on
grid on
plot((1:k_end-1)*h,u)
title('u(t)')
subplot(2,1,2)
hold on
grid on
plot((1:k_end)*h,x)
title('x(t)')

end