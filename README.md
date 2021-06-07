# Sampling-on-graph-signals

This project proposes sampling theory for graph signals that are supported on directed or
undirected graphs. With the proposed sampling theory, perfect recovery is possible for the
bandlimited graph signals from its sampled signal. Designing the sampling operator using
optimal sampling operator and random sampling operator for different graphs. We will
show how to handle full band graph signals by using graph filter banks.

Given an adjacency matrix of a graph, we try to find an optimal sampling and interpolating operators for the graph using the adjacency list. The proposed algorithm for optimal sampling operator is constructed using greedy algorithm. By multipling the graph's adjacency matrix with sampling operator, we can get the sampled version of the graph. For reconstruction, we multiply the sampled version with the interpolating operator. 

We also analysed the success rate of optimal and random sampling operator. We also shown that random sampling operator is also good for special graphs. For detailed information about the project and plots for different analyses read the _Team_40-Project Final Report.pdf_.
