function subhess=hess_detection_constraints_0(x,param,eta)

%  the contribution to the hessian evaluation of the constraints for
%  detection in the case of JBAS / JBAS-I / JBAS-CI
% 

global lambdaConstTR



subhess = zeros(size(x));

for i=1:param.nPics
    lambda_1 = param.thresh(i);
    lambda_2 = param.thresh2(i);
    
    
    tmp     = hess_subroutine_0(x, eta, param.one_pic_bar(:,i), lambda_1, param.optim.epsilon, -1);
    tmp     = lambdamize( param.optim.norm_bar, lambdaConstTR,tmp);
    subhess = subhess + tmp;
    tmp     = hess_subroutine_0(x, eta, param.one_pic(:,i), lambda_2, param.optim.epsilon, 1);
    tmp     = lambdamize(param.optim.norm_bar, lambdaConstTR, tmp);
    subhess = subhess + tmp;
    
end

       
            