
close all
clear
clc

% -------------------------------------------------------------------------

test_meshds3d_ = [0 1];

for test_meshds3d = test_meshds3d_

    msize_  = 20:20:200;
    nbsize  = length(msize_);
    nbelem  = zeros(1,nbsize);
    nbface  = zeros(1,nbsize);
    nbedge  = zeros(1,nbsize);
    nbnode  = zeros(1,nbsize);
    memsize = zeros(1,nbsize);
    
    
    for i = 1:length(msize_)
        % build 1D mesh
        msize  = msize_(i);
        c3dobj = [];
        c3dobj = f_add_x(c3dobj,'id_x','x1d','d',1,'dnum',msize,'dtype','lin');
        c3dobj = f_add_y(c3dobj,'id_y','y1d','d',1,'dnum',msize,'dtype','lin');
        c3dobj = f_add_layer(c3dobj,'id_layer','l1d' ,'d',1,'dnum',msize,'dtype','lin');
        % build 2D mesh
        c3dobj = f_add_mesh2d(c3dobj,'id_mesh2d','mesh2d',...
                'build_from','mesh1d',...
                'id_x', {'x1d'},...
                'id_y', {'y1d'});
        % build 3d mesh
        c3dobj = f_add_mesh3d(c3dobj,'id_mesh3d','mesh3d','mesher','c3d_hexamesh',...
                               'id_mesh2d',{'mesh2d'},...
                               'id_mesh1d',[],...
                               'id_layer',{'l1d'});
        % ---
        if test_meshds3d
            %c3dobj.mesh3d.mesh3d = f_meshds3d(c3dobj.mesh3d.mesh3d,'get','edge');
            %c3dobj.mesh3d.mesh3d = f_meshds3d(c3dobj.mesh3d.mesh3d,'get','face');
            c3dobj.mesh3d.mesh3d = f_get_edge(c3dobj.mesh3d.mesh3d);
            c3dobj.mesh3d.mesh3d = f_get_face(c3dobj.mesh3d.mesh3d);
        end
        % ---
        nbelem(i) = c3dobj.mesh3d.mesh3d.nb_elem;
        nbnode(i) = c3dobj.mesh3d.mesh3d.nb_node;
        if test_meshds3d
            nbedge(i) = size(c3dobj.mesh3d.mesh3d.edge,2);
        end
        % ---
        memc3dobj = whos('c3dobj');
        memsize(i) =  memc3dobj.bytes / (2^20); % to MB
    end

    % ---
    if test_meshds3d
        figure
        %subplot(121)
        plot(nbelem,memsize,'-ro','DisplayName','with meshds3d full')
        ylabel('Memory required (MB)')
        xlabel('nb elem')
        %subplot(122)
        %plot(nbelem,nbedge,'-s')
        figure
        %subplot(121)
        plot(nbedge,memsize,'-ro','DisplayName','with meshds3d full')
        ylabel('Memory required (MB)')
        xlabel('nb edge')
    else
        figure
        plot(nbelem,memsize,'-bo','DisplayName','without meshds3d')
        ylabel('Memory required (MB)')
        xlabel('nb elem')
    end

end

