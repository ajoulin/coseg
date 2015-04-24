function grad =  MStepSoftMaxGradient(W, auxdata)

[x, y, param, lapMatrix, P] = deal(auxdata{:});

WM      = reshape(W, param.dimDescr+1, param.nClass);

eta     = x * WM(1:param.dimDescr, :) + repmat(WM(param.dimDescr+1,:), size(x,1), 1);


lambda  = param.lambda;

if size(y,1)~=size(eta,1)
    Y = P * y;
else
    Y = y;
end

maxeta  = max( eta,[],2 );

q = exp( eta  - repmat( maxeta, 1 , param.nClass ) );
q = q ./ repmat(sum(q,2), 1, param.nClass);

grad = [ x' * ( q - Y ) ; sum(q - Y)];


grad = grad ./ param.nDescr;

grad(1:param.dimDescr,:) = grad(1:param.dimDescr,:) + lambda ./ param.nClass  * WM(1:param.dimDescr,:);

grad = grad(:);
grad = grad + 1e-12 * W;
