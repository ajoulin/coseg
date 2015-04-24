function [f, grad] = MStepSoftMaxCost(W, auxdata)
%function [f, grad] = MStepSoftMaxCost(W, x, y, param, imFactT, lapMatrix, P)

[x, y, param, lapMatrix, P] = deal(auxdata{:});

WM      = reshape(W, param.dimDescr+1, param.nClass);

eta     = x * WM(1:param.dimDescr, :) + repmat(WM(param.dimDescr+1,:), size(x,1), 1);

f       = softMaxCost(y,  WM(1:param.dimDescr,:), WM(param.dimDescr+1,:), eta,  param, lapMatrix, P);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




if nargout > 1
    grad =  MStepSoftMaxGradient(W, auxdata);
end

return;

