using MAT
using DataStructures
using StatsBase
using SparseArrays

include("../src/pdensity_algorithms.jl")


snaps = ["amazon-communities","ca-AstroPhA","condmat2005A","loc-Brightkite","EmailEnronA","roadNet-CA","roadNet-TX","web-Stanford","com-Youtube","web-Google","web-BerkStan"]

Ps = [collect(0.5:0.5:2); 1.05]
for i = 1:length(snaps)
    graph = snaps[i]
    F = matread("../data/snap/standard_$graph.mat")
    A = F["A"]
    n = size(A,1)
    @assert(SparseArrays.issymmetric(A))
    Ssets = zeros(n,length(Ps))
    Times = zeros(length(Ps))
    Objectives = zeros(length(Ps))
    Sizes = zeros(length(Ps))
    EdgeDens = zeros(length(Ps))
    MeanDegree = zeros(length(Ps))
    MaxDegree = zeros(length(Ps))
    MinDegree = zeros(length(Ps))
    Mean2Degree = zeros(length(Ps))
    S, density, degeneracy, maxcore, Objs, ranking, degrees = SimplePeel(A)
    for i = 1:length(Ps)
        p = Ps[i]
        tic = time()
        S, objS, Objs, ranking = GenPeel(A,p)
        timers = time()-tic
        Times[i] = timers
        Ssets[S,i] .= 1
        Objectives[i] = maximum(Objs)
        Sizes[i] = length(S)

        As = A[S,S]
        ds = vec(sum(As,dims = 2))
        edges = sum(As)/2
        posedges = binomial(length(S),2)
        EdgeDens[i] = edges/posedges
        MeanDegree[i] = StatsBase.mean(ds)
        MaxDegree[i] = maximum(ds)
        Mean2Degree[i] = StatsBase.mean(ds.^2)
        MinDegree[i] = minimum(ds)
        println("$graph $n \t $p \t $(length(S)) \t $(StatsBase.mean(ds)) \t $(EdgeDens[i])")
    end

    matwrite("Output/$(graph)_output.mat",Dict(
    "Ps"=>Ps,"Times"=>Times,"Objectives"=>Objectives,"MinDegree"=>MinDegree,
    "Mean2Degree"=>Mean2Degree,
    "Sizes"=>Sizes,"MeanDegree"=>MeanDegree,"MaxDegree"=>MaxDegree,
    "EdgeDens"=>EdgeDens,"n"=>n,"degeneracy"=>degeneracy,"maxcore"=>maxcore))
    matwrite("Output/$(graph)_sets.mat", Dict("Ssets"=>Ssets))
end



## Get stats for the maxcore as well

for i = 1:length(snaps)
    graph = snaps[i]
    F = matread("../data/snap/standard_$graph.mat")
    A = F["A"]
    n = size(A,1)
    M = matread("Output/$(graph)_output.mat")
    S =  M["maxcore"]

    As = A[S,S]
    ds = vec(sum(As,dims = 2))
    edges = sum(As)/2
    posedges = binomial(length(S),2)
    EdgeDen = edges/posedges
    MeanDeg = StatsBase.mean(ds)
    MaxDeg = maximum(ds)
    Mean2 = StatsBase.mean(ds.^2)
    MinDeg = minimum(ds)
    stats = [length(S) EdgeDen MinDeg MeanDeg Mean2 MaxDeg]

    matwrite("Output/$(graph)_maxcore_stats.mat",Dict("stats"=>stats))

end
