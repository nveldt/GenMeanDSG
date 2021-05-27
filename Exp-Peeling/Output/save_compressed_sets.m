graphs = {'amazon-communities','ca-AstroPhA','com-Youtube','condmat2005A','EmailEnronA','loc-Brightkite','web-Google','roadNet-CA','roadNet-TX','web-Stanford','web-BerkStan'};




%% later
for i = 1:length(graphs)
    graph = graphs{i};
    load(strcat(graph,'_sets.mat'))
    Ssets = sparse(Ssets);
    save(strcat(graph,'_sets.mat'),'Ssets')
end
