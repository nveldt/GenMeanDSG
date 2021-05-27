using MAT
using DataStructures
using StatsBase
f = readlines("Facebook_Sets.txt")
graphs = split(f[1])
include("../src/pdensity_algorithms.jl")

# insert appropriate path to datasets
pathtoFB100 = homedir()*"/data/Facebook100/"

Ps = [collect(0.25:0.25:2); 1.05]
for i = 1:100
    graph = graphs[i]
    F = matread(pathtoFB100*"$graph.mat")
    A = F["A"]
    n = size(A,1)
    # Ssets = zeros(n,length(Ps))
    Times = zeros(length(Ps))
    Objectives = zeros(length(Ps))
    Sizes = zeros(length(Ps))
    EdgeDens = zeros(length(Ps))
    MeanDegree = zeros(length(Ps))
    Mean2Degree = zeros(length(Ps))
    MaxDegree = zeros(length(Ps))
    for i = 1:length(Ps)
        p = Ps[i]
        tic = time()
        S, objS, Objs, ranking = GenPeel(A,p)
        timers = time()-tic
        Times[i] = timers
        # Ssets[S,i] .= 1
        Objectives[i] = maximum(Objs)
        Sizes[i] = length(S)

        As = A[S,S]
        ds = vec(sum(As,dims = 2))
        edges = sum(As)/2
        posedges = binomial(length(S),2)
        EdgeDens[i] = edges/posedges
        MeanDegree[i] = StatsBase.mean(ds)
        Mean2Degree[i] = StatsBase.mean(ds.^2)
        mdeg = StatsBase.mean(ds)
        MaxDegree[i] = maximum(ds)

        println("$graph \t $p \t $(length(S)) \t $objS \t $timers \t $(mdeg)")
    end

    matwrite("fb_output/$(graph)_output.mat",Dict( #"Ssets"=>Ssets,
    "Ps"=>Ps,"Times"=>Times,"Objectives"=>Objectives,
    "Sizes"=>Sizes,"MeanDegree"=>MeanDegree,"Mean2Degree"=>Mean2Degree,
    "MaxDegree"=>MaxDegree,"EdgeDens"=>EdgeDens))

end
