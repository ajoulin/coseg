% Compute solution from Joulin et. al. cvpr'10 and Joulin et al. cvpr'12




computeParameters;% Parameters setting





%%%%%%%%%% Create Mask %%%%%%%%%%%

if param.useMask == 1
    param = maskCreator(param);
end


%%%%%%%%%% OPEN FEATURES %%%%%%%%%%%%

[descr, param] = openFeature(param);


%%%%%%%%%% Compute map related to kernel %%%%%%%%%%%%

descr.data = funKernel(descr.data);

[ param.nDescr param.dimDescr] = size(descr.data);

%%%%%%%%%% Compute lambda (regularization parameter) %%%%%%%%%%%%%

[param.lambda, xDif] = computeRegularizationParam(descr.data', param.df);

if param.onlyDiffrac==0 && param.initDiffrac==0
    clear xDif
end


%%%%%%%%%% Compute the binary term (Laplacian matrix) %%%%%%%%%%%%%%%

lapMatrix = LaplacianMatrix(descr, param);


%%%%%%%%%% Open superixels %%%%%%%%%

if param.useSuperpix == 1
    [projMatrix, supPixIndices, param] = openSuperpixel(descr, param);
    lapMatrix = projMatrix' * lapMatrix * projMatrix;
end

lapMatrix = param.lapWght * lapMatrix;


%%%%%%%%%%%%%%%% CVPR'10 %%%%%%%%%%%%%%%%%%%%

if (param.initDiffrac || param.onlyDiffrac)
    [labelsDif, labelsDifSoft] = convexQuadraticCoseg(param, projMatrix, lapMatrix, xDif);
    
    if param.ViewOn == 1
        plot_groups(param , labelsDif, supPixIndices, 430, 'Joulin et al., CVPR10');
    end
    
    if param.onlyDiffrac
        return
    end
    
end

%%%%%%%%%%%%%%%% CVPR'12 %%%%%%%%%%%%%%%%%%%%

param = createGroupIndexMatrix(param, descr, projMatrix);

%%%%%%%%%%%%%

if param.initDiffrac
    [distParam , y0 ]    = initModel(labelsDifSoft, descr.data, param, lapMatrix, projMatrix);
    [ y , ~, f ]         = EMAlgo(y0 , distParam,   descr.data, lapMatrix, param, projMatrix, 1000);
    
    if  param.ViewOn == 1
        plot_groups(param, y , supPixIndices, 312, 'Joulin et al., CVPR12 - still running');
    end
end

for it=1 : param.itMax
    [distParamT , y0 ]      = initModel(1,  descr.data, param, lapMatrix, projMatrix);
    [ yT , distParamT, fT ] = EMAlgo(  y0 , distParamT  ,   descr.data , lapMatrix , param , projMatrix ,1000);
    
    if (it==1 && ~param.initDiffrac) || fT < f
        f   = fT;
        y   = yT;
        
        if  param.ViewOn == 1
            plot_groups(param, y , supPixIndices, 312, 'Joulin et al., CVPR12 - still running');
        end
    end
end

if  param.ViewOn == 1
    plot_groups(param, y , supPixIndices, 312, 'Joulin et al., CVPR12');
end

return

