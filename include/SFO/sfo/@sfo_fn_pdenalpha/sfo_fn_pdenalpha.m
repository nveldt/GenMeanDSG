% Evaluate Iwata's test function (taken from Fujishige et al '06)
% Author: Andreas Krause (krausea@gmail.com)
%
% function F = sfo_fn_iwata(n,A)
% sigma: Covariance matrix
% set: subset of variables
%
% Example: F = sfo_fn_iwata(5); F([1,2,5])

function F = sfo_fn_pdenalpha(A,alpha,p)

fn = @(S) pdenalpha(A,alpha,p,S);
F = sfo_fn_wrapper(fn);

end