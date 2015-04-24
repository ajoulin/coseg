function f = softMaxCost(y, paramA, paramB, eta,  param, lapMatrix, P)


lambda = param.lambda;

Y = repmat(y, 1, param.nPics);
Y = ( param.imFactT>0 ).*Y;


uN = 1 ./ param.nDescr;

maxEta  = max( eta,[],2 );
ETA     = P' * eta;

f =  - sum(y(:).*ETA(:) );


f = f + 0.5 * trace( y' * lapMatrix * y ) ;
f = f + sum(  log( sum( exp( eta  - repmat( maxEta , 1 , param.nClass ) ) , 2 ) ) + maxEta );

f =  uN* f + .5 * (lambda./ param.nClass) * sum(paramA(:).*paramA(:));


eps     = 1e-5;
sumY    = sum(param.imFactT.*(Y + eps));
f       = f +  sum(sumY.*log( sumY + (sumY==0) ))./param.nPics ;%


f = f + 1e-12 * .5 * sum(paramA(:).^2 )  + 1e-12 * .5 * sum(paramB(:).^2 ) ;






