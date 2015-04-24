function param = createGroupIndexMatrix(param, descr, projMatrix)


imInd = createIndexMatrix(param.lW_px, param.nPics, param.nDescr);

if param.useSuperpix == 1
    imInd = projMatrix' * imInd;
end

param.imInd     = imInd ./ repmat(param.lW_px',size(imInd,1) ,1);
param.imFactT   = reshape(repmat(param.imInd, param.nClass , 1 ), size(imInd,1) , param.nClass*size(imInd,2) );

if param.useMask == 1
    [param]         = maskIndicator(param,descr);
    param.maskInd   = projMatrix' * param.maskInd;
    param.maskInd   = param.maskInd > repmat(max(param.maskInd,[],2)*.7,1,param.nClass);

    tmp             = repmat(param.maskInd, 1, param.nPics);
    param.imFactT   = param.imFactT.* tmp;
end



