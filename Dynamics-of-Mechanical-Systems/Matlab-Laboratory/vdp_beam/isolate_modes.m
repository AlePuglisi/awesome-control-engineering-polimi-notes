function ii=isolate_modes(gammaLvet)
global namefunc

for k=1:length(gammaLvet)
    gammaL=gammaLvet(k);
    eval(['H=' namefunc '(gammaL);']);
    detvet(k)=det(H);
end

dd=1;
signdet=detvet(dd+2:end).*detvet(dd+1:end-1);
ii=find(signdet<=0)+dd;

figure(1)
subplot(211)
plot(gammaLvet,detvet,0.5*(gammaLvet(ii)+gammaLvet(ii+1)),0.5*(detvet(ii)+detvet(ii+1)),'ro');grid
subplot(212)
plot(gammaLvet,log(abs(detvet)));grid

% figure(2)
% plot(gammaLvet,detvet);grid
% hold on

end