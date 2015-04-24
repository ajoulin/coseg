function [T2,T1]=dual_detection_constraints_subroutine(x,one_pic_bar,one_pic,lambda_1,lambda_2,param)


[T1,T2]=constraints_subroutine(x,one_pic_bar,one_pic,lambda_1,lambda_2,param);

T1=-T1.*T1;
T2=T2.*T2;


% id_im=one_pic*ones(1,size(x,2));
% sum_x=sum(x.*id_im);
% 
% T=(x*sum_x');
% 

% T1=-(-T+lambda_1).*(-T+lambda_1);
% T1=T1.*((-T+lambda_1)>1e-1);
% T2=(T-lambda_2).*(T-lambda_2);
% T2=T2.*((T-lambda_2)>1e-1);

