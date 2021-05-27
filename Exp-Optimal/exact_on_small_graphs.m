
graphs = {'KarateA','lesmisA','dolphinsA','polbooksA','adjnounA','footballA','jazzA','Netscience'};
addpath('../include/SFO/sfo')
for i = 1:7 %numel(graphs)
    
    name = graphs{i};

    load(strcat('../data/',name,'.mat'))
    addpath('../../')
    n = size(A,1);
    if ~issymmetric(A)
        continue
    end

    tol = 0.1;
    for p = 1.0:.5:5

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
                pmdensity = pdensity(A,S,p); % density measure without raising to power (1/p)

                eS = zeros(n,1);
                eS(S) = 1;

                alpha = pmdensity-tol;

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

            end

            % check (near) optimality
            alpha = pmdensity+tol;
            F = sfo_fn_pdenalpha(A,alpha,p);
            Scheck = sfo_min_norm_point(F,1:n);
            check = 0;
            if numel(Scheck) == 0
                check = 1;
            end
            timer = toc;

            % Save results
            save(strcat('Exact_Solutions/',name,'_',num2str(p),'_',num2str(tol),'.mat'),'pmdensity','p','check','S','timer','n','looped','Svecs','Densities','y')

    end
end