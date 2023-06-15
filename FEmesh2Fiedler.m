%%
%%%%%%%%%%%%%%%%%%%%
%%% Example Code %%%
%%%%%%%%%%%%%%%%%%%%
%% Load FE mesh
clc
clear
load('FEmesh.mat')
%% Create Graph from FEM
st = zeros(size(elements,1)*8,2);
for i=1:size(elements,1)
    st(8*i-7:8*i,:) = [elements(i,1),elements(i,2);
                       elements(i,2),elements(i,3);
                       elements(i,3),elements(i,4);
                       elements(i,4),elements(i,1);
                       elements(i,2),elements(i,1);
                       elements(i,3),elements(i,2);
                       elements(i,4),elements(i,3);
                       elements(i,1),elements(i,4)];
end
st = unique(st,'rows');
G = digraph(st(:,1),st(:,2));
%% Calculate the Fiedler Vector
Adj = adjacency(G); % Adjacency Matrix
Degree = zeros(size(Adj)); % Degree Matrix
Degree(logical(eye(length(sum(Adj))))) = sum(Adj);
L = Degree  - Adj; % The Laplacian
[e,v]  = eigs(sparse(L),2,'sm', struct('disp',0));
nodes_3d = [nodes,e(:,2)];
%% Plot
figure(1)
patch('Faces',elements,'Vertices',nodes_3d(:,2:4), ...
      'FaceVertexCData',nodes_3d(:,4), ...
      'FaceColor','interp','edgecolor','None')
view(30,30)
axis off, axis on, grid on 
