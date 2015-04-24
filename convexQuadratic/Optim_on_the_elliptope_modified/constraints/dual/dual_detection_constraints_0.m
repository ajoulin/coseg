function subdual=dual_detection_constraints_0(x,param,eta)


global lambdaConstTR

subdual     = zeros(size(param.C));

for i = 1 : param.nPics
    [T2,T1] = dual_detection_constraints_subroutine(x, param.one_pic_bar(:,i), param.one_pic(:,i), param.thresh(i), param.thresh2(i), param);
    subdual = subdual + dual_detection_constraints_subroutine_2(param.one_pic_bar(:,i), param.one_pic(:,i), T1, T2);
end

subdual     = lambdamize(param.optim.norm, lambdaConstTR, subdual);