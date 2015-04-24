function [ f , gradient ] = EStepSoftMaxCost( y , distParam, eta, lapMatrix, param , projMatrix )


f = softMaxCost(y, distParam.a(:), distParam.b(:), eta,  param, lapMatrix, projMatrix);



if nargout>1
    
    Y = (param.imFactT>0).*repmat(y, 1 , param.nPics );
    
    eps     = 1e-5;
    sumY    = sum(param.imFactT.*(Y + eps));
    
    
    
    
    tmp = log(sumY+ (sumY==0)  );% + 1e-5 

    tmp = reshape( tmp , param.nClass, param.nPics)';
    
    tmp = param.imInd * tmp;
    
    tmp =  tmp  + repmat(sum(param.imInd,2),1,param.nClass);
        
    %     if param.useMask==1
    %         tmp = tmp .* param.maskInd;
    %     end
    
    gradient =  ( - projMatrix' * eta + lapMatrix * y ) ./ sum(param.lW_px) +  tmp ./ param.nPics ;

    
end
