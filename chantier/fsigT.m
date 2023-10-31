function sig = fsigT(T)

if T <= 20
    sig = 10e3;
else
    sig = 10e3 .* (1 - 0.01 .* T);
end
