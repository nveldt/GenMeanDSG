using MAT

snaps = ["amazon-communities","ca-AstroPhA","ca-GrQc","caHepThA","com-Youtube","condmat2005A","EmailEnronA","loc-Brightkite","web-Google","roadNet-CA","roadNet-TX","web-Stanford","web-BerkStan"]
using MatrixNetworks

for graph = snaps

    F = matread("../data/snap/$graph.mat")
    A = F["A"]

    n = size(A,1)
    for i = 1:n
        A[i,i] = 0
    end
    dropzeros!(A)
    println("$graph $n")
    A = sparse(A+A')
    I,J,V = findnz(A)
    A = sparse(I,J,ones(length(I)),n,n)

    matwrite("../data/snap/standard_$graph.mat", Dict("A"=>A))
    # A, p = largest_component(A)

    @assert(SparseArrays.issymmetric(A))
end
