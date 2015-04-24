function [distParam, y0] = initModel(z,  x, param, lapMatrix, projMatrix)


distParam.a = rand(param.dimDescr , param.nClass);
distParam.b = rand(1 , param.nClass);

if numel(z)~=1 && param.initDiffrac
    printMessage('EM initialization with cvpr10',1,mfilename,'m');
    y0 =z;
else
    printMessage('random EM initialization',1,mfilename,'m');

    y0 = rand( param.nSupPix , param.nClass );
    
    if param.useMask==1
        y0 = y0.*(param.maskInd);
    end
    
    
     y0 =y0./repmat(sum(y0,2),1,param.nClass);
end


[distParam , ~] = MStep(y0, distParam , x, param, 100 , 1e-6, lapMatrix , projMatrix);


