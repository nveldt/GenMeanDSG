f = readlines(homedir()*"/data/Facebook100/Facebook_Sets.txt")
graphs = split(f[1])

##  Try something else

C = [0.8 0 0;
0.8 0.8 0;
0 0 .8;
0 .8 .8;
.5 0 .1;
.2 .3 .1;
0 .5 0;
0 .2 .2;
0 0 1;
0.1 0.5 0.6;
0 .75 .75;
.4 .5 .3]

RGBA(.5, .6, 0,1)

RGBA(.1,.5,0,1)
nextcol = 1
Psize = plot(grid = false, legend = false)
Pmax = plot(grid = false, legend = false)
Prun = plot(grid = false)
Pdensity = plot(grid = false,legend = false)
Pmean = plot(grid = false, legend = false)
counter = 0
pathtoFB100 = homedir()*"/data/Facebook100/"

xx = Vector{Float64}()
yy = Vector{Float64}()
N = Vector{Int64}()
TheMeans = zeros(100,2)
for j = 1:100
    global counter, nextcol
    ms = 3
    lw = 1.5
    graph = graphs[j]
    F = matread(pathtoFB100*"$graph.mat")
    A = F["A"]
    n = size(A,1)
    push!(N,n)
    println("$j \t $graph $n")


    M = matread("fb_output/$(graph)_output.mat")
    Ps = M["Ps"]
    Objectives = M["Objectives"]
    Sizes = M["Sizes"]
    EdgeDens = M["EdgeDens"]
    MeanDegree = M["MeanDegree"]
    MaxDegree = M["MaxDegree"]
    Times = M["Times"]

    P = Ps[1:end-1]
    # Save mean degree scores for p = 1 and p = 1.05 solution
    TheMeans[j,:] = [MeanDegree[4], MeanDegree[end]]
    if MeanDegree[end] > MeanDegree[4]
        counter += 1
        plot(P,MeanDegree[1:end-1],grid = false, legend = false)
        # savefig("Figures/$graph)_mean_degree.pdf")
    end

    color = :gray
    s1 = 250
    s2 = 200
    if Sizes[end-1]> 3.4*Sizes[1]
        color = RGBA(C[nextcol,1],C[nextcol,2],C[nextcol,3],1)
        plot!(Psize,P,Sizes[1:end-1],color = color, size = (s1,s2), markershape = :circle, markerstrokecolor = color,markersize = ms, xlabel = "p",ylabel = "|S|", linewidth = lw)
        plot!(Pmax,P,MaxDegree[1:end-1],color = color, size = (s1,s2), markershape = :circle, markerstrokecolor = color, markersize = ms,xlabel = "p",ylabel  = "Maximum Degree", linewidth = lw)
        plot!(Pdensity,P,EdgeDens[1:end-1],color = color, size = (s1,s2), markershape = :circle, markerstrokecolor = color,markersize = ms, xlabel = "p",ylabel  = "Edge density", linewidth = lw)
        plot!(Pmean,P,MeanDegree[1:end-1],color = color, size = (s1,s2), markershape = :circle, markerstrokecolor = color, markersize = ms,xlabel = "p",ylabel = "Mean Degree", linewidth = lw)
        nextcol += 1
    else
        lw =1
        al = 0.1
        plot!(Psize,P,Sizes[1:end-1],color = color,size = (s1,s2),  alpha = al, xlabel = "p",ylabel = "Subgraph Size", linewidth = lw)
        plot!(Pmax,P,MaxDegree[1:end-1],color = color,size = (s1,s2),  alpha = al, xlabel = "p",ylabel  = "Maximum Degree", linewidth = lw)
        plot!(Pdensity,P,EdgeDens[1:end-1],color = color, size = (s1,s2), alpha = al, xlabel = "p",ylabel  = "Edge Density", linewidth = lw)
        plot!(Pmean,P,MeanDegree[1:end-1],color = color, size = (s1,s2), alpha = al, xlabel = "p",ylabel = "Average Degree", linewidth = lw)
    end

    if MeanDegree[5] > MeanDegree[4]
        counter += 1
        push!(xx,P[5])
        push!(yy,MeanDegree[5])
    end

    # Runtime is scatter plot
    scatter!(Prun,vec([n n n]),Times[1:3],size = (300,250),color = :blue, markerstrokecolor = :blue,label = "", xlabel = "n",ylabel = "Runtime (seconds)")
    scatter!(Prun,[n],[Times[4]],color = :red, markerstrokecolor = :red,label = "")
    scatter!(Prun,vec([n n n n]),Times[5:8],color = :gray, markerstrokecolor = :gray,label = "")

end

scatter!(Pmean,xx,yy,markershape = :x,color = :black, markersize = 4)


## Save them

plot!(Pmean)
savefig("Figures/Pmean2.pdf")

plot!(Pmax)
savefig("Figures/Pmax2.pdf")

plot!(Psize)
savefig("Figures/Psize2.pdf")

plot!(Pdensity)
savefig("Figures/Pdensity2.pdf")


plot!(Prun)
scatter!(Prun,[-1],[-1],color = :blue, legend = :topleft, ylim = [0,6.5],markerstrokecolor = :blue, xlabel = "n",label = "p<1",ylabel = "Runtime (seconds)")
scatter!(Prun,[-1],[-1],color = :red, markerstrokecolor = :red,label = "p=1")
scatter!(Prun,[-1],[-1],color = :gray, markerstrokecolor = :gray,label = "p>1")

savefig("Figures/Prun.pdf")


## prun
