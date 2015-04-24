function [S]=function_sigmExp(Cp,Cn)



S=exp(Cn)./(1+exp(Cn-Cp));

%S=(exp(C)./(1+exp(C))).*(C<0)+(1./(1+exp(-C))).*(C>0);