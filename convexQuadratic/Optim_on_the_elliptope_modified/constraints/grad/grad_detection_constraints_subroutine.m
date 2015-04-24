function [T1,T2]=grad_detection_constraints_subroutine(x,...
                                                        one_pic_bar,one_pic,...
                                                        thresh,thresh2,param...
                                                         )

[T1,T2] = constraints_subroutine(x,one_pic_bar,one_pic,thresh,thresh2,param);
T1      = -T1.*T1;
T2      = T2.*T2;


