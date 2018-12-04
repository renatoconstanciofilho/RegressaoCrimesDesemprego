function [yret] = calcula_y(B, x)
yret = B(length(B));
e = 1;
for i = (length(B)-1):-1:1
    yret = yret + (B(i) * (x.^e));
    e = e + 1;
end
end