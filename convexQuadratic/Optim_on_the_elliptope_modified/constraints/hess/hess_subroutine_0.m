function subhess=hess_subroutine_0(x,eta,one_pic,lambda_1,epsilon,signe)

sum_x=sum_x_over_V(x,one_pic);

sum_eta=sum_x_over_V(eta,one_pic);

R=(x*sum_x');

R1=x_plus(signe*(R-lambda_1),epsilon);

T1=signe*R1.*R1;

subhess=3*(one_pic*(T1'*eta)+(T1)*sum_eta);

R_x=x_over_V(x,R1);

R_eta=x_over_V(eta,R1);

subhess=subhess...
        +6*(...
        one_pic*( (x*sum_eta'+eta*sum_x')'*R_x)...
        +R_eta*(sum_x'*sum_x)...
        +R_x*(sum_eta'*sum_x)...
        );
    