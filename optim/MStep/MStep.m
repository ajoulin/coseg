function [distParam,f] = MStep( y ,distParam , x,param , maxIter, tol_f,lapMatrix,projMatrix) 

options.maxIter = maxIter;
options.optTol  = tol_f;

wb                     = zeros(param.dimDescr+1 , param.nClass);
wb(1:param.dimDescr,:) = distParam.a;
wb(param.dimDescr+1,:) = distParam.b;

options.display = 0;

f=0;fold=0;it=0;

while it<100 && (f-fold>tol_f || it<=1)
    fold=f;
    [wb , f ] = minFunc(@(lala)MStepSoftMaxCost(lala, {x, y, param,lapMatrix, projMatrix} ),wb(:),options);
    it=it+1;
end

wb = reshape(wb,param.dimDescr+1,param.nClass);

distParam.a = wb(1:param.dimDescr,:);
distParam.b = wb(param.dimDescr+1,:);


