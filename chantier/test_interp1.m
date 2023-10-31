
close all
clear
clc

% ---
xsize_ = logspace(2,7,6);
nbtest = length(xsize_);
xmin   = -1;
xmax   = +1;
% ---
t = zeros(1,nbtest);
t2 = zeros(1,nbtest);
% ---
for i = 1:nbtest
    xsize = xsize_(i);
    xi    = linspace(xmin,xmax,xsize);
    x = xmin + (xmax - xmin) .* rand(1,xsize);
    y = x .^ 2 + rand(1,xsize) ./ 10;
    %[x,ix] = sort(x);
    %y = y(ix);
    % ---
    tic
    yi1 = interp1(x,y,xi);
    t(i) = toc;
end
% ---
figure
plot(t,'-ro'); xlabel('nb elem'); ylabel('time (s)');



