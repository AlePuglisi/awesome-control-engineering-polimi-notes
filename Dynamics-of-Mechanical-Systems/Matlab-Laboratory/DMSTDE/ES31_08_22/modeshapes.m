function [x,w,wp,wpp]=modeshapes(ndom,imode,gammas,coef,natfreq)
global EI L m modalmass modalstiffness

x=[];
w=[];
wp=[];
wpp=[];
dx=0.001;
gamma=gammas/L;
for k=1:ndom
    c=coef(4*(k-1)+1:4*k,1)';
    xx=[0:dx:1]*L;
    yy=c(1)*cos(gamma*xx)+c(2)*sin(gamma*xx)+c(3)*cosh(gamma*xx)+c(4)*sinh(gamma*xx);
    yyp=gamma*(-c(1)*sin(gamma*xx)+c(2)*cos(gamma*xx)+c(3)*sinh(gamma*xx)+c(4)*cosh(gamma*xx));
    yypp=gamma^2*(-c(1)*cos(gamma*xx)-c(2)*sin(gamma*xx)+c(3)*cosh(gamma*xx)+c(4)*sinh(gamma*xx));
    xx=xx+(k-1)*L;
    x=[x xx];
    w=[w yy];
    wp=[wp yyp];
    wpp=[wpp yypp];
end
figure(imode+2)
plot(x,w);grid;title(['Mode n.: ' int2str(imode) ' Natural frequency: ' num2str(natfreq,'%0.2f') ' Hz '])
end
