function f=obj_function_for_detection_constraints_0(x,param,eta)

%  the contribution to the loss function evaluation of the constraints for
%  detection in the case of JBAS / JBAS-I / JBAS-CI
%  

global lambdaConstTR

f = 0;

for i=1:param.nPics
    
    lambda_1 = param.thresh(i);% the threshold related to lambda0
    lambda_2 = param.thresh2(i); % **** to n - (k-1) lambda0
    
    
    [R1,R2] = constraints_subroutine(x, param.one_pic_bar(:,i), param.one_pic(:,i),lambda_1,lambda_2, param);
    R1      = R1.^3;
    R2      = R2.^3;
    
    
    
    R1 = lambdamize(param.optim.norm_bar, lambdaConstTR, R1);
    R2 = lambdamize(param.optim.norm, lambdaConstTR, R2);

    ff = ones(1,size(x,1)) * (R1) + ones(1,size(x,1)) * (R2);

    f  = f + ff;
end
