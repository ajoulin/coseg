function L = LaplacianMatrixForOneImage(x, y, Im)


delta = max( x(2:end,1) - x(1:end-1,1) );

minX = min(x); maxX = max(x);
minY = min(y); maxY = max(y);

subIm = Im( minY:delta:maxY,minX:delta:maxX ,:);

[i j v] = graphLap( permute(double(subIm), [ 2 1 3]),2);

n = numel( subIm )/3;

L = sparse(i+1,j+1,v,n,n);

L = L.*(L>1e-5);

tmp = 1./sum(L).^.5;
I   = (1:size(tmp(:)))';

D   = sparse(I,I,tmp);
Id  = sparse(I,I,1);
L   = Id - D*L*D;
