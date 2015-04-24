function X=duplicate(x,nd)
[n d] = size(x);
X=repmat(x,1,nd)';
X=X(:);
X=reshape(X,d,n*nd)';