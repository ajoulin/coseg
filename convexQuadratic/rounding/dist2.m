function n2 = dist2(x, c)


[ndata, dimx] = size(x);
[ncentres, dimc] = size(c);
 
n2 = (ones(ncentres, 1) * sum((x.^2)', 1))' + ...
  ones(ndata, 1) * sum((c.^2)',1) - ...
  2.*(x*(c'));

% Rounding errors occasionally cause negative entries in n2
if any(any(n2<0))
  n2(n2<0) = 0;
end