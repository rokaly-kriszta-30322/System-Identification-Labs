n = 30;
for i = 1:n
    if mod(i,2) == 0
        v(n+1-i) = sin(i);
    elseif mod(i,2) == 1
        v(n+1-i)= n-i+1;
    end
end
v
