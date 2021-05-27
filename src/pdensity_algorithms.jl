using DataStructures
function SimplePeel(A)
    """
    GreedyPeel with parameter p
    """
    n = size(A,1)
    d = vec(round.(Int64,sum(A,dims = 1)))
    numer = sum(d)

    zz = length(findall(x->x==0,d))
    # save graph as adjacency list
    cp = A.colptr
    row = A.rowval
    AdjList = Vector{Vector{Int64}}()
    for i = 1:n
        push!(AdjList,row[cp[i]:cp[i+1]-1])
    end

    D = MutableBinaryMinHeap(d)

    # greedily peel
    ranking = zeros(Int64,n)
    Objs = zeros(n+1)
    Objs[1] = (numer/n)
    next = 2
    denom = n-1
    degrees = zeros(Int64,n)

    # if there are zero values by chance, get rid of them
    for t = 1:zz
        deg, i = top_with_handle(D)
        pop!(D)
        Objs[next] = 0
        denom -= 1
        @assert(deg == 0)
        degrees[next] = 0
        ranking[next-1] = i
        next += 1
    end

    while ~isempty(D)
        deg, i = top_with_handle(D)
        ranking[next-1] = i
        degrees[next-1] = deg
        pop!(D)
        Ni = AdjList[i]
        di = d[i]
        if di > 0
            # Decrease the degree of all neighbors
            d[i] = 0
            for nb = Ni
                removej!(AdjList[nb],i)             # This is no longer a neighboring node, we're removed it
                update!(D,nb,D[nb]-1)  # subtract degree, update the heap
                d[nb] -= 1
            end
        end
        numer -= 2*di
        Objs[next] = numer/denom
        denom -= 1
        next +=1
    end
    Objs = Objs[1:end-1]
    density, w = findmax(Objs)
    S = ranking[w:end]
    degeneracy, w2 = findmax(degrees)
    maxcore = ranking[w2:end]

    return S, density, degeneracy, maxcore, Objs, ranking, degrees
end

function GenPeel(A,p)
    """
    GreedyPeel with parameter p
    """
    if p == 1
        S, density, degeneracy, maxcore, Objs, ranking, degrees = SimplePeel(A)
        return S, density, Objs, ranking
    end

    n = size(A,1)
    d = sum(A,dims = 1)
    numer = sum(d.^p)

    # converting to dictionary helps later
    d2 = Dict{Int64,Int64}()
    for i = 1:n
        d2[i] = d[i]
    end
    d = d2

    # save graph as adjacency list
    cp = A.colptr
    row = A.rowval
    tic = time()
    AdjList = Vector{Vector{Int64}}()
    for i = 1:n
        push!(AdjList,row[cp[i]:cp[i+1]-1])
    end

    # Create initial minheap
    D = zeros(n)
    for i = 1:n
        D[i] = d[i]^p
        for k = AdjList[i]
            D[i] += d[k]^p - (d[k]-1)^p
        end
    end
    H = MutableBinaryMinHeap(D)

    # greedily peel
    ranking = zeros(Int64,n)
    Objs = zeros(n+1)
    Objs[1] = (numer/n)^(1/p)
    next = 2
    denom = n-1
    while ~isempty(H)
        # global numer, denom,next
        v, i = top_with_handle(H)
        # push!(order,i)
        ranking[next-1] = i
        pop!(H)
        Ni = AdjList[i]
        AdjList[i] = Vector{Int64}()
        di = d[i]
        if di > 0
            dichange = di^p - (di-1)^p
            d[i] = 0
            numer -= di^p
            # Remove this from its neighbors list
            for nb = Ni
                removej!(AdjList[nb],i)             # This is no longer a neighboring node, we're removed it
                db = d[nb]
                dbchange = -db^p + (db-1)^p
                Old = H[nb]                         # previous value of D[nb]
                New = Old + dbchange - dichange     # new value now that node i is gone
                update!(H,nb,New)                   # update the heap
                # D[nb] = New
                numer += dbchange
                d[nb] -= 1                          # decrease degree
            end

            # At this point, we have made all changes due to node i disappearing.
            # Now we need to account for changes in D/H
            # that are due to changes in the degree for i's neighbors
            for b = Ni
                db = d[b]
                if db > 0
                    dbchange = 2*db^p - (db-1)^p -(db+1)^p
                    Nb = AdjList[b]
                    for k = Nb
                        update!(H,k,H[k]+dbchange)
                    end
                end
            end

        end

        # if mod(next,100) == 0
        #     println("$next $numer")
        # end
        # if numer < 0
        #     @show numer
        #     break
        # end
        numer = max(numer,0)                # there can be rounding errors at the very end
        Objs[next] = (numer/denom)^(1/p)
        denom -= 1
        next +=1
    end
    Objs = Objs[1:end-1]
    density, w = findmax(Objs)
    S = ranking[w:end]

    return S, density, Objs, ranking

end

# remove element j from vector v, assuming that j appears exactly once
function removej!(v::Vector{Int64},j)
    for i = 1:length(v)
        if v[i] == j
            # v = v[1:i-1,i+1:end]
            deleteat!(v,i)
            return
        end
    end
end

function pdensityobj(A,S,p)

    if length(S) == 0
        return 0
    else
        As = A[S,S]
        d = sum(As,dims = 1)

        return (sum(d.^p)/length(S))^(1/p)
    end

end
