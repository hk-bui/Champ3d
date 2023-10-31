
node = zeros(3,4);
node(:,1) = [0 0 1].';
node(:,2) = [1 0 1].';
node(:,3) = [1 2 1].';
node(:,4) = [0 2 1].';

face = [1 2 3 4].';
face = repmat(face,1,1e6);

area = f_measure(node, face, 'face');

%f_view_mesh2d(node,face,'face_color','b')