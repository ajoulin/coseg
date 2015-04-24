function [C1,C2]=subroutine_exp(x,V1,V2,lambda_1,lambda_2,param)

[R1,R2]=constraints_subroutine(x,V1,V2,lambda_1,lambda_2,param);

C1=param.optim.alpha*R1;

C2=param.optim.alpha*R2;