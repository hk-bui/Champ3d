function dir = fdirxyz2(node)

nb_node = size(node,2);
dir = zeros(nb_node,3);

x = node(1,:);
y = node(2,:);
z = node(3,:);

dir(x<0.5,:) = ones(sum(x<0.5),3) .* [1 1 1];
