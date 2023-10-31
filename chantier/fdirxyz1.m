function dir = fdirxyz1(node)

nb_node = size(node,2);
dir = zeros(3,nb_node);

x = node(1,:);
y = node(2,:);
z = node(3,:);

for i = 1:nb_node
    if x(i) < 0.5
        dir(:,i) = [1 1 1];
    else
        dir(:,i) = [-1 0 0];
    end
end



    