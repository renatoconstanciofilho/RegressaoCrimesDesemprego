function [yy,b0,b1] = regressao(x,y)
% ?(x?x?)(y?y) / ?(x?x?)2
b1 = sum((x - mean(x)) .* (y - mean(y))) / sum(((x - mean(x)).^2));
% y? ? ?1x?
b0 = (mean(y) - (b1 * mean(x)));
yy = b0 + b1*x
end

