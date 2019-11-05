#!/usr/bin/python
from igraph import *

g=Graph.Read_GML("Sanren.gml")
print(summary(g))

    #delays=g.node[0]["Longitude"]
    #print delays

    
#print nx.info(g)
#print g.nodes
#print g.edges
#print g.number_of_edges()
#print g.number_of_nodes()
#num_nodes=g.number_of_nodes()

nodes=g.vcount()
n=g.nodes
print n

