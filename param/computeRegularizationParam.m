function [lambda, xDif] = computeRegularizationParam(x, df)

printMessage('Compute regularization param...', 0 , mfilename, 'm');

n       = size(x,1);

xDif    = x ./ sqrt(n);
xDif    = xDif - repmat(mean(xDif,2),1,size(xDif,2));

[u,e,~] = svd(xDif, 'econ');

e       = e.^2;
lambda  = df_to_lambda_eig(df,real(diag(max(e,0)))); 

q       = u(:,real(diag(e)) > n*lambda*1e-2);
xDif    = q' *xDif;

printMessage('done');



