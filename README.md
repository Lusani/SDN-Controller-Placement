# SDN-Controller-Placement
This source code can be used to optimize SDN controller placement in wide area networks.

The algorithms used are classical partitional algorithms namely Silhouette and Gap Statistic to determine the optimal number of controllers to deploy and PAM to find the optimal locations to place the controllers.

To mimic a real SDN deployment and verify the mathematical model, the controller placement problem is addressed using Mininet Python API, an OpenFlow emulation platform. For instruction on Mininet installation, please visit http://mininet.org/download/. We strongly recommend Mininet VM installation for rapid prototyping. 

Python libraries: Please make sure you have installed the following python libraries:

-igraph: this is a library collection for creating and manipulating graphs and analyzing networks
                  
-matplotlib:a Python plotting library
                  
-numpy: a library that allows manipulation of large multi-dimensional arrays and matrices


Topologies:

The network topologies are publicly available at Internet Topology Zoo (http://www.topology-zoo.org/). We have also included the internet2 topology on this page for convenience. 

SDN Control Plane
                  
The control plane can be implemented using ONOS, Ryu, Floodlight or OpenDayLight.However, we recommend ONOS since it has been deemed the de-facto carrier grade SDN controller.

ONOS Installation

ONOS default packages assume ONOS gets installed under /opt, so first make sure the directory exists and move into it
                   
                  Move to /opt
                  
                  sudo mkdir /opt
                  
                  cd /opt

Start downloading the desired version of ONOS in tar.gz format. Choose your favorite from the ONOS website, download section (http://downloads.onosproject.org). Copy the file downloaded or download the file directly from the target machine and put it in /opt. For example:

Download ONOS
                  
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

Running the code:

Make sure your controller is running by using  /opt/onos/bin/onos-service start

Run the 





