    function gammas=refine_freqs(gamma1,gamma2,tol)
global namefunc

eval(['H=' namefunc '(gamma1);']);
det1=det(H);
eval(['H=' namefunc '(gamma2);']);
det2=det(H);
dgamma=gamma2-gamma1;
    while dgamma > tol
        gammas=0.5*(gamma1+gamma2);
        eval(['H=' namefunc '(gammas);']);
        detdet=det(H);
        if det1*detdet >=0
            gamma1=gammas;
            det1=detdet;
        else
            gamma2=gammas;
            det2=detdet;
        end
        dgamma=gamma2-gamma1;
%        pause
    end
end