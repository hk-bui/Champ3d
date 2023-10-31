%% techniques in vectorization

clear
clc




%% Understanding reshape
% 1st dim like a row
% 2nd dim like a col
% 3rd dim like z
% always take elem in row first, run all rows, return to 1st row of 2nd col
%      ... then go to the 2nd layer in z. 

clear
clc
fprintf('Understanding reshape ________________\n');
n1 = 2; n2 = 3; n3 = 4;
a1 = 1 : n1*n2*n3
a2 = reshape(a1,n1*n2,n3)
a3 = reshape(a2,n1,n2,n3)


%% Understanding permute
% Generalization of transpose
clear
clc
fprintf('Understanding permute ________________\n');
n1 = 3; n2 = 2; n3 = 4;
a1 = 1 : n1*n2*n3
a2 = reshape(a1,n1,n2,n3) % 3 x 2 x 4
a3 = permute(a2,[2 1 3])  % 2 x 3 x 4

%% Application of reshape & permute
% making flatvec

clear
clc
fprintf('Application of reshape & permute ________________\n');
n1 = 3; n2 = 2; n3 = 4;   % 3 edges, 2 nodes, 4 elem 
a1 = 1 : n1*n2*n3;
a2 = reshape(a1,n1,n2,n3) % 3 x 2 x 4

id_edge = zeros(n1,1,n3);
k = 0;
for i = 1:n3
    for j = 1:n1
        k = k + 1;
        id_edge(j,1,i) = k;
    end
end
% --- making flatvec
% !!! on len, position, size, dim
position = 2;
lenlist_o = size(a2);
positionlist_o = 1:length(lenlist_o);
len_position = lenlist_o(position);
% ---
positionlist_new = positionlist_o;
positionlist_new(position) = [];
positionlist_new = [position positionlist_new];
lenlist_new = lenlist_o(positionlist_new);
a3 = reshape(permute(a2,positionlist_new),len_position,[])  % 2 x 3 x 4
id_edge_3 = 1:size(a3,2)
% --- return to original
a4 = reshape(a3, lenlist_new);
% ---
a5 = ipermute(a4,positionlist_new)
find(a5- a2)
% ---
id_edge_4 = reshape(id_edge_3, [1 lenlist_new(2:end)]);
id_edge_5 = ipermute(id_edge_4,positionlist_new)
find(id_edge_5- id_edge)

%% Understanding repmat
fprintf('Understanding repmat ________________\n');
nb_elem = 5;
a = [1 2 3; 4 5 6; 7 8 9]
b = reshape(repmat(a,1,nb_elem),3,3,nb_elem);
b = permute(b,[3 1 2]);
for i = 1:nb_elem
    squeeze(b(i,:,:))
end
%% Understanding extraction size convention
fprintf('Understanding extraction size convention ________________\n');
nb_elem = 5;
g1 = zeros(3,3,nb_elem);
g2 = zeros(nb_elem,3,3);
m  = rand(3,3)
for i = 1:nb_elem
    g1(:,:,i) = m;
    g2(i,:,:) = reshape(m,1,3,3);
end
for i = 1:nb_elem
    squeeze(g1(:,:,i))
    squeeze(g2(i,:,:))
end
