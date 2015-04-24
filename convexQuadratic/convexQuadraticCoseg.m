function [z,zSoft] = convexQuadraticCoseg(param, projMatrix, lapMatrix , xDif)
printMessage('Convex quadratic cosegmentation : BEGIN', 1 , mfilename, 'm');

paramDif                    = param;

if param.useSuperpix == 0
    projMatrix = sparse((1:param.nDescr)',(1:param.nDescr)',1);
end


xDif                        = ridgeKernel( xDif, param.lambda );

paramDif.optim.tab_lambda0  = floor( param.lW_px * param.optim.lambda0 + 1 );


paramDif.one_pic        = createIndexMatrix(param.lW_px, param.nPics, param.nDescr);
paramDif.one_pic_bar    = paramDif.one_pic;
paramDif.one_pic        = projMatrix'*paramDif.one_pic;

paramDif.C              = computeMatrixForConvQuadOptim(param, xDif, lapMatrix, projMatrix);


% define optim / set function for diffrac:

fun_set_diff             = @functions_elliptope;
fun_obj_diff             = @functions_max_cut;
fun_constraints_diff     = @functions_constraints_0;

paramDif = computeThreshold(paramDif, projMatrix);

paramDif.optim.norm      = param.nPics * sum(paramDif.one_pic(:));
paramDif.optim.norm_bar  = param.nPics * sum(paramDif.one_pic_bar(:));


r0      = 2;
y0      = feval(fun_set_diff,'retraction',randn(param.nSupPix,r0),zeros(param.nSupPix,r0));

% OPTIMIZATION:
[yDiffrac, f]   = low_rank_optim(fun_set_diff,fun_obj_diff,paramDif,y0,'TR',fun_constraints_diff);

[z, zSoft]      = main_rounding(yDiffrac, paramDif, diag(projMatrix'*projMatrix));


printMessage('Convex quadratic cosegmentation : END', 1 , mfilename, 'm');



