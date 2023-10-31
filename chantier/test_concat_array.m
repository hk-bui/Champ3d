

lena = 1000000;
arrr = 1:1:lena;
% ---
face = [];
for i = 1:10
    face = [face arrr];
end
% ---
face = [];
for i = 1:10
    face((i-1)*lena+1 : i*lena) = arrr;
end