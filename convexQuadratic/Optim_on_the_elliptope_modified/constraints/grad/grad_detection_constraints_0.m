function subgrad=grad_detection_constraints_0(x,param,eta)

%  the contribution to the gradient evaluation of the constraints for
%  detection in the case of JBAS / JBAS-I / JBAS-CI
% 


global lambdaConstTR


sum_x       = sum_x_over_V(x, param.one_pic(:,1));
sum_x_bar   = sum_x_over_V(x, param.one_pic_bar(:,1));

[T1 ,T2 ] = constraints_subroutine(x,param.one_pic_bar(:,1), param.one_pic(:,1),param.thresh(1),param.thresh2(1),param);

T1 = -3 * T1 .* T1;
T2 =  3 * T2 .* T2;

T1 = lambdamize(param.optim.norm_bar,lambdaConstTR,T1);
T2 = lambdamize(param.optim.norm,lambdaConstTR,T2);

subgrad =           (T2 * sum_x     + param.one_pic(:,1)     * (T2' * x));
subgrad = subgrad + (T1 * sum_x_bar + param.one_pic_bar(:,1) * (T1' * x));

for i=2:param.nPics
    
    sum_x       = sum_x_over_V(x, param.one_pic(:,i));
    sum_x_bar   = sum_x_over_V(x, param.one_pic_bar(:,i));

    [T1 ,T2 ] = constraints_subroutine(x, param.one_pic_bar(:,i), param.one_pic(:,i),param.thresh(i),param.thresh2(i),param);
    
    T1 = -3*T1.*T1;
    T2 = 3*T2.*T2;
    
    T1 = lambdamize(param.optim.norm_bar,lambdaConstTR,T1);
    T2 = lambdamize(param.optim.norm,lambdaConstTR,T2);
    
    subgrad = subgrad + (T2 * sum_x      + param.one_pic(:,i)     * (T2' * x));
    subgrad = subgrad + (T1 * sum_x_bar  + param.one_pic_bar(:,i) * (T1' * x));
    
end