#!/usr/bin/python
#Author: Lusani Mamushiane
# This code does the following:
# Reads a topology gml file using igraph and networkx;
# Computes link latencies;
# Emulates the topology;
# Partitions the network into two domains and instantiate controllers;
# Finds optimal locations to place controllers using a ping procedure
from mininet.net import Mininet
from mininet.node import Controller, RemoteController, OVSController
from mininet.node import CPULimitedHost, Host, Node
from mininet.node import OVSKernelSwitch, UserSwitch
from mininet.node import IVSSwitch
from mininet.cli import CLI
from mininet.log import setLogLevel, info
from mininet.link import TCLink, Intf
from subprocess import call
import igraph as ig
import networkx as nx
import matplotlib.pyplot as plt
import haversine
import numpy as np
import haversine as hv


def myNetwork():

    net = Mininet( topo=None,
                   build=False,
                   ipBase='10.0.0.0/8')
    info( '*** Adding controller\n' )
    c0=net.addController(name='c0',
                      controller=RemoteController,
                      ip='192.168.0.180',
                      protocol='tcp',
                      port=6633)

    c1=net.addController(name='c1',
                      controller=RemoteController,
                      ip='192.168.0.181',
                      protocol='tcp',
                      port=6633)


    g=ig.Graph.Read_GML("Internet2.gml")
    #print(summary(g))

    #delays=g.node[0]["Longitude"]
    #print delays

    
#print nx.info(g)
#print g.nodes
#print g.edges
#print g.number_of_edges()
#print g.number_of_nodes()
#num_nodes=g.number_of_nodes()

    info( '*** Adding switches and hosts\n')
    nodes=g.vcount()
    print nodes

    for i in range(0,nodes):
        s="s"+str(i)
        h="h"+str(i)
        IP="10.0.0."+str(i+1)
        #print IP
        s = net.addSwitch(s, cls=OVSKernelSwitch)
        h = net.addHost(h, cls=Host, ip=IP, defaultRoute=None)
        net.addLink(h, s)
        #print i
        print s
    info( '*** Connecting switches\n')
    edges=g.get_edgelist() #read graph edges
    print(edges)

    s=[None]*0 #initialize/declare an array of fixed size (i.e. n=2)
    #print s

    for i in edges:
    #print i  #i is an edge (subset of egdes)
        s=[None]*0
        for j in i:
        #print j  #j is either source or target (subset of i)
            r="s"+str(j)
            s.insert(0,r)  #insert results before position zero
        print s   #s represents target source pairs
        source=s[1]
        target=s[0]
        source_target="*"+"*"+source+target
        print source
        print target
        print source_target
        net.addLink(source, target, cls=TCLink)
    #############configure link delays########
    info( '*** Configuring link delays\n')
    latlon=[] 
    lats=list(g.vs['Latitude']) #read the latitute attribute
    lons=list(g.vs['Longitude']) #read the longitude attribute
    lat=np.array([lats])
    lon=np.array([lons])
    #print np.concatenate((lat.T,lon.T),axis=1)
    latlon= np.concatenate((lat.T,lon.T),axis=1)
    lat_lon1=latlon.tolist()
    print lat_lon1
    m, n = 2, 2; #create a list of two lists each having 2 items all containing 0 entries
    lonlat2 = [[0 for x in range(m)] for y in range(n)] 
    print lonlat2
    edges=g.get_edgelist() #read graph edges
    print(edges)
    s=[None]*0
    for i in edges:
        #lonlat2=[]
        print i  #i is an edge (subset of egdes)
        for j in range(0,2):
            #print j
            print i[j]
            k=i[j]
            #print lat_lon1[k]
            lonlat2[j][:]=lat_lon1[k] #read source destination pairs and store results in a 2X2 list of lists
        #print lonlat2
        link_delays=hv.distance(lonlat2)
        print link_delays
        for z in i:
            q="s"+str(z)
            s.insert(0,q)
        p=s[1]+s[0]
        link_delays2=str(link_delays)
        p = {'delay':link_delays2}
        print p
    info( '*** Starting network\n')
    net.build()
    info( '*** Starting controllers\n')
    for controller in net.controllers:
        controller.start()

    info( '*** Starting switches\n')
    for i in range(0,nodes):
        s="s"+str(i)
        print s
        net.get(s).start([c0,c1])

    info ('Optimizing controller placement through ping\n')
    hosts=net.hosts

    #server=hosts[0]
    outfiles, errfiles = {}, {}
    hosts_count=len(hosts) #get the size/length of the hosts array
    for k in range(0,hosts_count):
        for h in hosts:
    #create and/or erase output files
            server=hosts[k-1]
            outfiles[h]='/tmp/%s.out' % h.name
            errfiles[h]='/tmp/%s.err' % h.name
            h.cmd('echo >', outfiles[h])
            h.cmd('echo >', errfiles[h])
     #start pings
    for hpair in zip(hosts, hosts[1:]):
        net.ping(hpair, timeout='1')
    net.ping((hosts[-1], hosts[0]), timeout='1')
    #print hosts

    info( '*** Post configure switches and hosts\n')

    CLI(net)
    net.stop()

if __name__ == '__main__':
    setLogLevel( 'info' )
    myNetwork()

