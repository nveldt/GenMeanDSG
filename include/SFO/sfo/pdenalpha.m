function y = pdenalpha(A,alpha,p,S)
    As = A(S,S); 
    ds = full(sum(As,2)); 
    y = alpha*numel(S) - sum(ds.^p);
end