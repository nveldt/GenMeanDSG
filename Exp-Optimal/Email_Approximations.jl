# """
# For this experiment we see how well our greedy peeling approximation algorithm
# does compared to the optimal solution on smaller datasets.
#
# We first solve the objective optimally using repeated submodular minimization.
# See MATLAB code.
#
# Here we use the greedy algorithm and compare its output against the optimal.
# """
using Plots
using MAT

include("../src/pdensity_algorithms.jl")


using SparseArrays
G = matread("../data/Email.mat")
A = G["A"]
for i = 1:n
    A[i,i] = 0
end
A = dropzeros!(A)
I,J,V = findnz(A)
n = size(A,1)
A = sparse(I,J,ones(length(J)),n,n)

## now run
Ps = collect(1:0.5:5.0)
Opts = zeros(length(Ps))
for i = 1:length(Ps)
    p = Ps[i]
    if p == floor(p)
        p = round(Int64,p)
    end
    if p == 1.5
        M = matread("Exact_Solutions/Email1005_$(p)_tol_1.mat")
    else
        M = matread("Exact_Solutions/Email1005_$(p)_per_0.99.mat")
    end
    Svecs = M["Svecs"]
    check = M["check"]
    # S = round.(Int64,M["S"])          # bug in how this was saved
    S = findall(x->x>0,Svecs[:,end])
    # @show S, p
    pm = pdensityobj(A,S,p)
    timer = M["timer"]
    pmdensitybound = (M["pmdensity"]+tol)^(1/p) # upper bound we can guarantee
    Densities = (M["Densities"]*(1+0.01)).^(1/p)
    # @show pm,pmdensity, maximum(Densities)
    # @show Densities
    Opts[i] = pmdensitybound
    p = Float64(p)
    nS = length(S)
    # println("$graph \t $p \t $check \t $timer \t $pmdensity \t $nS")
end

## Run Approximation Algorithm

Ssets = zeros(n,length(Ps))
Times = zeros(length(Ps))
Ranks = zeros(n,length(Ps))
Objectives = zeros(n,length(Ps))
Pdens = zeros(length(Ps))
Approx = zeros(length(Ps))
for i = 1:length(Ps)
    p = Ps[i]
    if p == floor(p)
        p = round(Int64,p)
    end

    # compute approximate
    p = Ps[i]
    tic = time()
    S, objS, Objs, ranking = GenPeel(A,p)
    timers = time()-tic
    Times[i] = timers
    Ssets[S,i] .= 1
    Objectives[:,i] = Objs
    Ranks[:,i] = ranking
    nS = length(S)
    obj = maximum(Objs)
    Pdens[i] = obj
    println("$p \t $nS \t $obj ")

end
matwrite("Approx_Solutions/Email_output.mat",
        Dict("Ssets"=>Ssets,"Ps"=>Ps,"Pdens"=>Pdens,
        "Ranks"=>Ranks,"Times"=>Times,"Objectives"=>Objectives))


## Plot the results

# For each algorithm (which is parameterized by p), we see how well
# it does in solving different version of the objective (also parameterized by p).

M = matread("Approx_Solutions/Email_output.mat")
Ssets = M["Ssets"]
Scores = zeros(length(Ps),length(Ps))
for j = 1:length(Ps)
    pa = Ps[j]
    if pa == floor(pa)
        pa = round(Int64,pa)
    end
    # Ms = matread("Exact_Solutions/$(graph)_$(pa)_$tol.mat")
    # Svecs = Ms["Svecs"]
    # S = findall(x->x>0,Svecs[:,end])
    # pmdensity = (Ms["pmdensity"])^(1/pa)
    S = findall(x->x>0,Ssets[:,j])      # There resulting set
    for k = 1:length(Ps)
        p = Ps[k]
        # @show pdensityobj(A,S,p)
        Scores[j,k] = pdensityobj(A,S,p)/Opts[k]  # The approx ratio
    end
end


## Plot
P = plot(grid = false)
ms = 3.5

C = [1 0 0;
0 .75 0;
0 0 1;
0 .5 .5;
.5 0 .5;
1 .5 0;
0 0 0;
.75 .75 0;
0.1 0.5 0.6;
0 .75 .75;
.4 .5 .3]
for j = 1:2:length(Ps)
    pa = Ps[j]                       # The p for which the algorithm was run
    if pa == floor(pa)
        pa = round(Int64,pa)
    end
    col = color = RGBA(C[j,1],C[j,2],C[j,3],1)
    plot!(P,Ps,Scores[j,:],label = "GenPeel-$pa",markershape = :circle,
        markerstrokewidth = 0,markersize = ms,color = col, markerstrokecolor = col)
end

s1 = 300
s2 = 250
plot!(P,[1;5],[1;1], size = (s1,s2),color = :gray, legend = :bottomright,label = "", yaxis = "Approximation Guarantee", xaxis = "p")

savefig("Figures/Email_plot.pdf")
