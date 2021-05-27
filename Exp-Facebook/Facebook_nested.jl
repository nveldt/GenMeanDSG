using MAT
using DataStructures
using StatsBase
f = readlines("Facebook_Sets.txt")
graphs = split(f[1])
include("../src/pdensity_algorithms.jl")


## Changes
function PRF(Target,Returned)

    if length(Returned) == 0
        pr = 0; re = 0; F1 = 0
    else
        TruePos = intersect(Returned,Target)
        pr = length(TruePos)/length(Returned)
        re = length(TruePos)/length(Target)
        F1 = 2*(pr*re)/(pr+re)

        if length(TruePos) == 0
            F1 = 0
        end
    end

    return pr, re, F1

end

function changetracker2(Sets,v)
    changes = zeros(8)
    S1 = findall(x->x>0,Sets[:,2])
    for i = 1:8
        pr, re, f1 = PRF(S1,findall(x->x>0,Sets[:,i]))
        if v == 1
            changes[i] = f1
        elseif v == 2
            changes[i] = pr
        else
            changes[i] = re
        end
    end
    return changes
end

function changetracker(Sets,v)

    changes = zeros(size(Sets,2)-1)
    for i = 2:size(Sets,2)
        pr, re, f1 = PRF(findall(x->x>0,Sets[:,i]),findall(x->x>0,Sets[:,i-1]))
        if v == 1

            changes[i-1] = f1
        elseif v == 2
            changes[i-1] = pr
        else
            changes[i-1] = re
        end
    end
    return changes
end


## insert appropriate path to datasets
pathtoFB100 = homedir()*"/data/Facebook100/"
Ps = collect(0.25:0.25:2)
for i = 1:100
    graph = graphs[i]
    F = matread(pathtoFB100*"$graph.mat")
    A = F["A"]
    n = size(A,1)
    Ssets = zeros(n,length(Ps))
    Times = zeros(length(Ps))
    for i = 1:length(Ps)
        p = Ps[i]
        tic = time()
        S, objS, Objs, ranking = GenPeel(A,p)
        timers = time()-tic
        Times[i] = timers
        Ssets[S,i] .= 1
        println("$graph \t $p \t $(length(S)) \t $objS \t $timers")
    end
    matwrite("fb_output/$(graph)_output_nested.mat",Dict("Ssets"=>Ssets,
    "Ps"=>Ps,"Times"=>Times))

end
