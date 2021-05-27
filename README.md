# GenMeanDSG
Algorithmic implementations and code for experimental results from the paper

**The Generalized Mean Densest Subgraph Problem  
Nate Veldt, Austin Benson, Jon Kleinberg  
KDD 2021**

## Data

The peeling algorithms experiments use publicly available graphs mostly from the SNAP repository ([https://snap.stanford.edu/data/index.html](https://snap.stanford.edu/data/index.html)),
and can also be downloaded in .mat form from the 
SuiteSparse Matrix collection ([https://sparse.tamu.edu/](https://sparse.tamu.edu/)).

In order to run all experiments, many of the larger datasets will need to be downloaded and placed in the data folder.

FB100 graphs are also not included in the repo and will need to be added to the data folder in order to run experiments on these graphs.

## Experiments

### Optimal vs. greedy solutions

In order to obtain exact solutions to the p-mean densest subgraph objective, we implement our algorithm in MATLAB in order to use existing submodular function optimization software SFO ([https://dl.acm.org/doi/10.5555/1756006.1756044](https://dl.acm.org/doi/10.5555/1756006.1756044)).

See the ``Exp-Optimal`` folder.

### Greedy peeling experiments on large networks

See the ``Exp-Peeling`` folder.

### Facebook peeling experiments

See the ``Exp-Facebook`` folder.