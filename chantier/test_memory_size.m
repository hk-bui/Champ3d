clear
clc

s1 = 1e5;
s2 = 1e5;
nz = 100:1000:s1;

mem = zeros(1,length(nz));
for i = 1:length(nz)
    M   = spalloc(s1,s2,nz(i));
    wks = whos('M');
    mem(i) = wks.bytes; 
    clear M;
end

memX = zeros(1,length(nz));
MX   = sparse(s1,s2);
for i = 1:length(nz)
    MX  = sparse(1:nz(i),1,sqrt(1:nz(i)),s1,s2);
    wks = whos('MX');
    memX(i) = wks.bytes; 
end


figure
plot(nz,mem,'-ko',nz,memX,'-r*')



