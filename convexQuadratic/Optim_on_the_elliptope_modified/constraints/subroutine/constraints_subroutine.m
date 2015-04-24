function [R1,R2]=constraints_subroutine(x,V1,V2,lambda_1,lambda_2,param)

%
% Dans le cas de la detection   V1=V2=one_pic
%
% Dans le cas de la co-seg      V1=one_pic_bar et V2=one_pic ( oppose de
% one_pic)
%


[R1] = constraints_subsubroutine(x,V1,lambda_1,-1,param);
[R2] = constraints_subsubroutine(x,V2,lambda_2,1,param);
