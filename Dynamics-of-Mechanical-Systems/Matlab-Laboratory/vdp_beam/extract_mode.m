function coef=extract_mode(H)
    n=length(H);
    for irow=n:-1:1
        for icol=n:-1:1         
        Hrid=[H(1:irow-1,1:icol-1) H(1:irow-1,icol+1:n);H(irow+1:n,1:icol-1) H(irow+1:n,icol+1:n)];
        ratio(irow,icol)=abs(det(Hrid)/trace(H));
        end
    end            
    [val,icol]=max(max(ratio));
    [val,irow]=max(ratio(:,icol));
    Hrid=[H(1:irow-1,1:icol-1) H(1:irow-1,icol+1:n);H(irow+1:n,1:icol-1) H(irow+1:n,icol+1:n)];
    N=-[H(1:irow-1,icol);H(irow+1:n,icol)];
    x=Hrid\N;
    coef=[x(1:icol-1,1);1;x(icol:end,1)];
end