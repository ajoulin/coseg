function xx = chi2Kernel(x, paramKernel, df)

if ~isempty(df)
    mmax = min(1000,4*df);
else
    mmax = 1000;
end

n = size(x,2);
compName = computer;
printMessage('Computing kernel (mex file)....', 0 , mfilename, 'm');
if exist('icdChi2','file')==3
    [xx, P, m] = icdChi2(single(x), single(paramKernel), single(n*1e-8),int32(min(n,mmax)));
else
    [xx, P, m] = icd_chi2(double(x), double(paramKernel) ,n*1e-8, (min(n,mmax)));
end

[~,Pi]=sort(P);
clear P
xx = xx(Pi,1:m);
clear Pi
printMessage('done');

