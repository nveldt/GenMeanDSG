load('../data/Email.mat')
A = A-diag(diag(A));
A = spones(A);

%%

addpath('../../')
n = size(A,1);
name = 'Email1005';
er = 0.01;
per = 1-er;

% For p = 1.5, this code gets stuck. An answer that can be checked to be
% within 1% of optimal can be obtained by using code similar to
% "exact_on_small_graphs.m" with tol = 1
for p = 1:0.5:5.0
    
%     try
        tic
        y = -pi;
        alpha = 1;
        runs = 1;
        timeout = 0;
        looped = 0;
        Svecs = zeros(n,1);
        Densities = [];
        
        while y < 0 
            last = y;
            F = sfo_fn_pdenalpha(A,alpha,p);
            S = sfo_min_norm_point(F,1:n);
            y = pdenalpha(A,alpha,p,S);
            pmdensity = pdensity(A,S,p);
            
            eS = zeros(n,1);
            eS(S) = 1;

            alpha = pmdensity*(1-er);
           
            % normal way to exit
            if y == last
                break
            end
          
            % started looping back on old values
            if ismember(pmdensity,Densities)
                looped = 1;
                break
            else
                Svecs = [Svecs eS];
                Densities = [Densities; pmdensity];
            end
                
            % passed maxits
            if runs > 100
                timeout = 1;
                break
            end
            
            runs = runs+1;
        end

        % check (near) optimality
        try

        alpha = pmdensity*(1+er);
        F = sfo_fn_pdenalpha(A,alpha,p);
        Scheck = sfo_min_norm_point(F,1:n);
        check = 0;
        if numel(Scheck) == 0
            check = 1;
        end
        catch
            check = 0;
        end
        timer = toc;

        save(strcat('Output/',name,'_',num2str(p),'_per_0.99_.mat'),'pmdensity','p','check','S','timer','n','looped','Svecs','Densities','y')

end
