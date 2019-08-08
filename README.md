# SDN-Controller-Placement
This source code can be used to optimize SDN controller placement in wide area networks.

The algorithms used are classical partitional algorithms namely Silhouette and Gap Statistic to determine the optimal number of controllers to deploy and PAM to find the optimal locations to place the controllers.

To mimic a real SDN deployment and verify the mathematical model, the controller placement problem is addressed using Mininet Python API, an OpenFlow emulation platform. For instruction on Mininet installation, please visit http://mininet.org/download/. We strongly recommend Mininet VM installation for rapid prototyping. 

Python libraries: Please make sure you have installed the following python libraries:

                  -igraph: this is a library collection for creating and manipulating graphs and analyzing networks
                  -matplotlib:a Python plotting library
                  
                  -numpy: a library that allows manipulation of large multi-dimensional arrays and matrices
                  
The control plane can be implemented using ONOS, Ryu, Floodlight or OpenDayLight.However, we recommend ONOS since it has been deemed the de-facto carrier grade SDN controller. 
