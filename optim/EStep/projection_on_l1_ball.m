function [x_proj,lambda_star]=projection_on_l1_ball(x,a)
% [x_proj,lambda_star]=projection_on_l1_ball(x,a)
% projection of x on the l1_ball with radius a

if nargin<2
    a=1;
end

%ordonnons les eigenvalues
[xs,id]=sort(x);

i=0;
S=0;

while  (i<size(xs,1) && ( xs(end-i) -1./(i+1)*(S+xs(end-i)-a) ) > 0 ) 
    S=S+xs(end-i);
    i=i+1;    
end

if i~=0
    lambda=1./(i)*(S-a);
else 
    x=(x==max(x));
    lambda=0;
end


x_proj=max(x-lambda,0);


if nargout>1
    lambda_star=lambda;
end