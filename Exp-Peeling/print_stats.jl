snaps = ["ca-AstroPhA","condmat2005A","loc-Brightkite","EmailEnronA","roadNet-CA","roadNet-TX","web-Google","web-BerkStan","amazon-communities","com-Youtube"]


SizeMat = zeros(6,10)
EdMat = zeros(6,10)
AvgMat = zeros(6,10)
Avg2Mat = zeros(6,10)
MaxMat = zeros(6,10)
RunMat = zeros(6,10)
next = 1
for i = 1:length(snaps)
    global next
    graph = snaps[i]
    F = matread("../data/snap/standard_$graph.mat")
    A = F["A"]
    n = size(A,1)
    M = matread("Output/$(graph)_output.mat")
    C = matread("Output/$(graph)_maxcore_stats.mat")
    mc_stats = C["stats"]  # [length(S) EdgeDen MinDeg MeanDeg Mean2 MaxDeg]

    Sizes = M["Sizes"]
    Times = M["Times"]
    EdgeDen = M["EdgeDens"]
    MeanDeg = M["MeanDegree"]
    Mean2 = M["Mean2Degree"]
    MaxDeg = M["MaxDegree"]
    # MinDeg = M["EdgeDens"]

    # sizes
    s = [mc_stats[1] Sizes[[1 2 5 3 4]]]
    SizeMat[:,next] = s

    # edge densities
    s = [mc_stats[2] EdgeDen[[1 2 5 3 4]]]
    EdMat[:,next] = s

    # mindeg
    # s = [mc_stats[3]; MinDeg[1; 2; 5; 3; 4]]
    # SizeMat[:,next] = s

    # mean degree
    s = [mc_stats[4] MeanDeg[[1 2 5 3 4]]]
    AvgMat[:,next] = s

    # mean 2- degree
    s = [mc_stats[5] Mean2[[1 2 5 3 4]]]
    Avg2Mat[:,next] = s

    # max degree
    s = [mc_stats[6] MaxDeg[[1 2 5 3 4]]]
    MaxMat[:,next] = s

    # time
    s = [Times[2] Times[[1 2 5 3 4]]]
    RunMat[:,next] = s

    next += 1
end



## Try printing this to a Latex Table

print("Size")
G = round.(Int64,SizeMat)
methods = ["\\emph{maxcore}", "\$p = 0.5\$", "\$p = 1.0\$", "\$p = 1.05\$" , "\$p = 1.5\$", "\$p = 2.0\$"]
for i = 1:6
        print(" & $(methods[i])")
    for j = 1:10
        print("& $(G[i,j])")
    end
    print(" \\\\")
    println("")
end

## EDensity
print("Edge Density")
G = round.(EdMat,digits = 3)
methods = ["\\emph{maxcore}", "\$p = 0.5\$", "\$p = 1.0\$", "\$p = 1.05\$" , "\$p = 1.5\$", "\$p = 2.0\$"]
for i = 1:6
        print(" & $(methods[i])")
    for j = 1:10
        print("& $(G[i,j])")
    end
    print(" \\\\")
    println("")
end

## Avg Deg
print("Avg Degree")
G = round.(AvgMat,digits = 2)
methods = ["\\emph{maxcore}", "\$p = 0.5\$", "\$p = 1.0\$", "\$p = 1.05\$" , "\$p = 1.5\$", "\$p = 2.0\$"]
for i = 1:6
        print(" & $(methods[i])")
    for j = 1:10
        print("& $(G[i,j])")
    end
    print(" \\\\")
    println("")
end

## Avg Deg 2
print("Avg")
G = round.(Avg2Mat,digits = 1)
methods = ["\\emph{maxcore}", "\$p = 0.5\$", "\$p = 1.0\$", "\$p = 1.05\$" , "\$p = 1.5\$", "\$p = 2.0\$"]
for i = 1:6
        print(" & $(methods[i])")
    for j = 1:10
        print("& $(G[i,j])")
    end
    print(" \\\\")
    println("")
end


## Max Degree
print("Max")
G = round.(Int64,MaxMat)
methods = ["\\emph{maxcore}", "\$p = 0.5\$", "\$p = 1.0\$", "\$p = 1.05\$" , "\$p = 1.5\$", "\$p = 2.0\$"]
for i = 1:6
        print(" & $(methods[i])")
    for j = 1:10
        print("& $(G[i,j])")
    end
    print(" \\\\")
    println("")
end

## Max Degree
print("Time")
G = round.(RunMat,digits = 2)
methods = ["\\emph{maxcore}", "\$p = 0.5\$", "\$p = 1.0\$", "\$p = 1.05\$" , "\$p = 1.5\$", "\$p = 2.0\$"]
for i = 1:6
        print(" & $(methods[i])")
    for j = 1:10
        print("& $(G[i,j])")
    end
    print(" \\\\")
    println("")
end



## Graph stats

snaps = ["ca-AstroPhA","condmat2005A","loc-Brightkite","EmailEnronA","roadNet-CA","roadNet-TX","web-Google","web-BerkStan","amazon-communities","com-Youtube"]
for i = 1:length(snaps)
    graph = snaps[i]
    F = matread("../data/snap/standard_$graph.mat")
    A = F["A"]
    n = size(A,1)
    m = round(Int64,sum(A/2))
    print("$n $m")
end
