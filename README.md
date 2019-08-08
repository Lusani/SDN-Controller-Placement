# Introduction

This source code can be used to optimize SDN controller placement in wide area networks.

The algorithms used are classical “unsupervised” machine learning algorithms namely Silhouette and Gap Statistic to determine the optimal number of controllers to deploy and PAM to find the optimal locations to place the controllers.Unsupervised algorithms learn from input data that has no labeled responses. These algorithms are classically used to analyze cluster quality through the metric of minimum distances between data points. In the context of controller placement, we leverage these algorithms to find the number of controllers that minimizes overall network propagation latency (i.e. switch-to-switch latency). To find the best locations for these controllers, we extend a facility location  algorithm called Partition Around Medoids algorithm (PAM), with propagation latency (i.e. controller-to-switch latency) as our main objective function.

To match and verify the outcome from our mathematical formulation regarding the best locations to place the controller in a wide area network (WAN), we use an emulation orchestration platform called Mininet, critical to mimic a real SDN deployment. We use controller-to-node latency (propagation + queuing +processing latency) as a key performance indicator. The source code for this part of the experiment is the folder named

# SDN-Controller-Placement using Matlab

Run Controller_Placement.m . Change the topology name k (number of controllers) values as desired. 

# SDN-Controller-Placement using Emulation

To mimic a real SDN deployment and verify the mathematical model, the controller placement problem is addressed using Mininet Python API, an OpenFlow emulation platform. For instruction on Mininet installation, please visit http://mininet.org/download/. We strongly recommend Mininet VM installation for rapid prototyping. 

# Python libraries: 

Please make sure you have installed the following python libraries:

-igraph: this is a library collection for creating and manipulating graphs and analyzing networks
                  
-matplotlib:a Python plotting library
                  
-numpy: a library that allows manipulation of large multi-dimensional arrays and matrices

# Topologies:

The network topologies are publicly available at Internet Topology Zoo (http://www.topology-zoo.org/). We have also included the internet2 topology on this page for convenience. 

# SDN Control Plane
                  
The control plane can be implemented using ONOS, Ryu, Floodlight or OpenDayLight.However, we recommend ONOS since it has been deemed the de-facto carrier grade SDN controller.

# ONOS Installation

ONOS default packages assume ONOS gets installed under /opt, so first make sure the directory exists and move into it
                   
                  Move to /opt
                  
                  sudo mkdir /opt
                  
                  cd /opt

Start downloading the desired version of ONOS in tar.gz format. Choose your favorite from the ONOS website, download section (http://downloads.onosproject.org). Copy the file downloaded or download the file directly from the target machine and put it in /opt. For example:

# Download ONOS
                  
                  sudo wget -c http://downloads.onosproject.org/release/onos-$ONOS_VERSION.tar.gz

Untar the ONOS archive into /opt

                  sudo tar xzf onos-$ONOS_VERSION.tar.gz


Rename the extracted directory to "onos"

                  sudo mv onos-$ONOS_VERSION onos
                  
Verify that ONOS works

ONOS can be run directly calling its start-stop script, located under the /opt/onos/bin directory:

Running ONOS using its start-stop script

                  /opt/onos/bin/onos-service start
                  
To see apps that are presently active, type the apps -a -s command and you will see the following output

                  onos> app -s
In the same ONOS CLI window, type the following to active the Reactive Forwarding and OpenFlow applications:

                  onos> app activate org.onosproject.fwd

                  onos> app activate org.onosproject.openflow
                  
To verify that the apps were activated use app -a -s command

# Running the code

Make sure your controller is running by using  /opt/onos/bin/onos-service start

Run main.py script as follows:

              python ./main.py
              
The following procedure is used for each node to determine average latency: To find optimal controller locations, first we install the ONOS controller in the same geographic location as the first OpenFlow switch node (using the harvesine great circle approach and the Linux TC utility). The next step is to trigger a packet-In message to the controller. This is done by generating traffic flows between all pairs, i.e. between this node and all other nodes in the SANReN topology. To do this we generate a ICMP packet using the ping utility for each pair. This is followed by computation of the ICMP pinging results to obtain the total average latency (round-trip time) from the node to all other nodes in the network. This step is repeated for all nodes in the SANReN topology. To ensure valid and reliable results, we repeat the above procedure several times under a soft idle timeout for the controller entry of 5 seconds (the soft idle timeout defines the expiry time of a controller flow rule when there is no flow activity) and compute the average results. The soft idle timeout is set to ensure generation of control traffic upon pinging reiterations.





