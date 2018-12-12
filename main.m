%#######################################################################
% Author: Lusani Mamushiane
%Date:February 2018
%Project name: Optimal Controller Placement in SDN-enabled core networks
%This program generates topology information from a gml file and computes
%the adjacency matrix used to plot the network topology.
%Use Silhouette and Gap Statistic to compute optimal number of controller
%to deploy
% Uses PAM algorithm to compute optimal locations to place controllers
%#######################################################################

clear all;
clc;
graph = read_gml('Internet2.gml'); % Get the Graph structure

% Show the Graph structure
show_graph = graph; 
show_nodes = graph.node;
show_node2 = graph.node(2);
show_edges = graph.edge;

% Get coordinates matrix
D=[]; 
for i=1:length(graph.node) 
    D(i,1)=graph.node(i).Longitude;
    D(i,2)=graph.node(i).Latitude;
end
D; 

%get the labels of nodes
L={};
%M=num2str(graph.node(1).label)
for i=1:length(graph.node)  
    L{1,i}=num2str(graph.node(i).id); %node ids
    L{2,i}=num2str(graph.node(i).label); %node labels
    
end
L;

A = get_adjacency_matrix(graph); % Adjacency Matrix: row: Source, column: Target

%plot topology
figure;
for i=1:length(graph.node)
line(D(i,1),D(i,2),'MarkerSize',20,'Marker','.','Color','red')
end 
hold on
gplot(A,D,'-r')
axis square
% title('SANREN Backbone');
xlabel 'Longitude'
ylabel 'Latitude'
for i=1:length(graph.node)
text(D(i,1),D(i,2),L{2,i},'FontSize',15,'Color','black');
end
 hold off

%Calculate geographical distance matrix   
dMatrix1=[]; dMatrix2=[];
for i=1:length(D)
    for j=1:length(D)
[dMatrix1(i,j) dMatrix2(i,j)]=lldistkm(D(i,:),D(j,:));
   end
end
dMatrix1;
dMatrix2;
%Verify results for Sanren backbone
latlon=[-29.8500  31.0167;-33.0153  27.9116];
[d1km d2km]=lldistkm(latlon(1,:),latlon(2,:));

%Weight Matrix
edgesDistKm=[]; %distance of edges in km,this represents weights
for i=1:length(graph.edge)
edgesDistKm(i,1)=graph.edge(i).source; %first two colums  indicate edges
edgesDistKm(i,2)=graph.edge(i).target;
source=graph.edge(i).source+1;
target=graph.edge(i).target+1;%matlab doesn't work with zero indices. Therefore add "1" to each node id
edgesDistKm(i,3)=dMatrix1(source,target); %3rd column stores the distances between nodes in kms.
%This is used to represent the edge weights
end

edgesDistKm(:,1:3) = round( edgesDistKm(:,1:3));
%edgesDistKm(:,1:2)
source=(edgesDistKm(:,1)+1)';
target=(edgesDistKm(:,2)+1)';
Weight=[];
Weight(:,1)=edgesDistKm(:,3);
weights=Weight';

%plot topology with weights
% for i=1:length(graph.node)
% line(D(i,1),D(i,2),'MarkerSize',35,'Marker','.','Color','r')
% end 
% hold on
% gplot(A,D,'-b')
% axis square
% hold on
% for i=1:length(graph.node)
% text(D(i,1),D(i,2),L{2,i},'FontSize',8,'Color','black');
% end
% hold on
% G=graph(source,target);
% h=plot(G)
% plot the weights on top of the figure
% labeledge(h,1:numedges(G),weights);
hold off


%Find the shortest distance matrix using Johnson's algorithm
maxnode = max([source, target]);
DG=sparse(source,target,Weight.',maxnode,maxnode);
UG = tril(DG + DG');
[dist]=graphallshortestpaths(UG,'directed',false);

%Calculate average latency and worst-case latency.
L_average= (sum(sum(dist)))/(length(graph.node)); %average latency 
L_worst=max(dist(:)); %worst-case latency


%use k-medoiods for best placement of 4 controllers
k=4
[inds,cidx] = kmedioids(dist,k);
clf, hold on, axis square
c = lines(k);
pts=D';
Latency_matrix1=zeros(k,15);
%test=length(inds(1,inds==1))
for i=1:k      
    
    %ptsi(:,length(inds(1,inds==1))) = pts(:,inds==i);
    ptsi= pts(:,inds==i);
    ctrpt = pts(:,cidx(i));
%  for j=1:length(ptsi)    %Average distance matrix for optimized network
%  [Latency_matrix1(i,j)]=lldistkm(ctrpt,ptsi(:,j));
%   no_of_elements=length(ptsi)
%  end
%  if no_of_elements<length(ptsi)
%      z=length(ptsi)
%  else z= no_of_elements
    plot(ptsi(1,:),ptsi(2,:),'.','markersize',22,'color',c(i,:))
    plot(ctrpt(1),ctrpt(2),'kx','markersize',15,'linewidth',3, 'color','red')    
    
end
hold on
for i=1:length(graph.node)
text(D(i,1),D(i,2),L{2,i},'FontSize',10,'Color','black');
end
hold on
gplot(A,D,'-');
% title('\fontsize{16}Uncapacitated Optimal Controller Placement');
xlabel('Longitude (degrees)','FontSize',25,'FontWeight','bold');
ylabel ('Latitude(degrees)','FontSize',25,'FontWeight','bold');
% legend({'Cluster 1','Controller Placements','Cluster 2', 'Cluster 3','Cluster 4'}, 'FontSize',10)
set(gca,'fontsize',20)
hold off

%find average and worst-case latency

%  ptsi1=pts(:,inds==1);
%  ptsi2=pts(:,inds==2);
%  ptsi3=pts(:,inds==3);
%  ptsi4=pts(:,inds==4);
%  ptsi5=pts(:,inds==5);
%  ptsi6=pts(:,inds==6);
%  ctrpt1=pts(:,cidx(1));
%  ctrpt2=pts(:,cidx(2));
%  ctrpt3=pts(:,cidx(3));
%  ctrpt4=pts(:,cidx(4));
%  ctrpt5=pts(:,cidx(5));
%  ctrpt6=pts(:,cidx(6));
%  dist_avg1=zeros(1,length(ptsi1));
%  dist_avg2=zeros(1,length(ptsi2));
%  dist_avg3=zeros(1,length(ptsi3));
%  dist_avg4=zeros(1,length(ptsi4));
%  dist_avg5=zeros(1,length(ptsi5));
%  dist_avg6=zeros(1,length(ptsi6));
% %  dist_avg4=zeros(1,length(ptsi4));
%  for j=1:length(ptsi1)
%  dist_avg1(:,j)=lldistkm(ctrpt1,ptsi1(:,j));
%  end
%  dist_avg1/2e5
%   ptsi1
%  for j=1:length(ptsi2)
%  dist_avg2(:,j)=lldistkm(ctrpt2,ptsi2(:,j));
%  end
%  dist_avg2/2e5
%   ptsi2
%  for j=1:length(ptsi3)
%  dist_avg3(:,j)=lldistkm(ctrpt3,ptsi3(:,j));
%  end
%  dist_avg3/2e5
%  ptsi3
%   for j=1:length(ptsi4)
%  dist_avg4(:,j)=lldistkm(ctrpt4,ptsi4(:,j));
%  end
% dist_avg4/2e5
%  ptsi4
%  
%  for j=1:length(ptsi5)
%  dist_avg5(:,j)=lldistkm(ctrpt5,ptsi5(:,j));
%  end
% dist_avg5/2e5
%  ptsi5
%  for j=1:length(ptsi6)
%  dist_avg6(:,j)=lldistkm(ctrpt6,ptsi6(:,j));
%  end
% dist_avg6/2e5
%  ptsi6

% O=sum(dist_avg1)
% T=sum(dist_avg2)
% V=sum(dist_avg3)
% P=sum(dist_avg4)
% S=sum(dist_avg5)
% Z=sum(dist_avg6)
% 
% L_averag11=sum(O+T+V+P+S+Z)/((length(graph.node))*2e5)
% L_worst=max(dist_avg1)/2e5
% L_worst2=max(dist_avg2)/2e5
% L_worst3=max(dist_avg3)/2e5
% L_worst4=max(dist_avg4)/2e5
% L_worst5=max(dist_avg5)/2e5
% L_worst6=max(dist_avg6)/2e5

%Plot average and worst-case latency against controllers

y=[0.0029 0.00181 0.0012 0.00098 ];
z=[0.0068 0.00392 0.005 0.0053 ];
figure;
AxesH = axes('Xlim', [1, 4], 'XTick', 1:1:4, 'NextPlot', 'add');
% set(gca,'XTick',1:1:6);
axis square
plot(1:4,y, '--', 'Color','blue','LineWidth',2);
% title('\fontsize{25}Relation between number of controllers and latency');
xlabel('Number of controllers','FontSize',30,'FontWeight','bold');
ylabel ('Overall latency (ms)','FontSize',30,'FontWeight','bold');
hold on
plot(1:4,z, ':', 'Color','red','LineWidth',2);
legend({'average latency','worst-case latency'}, 'FontSize',20)
set(gca,'fontsize',20)
hold off

%Alternative approach for placement optimization using K-Medoids
n=length(graph.node);
% L_average=[];
D; %coordinates matrix
% for k=1:5 %number of clusters/controllers
% opts = statset('Display','iter');
% [idx,Clust,sumd,d,midx,info] = kmedoids(D,k,'Distance',@lldistkm,'Options',opts);
% L_average (1,k)=(sum(sumd))/length(graph.node) %evaluating the optimization results using k-medoids. Results are benchmarked against Johnson's results
% %######parameters description#########
% %idx: vector idx containing cluster indices of each observation
% %Clust:returns the k cluster medoid locations in the k-by-2 matrix C
% %sumd:  returns the within-cluster sums of point-to-controller distances in the k-by-1 vector sumd
% %d: returns distances from each point to every medoid in the n-by-k matrix D
% %midx: returns the indices midx such that Clust = X(midx,:). midx is a k-by-1 vector
% %info: returns a structure info with information about the options used by the algorithm when executed
% end
% % Plot clustering results
% figure;
% plot(D(idx==1,1),D(idx==1,2),'r.','MarkerSize',24)%everypoint in cluster idx(e.g. 1) plot and mark with red.
% hold on
% plot(D(idx==2,1),D(idx==2,2),'b.','MarkerSize',24)
% hold on
% plot(D(idx==3,1),D(idx==3,2),'g.','MarkerSize',24)
% hold on
% plot(D(idx==4,1),D(idx==4,2),'k.','MarkerSize',24)
% 
% plot(Clust(:,1),Clust(:,2),'co',...
%      'MarkerSize',12,'LineWidth',2)
% legend('Cluster 1','Cluster 2','Cluster 3','Cluster 4','Controller Placements',...
%        'Location','NW');
% title('Uncapacitated Controller Placement');
% xlabel 'Longitude'
% ylabel 'Latitude'
% hold off

% Finding the best k using the silhouette method %options are silhoutte, elbow and gap statistics
figure;
[silh3,h] = silhouette(D,inds,@dist_matrix);
cluster3 = mean(silh3)
h = gca;
h.Children.EdgeColor = [.8 .8 1];
xlabel ('Silhouette Value','FontSize',30,'FontWeight','bold')
ylabel ('Cluster','FontSize',30,'FontWeight','bold')
% title ('\fontsize{16}Cluster quality analysis using silhouette for k=4')
k=4;
idxk=[];
%Evaluate best number of controllers to use
[idxk]=clust_med(D,k,n)
%Evaluate silhouette value for different no. of clusters
eva = evalclusters(D,idxk,'Silhouette','Distance',@dist_matrix)
%Plot silhouette results for varrying cluster count
figure;
plot(eva)
xlabel ('Number of clusters/controllers ','FontSize',30,'FontWeight','bold')
ylabel ('Silhouette Value','FontSize',30,'FontWeight','bold')
% title ('\fontsize{16}Evaluation of cluster quality for varrying number of controllers')

% finding the best k using the elbow method -this method is not recommended
% as it is difficult to read the elbow and it doesn't allow custom distance
% functions
% [IDX,C,SUMD,K] = best_kmeans(D); %I need to confirm this

%Finding the best k using the gap statistics
figure;
axis square;
% AxesH = axes('Xlim', [2, 4], 'XTick', 2:1:4, 'NextPlot', 'add');
eva = evalclusters(D,@kmedoids,'Gap','KList',[2:4],'Distance',@lldistkm)
set(gca,'fontsize',20)
plot(eva)
hold on
xlabel ('Number of clusters/controllers ','FontSize',30,'FontWeight','bold')
ylabel ('Gap value','FontSize',30,'FontWeight','bold')

% Finding the best k using the  Calinski-Harabasz  method -this option
% only works for Euclidean distance
% eva = evalclusters(D,@kmedoids,'CalinskiHarabasz','KList',[2:4])
% plot(eva)
% hold on
% xlabel 'Number of controllers'

% Finding the best k using the  DaviesBouldin  method 
% eva = evalclusters(D,@kmedoids,'DaviesBouldin','KList',[2:4])
% plot(eva)
% xlabel 'Number of controllers'

%Analysis tradeoff between cost of installing new controller and performace
cost_benefit=[];
controller_cost=1;
k=4;

for i=1:k
    cost_benefit(1,i)=(controller_cost*i)/(L_average(i));
   
end
% 
k=[1 2 3 4];
figure;
AxesH = axes('Xlim', [1, 4], 'XTick', 1:1:4, 'NextPlot', 'add');
line(k,cost_benefit,'MarkerSize',20,'Marker','.','Color','b')
hold on
box on;
plot(k,cost_benefit, '-b')
set(gca,'fontsize',20)
% title('Optimal number of controllers based on cost benefit');
xlabel ('Number of controllers','FontSize',30, 'FontWeight','bold')
ylabel ('Cost benefit ($/ms)','FontSize',30,'FontWeight','bold')
% edgeLatency for Mininet Emulation
edgesDistKm(:,3)=edgesDistKm(:,3)/2e2
edgeLatency=(edgesDistKm(:,1:3))

