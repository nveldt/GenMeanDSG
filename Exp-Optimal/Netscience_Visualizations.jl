include("../src/plot_helper.jl")

name = "Netscience"
P = Vector{Plots.Plot{Plots.GRBackend}}()
D = matread(homedir()*"/data/Graph-Collections/Graphs/$(name)_xy.mat")
A = D["A"]
xy = D["xy"]
f = display_graph(A,xy,.8)


## This

tol = 0.25
graph = "Netscience"

Ps = collect(1:0.5:5.0)
n = 379
V = zeros(n,length(Ps))
for j = 1:length(Ps)
    pa = Ps[j]
    if pa == floor(pa)
        pa = round(Int64,pa)
    end

    # uncomment this if you want to see how the optimal sets do
    Ms = matread("Exact_Solutions/$(graph)_$(pa)_$tol.mat")
    Svecs = Ms["Svecs"]
    S = findall(x->x>0,Svecs[:,end])
    V[S,j] .= 1
    f = display_graph(A,xy,.8)
    scatter!(f,[xy[S,1]],[xy[S,2]], color = :blue,markersize = 3, title = "p = $p")
    push!(P,f)
    savefig("Figures/$(name)_$(p).pdf")
end
