function varargout=line_search2(varargin)

% Inputs:
fun_set=varargin{1};
fun_obj=varargin{2};
x0=varargin{3};
param=varargin{4};
fun_constraints=varargin{5};

%--------------------------------------------


if nargin>5,
    accuracy=varargin{6};
else
    accuracy=5e-6;
end
if nargin>6,
    max_iter=varargin{7};
else
    max_iter=5e3;
end
if nargin>7,    
    eta=feval(fun_set,'project',x0,varargin{8});
end

% Initialization:
x=x0;
f=feval(fun_set,'f',x0,fun_obj,param,fun_constraints);
tic
time=toc;
%FF2=feval(fun_set,'f_rank1',x0,param);
iter=1;

% Optimization:
while 1
    % Search direction:
%     switch dir_type
%         case 'gradient'
            grad = feval(fun_set,'grad_f',x,fun_obj,param,fun_constraints);
            eta=-grad;

%         case 'conjugate gradient'
%             if iter==1,
%                 grad=feval(fun_set,'grad_f',x,fun_obj,param);
%                 eta=-grad;
%             else
%                 grad_old=grad;
%                 eta_old=eta;
%                 grad=feval(fun_set,'grad_f',x,fun_obj,param);
%                 % Fletcher-Reeves:
%                 % beta=feval(fun_set,'metric',x,grad,grad,param)/feval(fun_set,'metric',x,grad_old,grad_old,param);
%                 % Polak-Ribi�re:
%                  %beta=feval(fun_set,'metric',x,grad,grad-feval(fun_set,'project',x,grad_old,param),param)/feval(fun_set,'metric',x,grad_old,grad_old,param);
%                 % Conjugate direction with respect to the Hessian
%                  beta=feval(fun_set,'metric',x,feval(fun_set,'project',x,eta_old,fun_obj,param),feval(fun_set,'hessian',x,grad,fun_obj,param),param)...
%                     /feval(fun_set,'metric',x,feval(fun_set,'project',x,eta_old,fun_obj,param),feval(fun_set,'hessian',x,feval(fun_set,'vector transport',x,t*eta_old,eta_old,param),fun_obj,param),param);
%                 eta=-grad+beta*feval(fun_set,'project',x,eta_old,param);
%             end
%    end
    t=armijo(fun_set,x,eta,fun_obj,param,fun_constraints);
    x_new=feval(fun_set,'retraction',x,t*eta,param);
    f(end+1)=feval(fun_set,'f',x_new,fun_obj,param,fun_constraints);
    time(end+1)=toc;

 %   if iter>=max_iter %| abs(f(end)-f(end-1))/abs(f(1)-f(end))<accuracy | norm(grad,'fro')<accuracy,
    if iter>=max_iter | norm(grad,'fro')<accuracy,
    if iter>=max_iter, disp('max number of iterations reached'), end
    %sqrt(feval(fun_set,'metric',x,grad,grad))
        break
    end

    %New iterate
    x = x_new;
    iter=iter+1;
end

varargout{1}=x; 
varargout{2}=f(end);
% varargout{3}=eta;
% varargout{2} = iter;
% if nargout >= 3,
%     varargout{3} = f;
%     varargout{4} = time;
% end

%==========================================================================
function t=armijo(fun_set,x0,eta,fun_obj,param,fun_constraints)
% beta=0.2; sigma=0.1; t=0.5;

beta=0.5; sigma=0.01; t=2;
x=x0;
grad=feval(fun_set,'grad_f',x,fun_obj,param,fun_constraints);
f=feval(fun_set,'f',x,fun_obj,param,fun_constraints);
Delta=1;
while ~(Delta<0),
    t=t*beta;    
    Delta=feval(fun_set,'f',feval(fun_set,'retraction',x0,t*eta,param),fun_obj,param,fun_constraints)-f-sigma*feval(fun_set,'metric',x,grad,t*eta,param);
    if t<1e-9,
        t=0;
        break
    end
end
varargout{1}=feval(fun_set,'retraction',x0,t*eta,param);



