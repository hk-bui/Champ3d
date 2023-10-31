
close all
clear
clc

% ---
xsize_ = logspace(2,7,7-2+1);
nbtest = length(xsize_);
xmin   = -1;
xmax   = +1;
% ---
tintp  = zeros(1,nbtest);
tscatI = zeros(1,nbtest);
% ---
for i = 1:nbtest
    clear fi;
    xsize = xsize_(i);
    xi    = linspace(xmin,xmax,xsize);
    yi    = linspace(xmin,xmax,xsize);
    zi    = linspace(xmin,xmax,xsize);
    x = xmin + (xmax - xmin) .* rand(1,xsize);
    y = xmin + (xmax - xmin) .* rand(1,xsize);
    z = xmin + (xmax - xmin) .* rand(1,xsize);
    f = (x .^ 2 + y.^2 + z.^2) + rand(1,xsize) ./ 10;
    % ---
    %tic
    %f1 = interp2(x,y,f,xi,yi);
    %t(i) = toc;
    % ---
    tic
    fi = scatteredInterpolant(x.',y.',z.',f.');
    tscatI(i) = toc;
    % ---
    tic
    f1 = fi(xi,yi,zi);
    tintp(i) = toc;
end
% ---
figure
plot(tscatI,'-ro'); xlabel('nb elem'); ylabel('time (s)');
figure
plot(tintp,'-bs'); xlabel('nb elem'); ylabel('time (s)');


