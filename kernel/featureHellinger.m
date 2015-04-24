function y = featureHellinger(x)
% x size axbxc

sizeX = size(x);

if size(x,3)>1
    y = double(reshape(x, prod(sizeX(1:2)), sizeX(3)));
else
    y = x;
end

y = y ./ repmat(sum(y,2)+(sum(y,2)==0), 1, size(y,2) );

y = sqrt(y);

y = double(reshape(y, sizeX));


