function L=subroutine_logExp(Cp,Cn)


L=Cp+log(1+exp(Cn-Cp));

%L=C.*(C>0)+log(1+exp(C.*((C<0)-(C>0))));
%L=log(1+exp(C)).*(C<0)+(C+log(1+exp(-C))).*(C>0);
