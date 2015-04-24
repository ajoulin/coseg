function param = computeThreshold(param, projMatrix)

if (param.nClass == 2 || param.nPics==1) && param.nObj==1
    param.one_pic_bar = projMatrix'*param.one_pic_bar;
    
    param.thresh      = 2 * param.optim.tab_lambda0 - sum(param.one_pic)';
    param.thresh2     = sum(param.one_pic)'-2 * param.optim.tab_lambda0;
else
    param.optim.coseg = 1;
    
    param.one_pic_bar = projMatrix'*( 1 - param.one_pic_bar );
    param.thresh2     = 0.9*sum(param.one_pic)'; 
    param.thresh      = 0.1*(sum(sum(param.one_pic(:)))-sum(param.one_pic)') / (param.nPics - 1);
    
    % transform for the elliptope :
    param.thresh      = (param.nClass*param.thresh-sum(param.one_pic_bar)') / (param.nClass-1);
    param.thresh2     = (param.nClass*param.thresh2-sum(param.one_pic)') / (param.nClass-1);
end
