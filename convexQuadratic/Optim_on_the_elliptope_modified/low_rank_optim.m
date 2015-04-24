function varargout=low_rank_optim(varargin)
% This function solves optimization programs defined in terms of a
% symmetric positive semidefinite matrix X via the low rank factorization X=YY'.
%
% [y,f]=low_rank_optim(fun_set,fun_obj,param,y0) returns the solution.
%
% *** inputs ***
% fun_set: function handle that defines the feasible set
% fun_obj: function handle that defines the cost function, its gradient and hessian
% param:   cell array containing values of parameters to be passed to the cost function
% y0:      initialization
%
% *** outputs ***
% y:       solution
% f:       cost function at the solution
%
%
% Refer to M. Journ�e, F. Bach, P.-A. Absil and R. Sepulchre, Low-rank optimization for semidefinite convex problems, arXiv:0807.4423v1, 2008
%

fun_set         = varargin{1};
fun_obj         = varargin{2};
param           = varargin{3};
y0              = varargin{4};
type            = varargin{5};
fun_constraints = varargin{6};

epsilon  = 1e-6;
epsilon2 = epsilon;


restart_mod = 0;


delta       = 1;



[n,p_init]  = size(y0);
p           = p_init;
opts.disp   = 0;
opts.tol    = 5e-4;

options     = struct('TolFun',1e-6,'TolX',1e-6,'GradObj','on','StoreN',3,'Display','off','LargeScale','on','HessUpdate','lbfgs','InitialHessType','identity','GoalsExactAchieve',0);

%save data param

opts_RTR.verbosity  = 0;
opts_RTR.tol        = 1e-6;


while 1
    
    if p~=p_init && sum(size(new_dir))==0,
        rdnp    = randn(n,p);
        znp     = zeros(n,p,class(y0));
        
        if strcmp(class(y0),'single')
            rdnp = single(rdnp);
        end
        
        y0 = feval(fun_set, 'retraction', rdnp, znp);
        
        disp('random restart')
        
    elseif p~=p_init,
        
        y00 = feval(fun_set,'retraction', [y zeros(n,p-p_old)], zeros(n,p));
        y01 = line_search(fun_set, fun_obj, y00, new_dir, param, fun_constraints);
        f0  = feval(fun_set,'f',y00, fun_obj, fun_constraints, param);
        f1  = feval(fun_set,'f',y01, fun_obj, fun_constraints, param);
        
        if f1<f0 && abs(f1-f0)>0%1e-8,
            y0 = y01;
        else
            rdnp = randn(n,p);
            znp  = zeros(n,p,class(y0));
            
            if strcmp(class(y0),'single')
                rdnp = single(rdnp);
            end
            
            y0 = feval(fun_set,'retraction',rdnp,znp,param);
            disp('random restart')
        end
    end
    
    switch type
        case 'TR',
            [y,f] = Trust_regions(fun_set,fun_obj,y0,param,fun_constraints);  % trust-region optimization on the quotient manifold
        case 'LS'
            [y,f] = line_search2(fun_set,fun_obj,y0,param,fun_constraints);
    end
    
    VP=svd(y);
    
    if restart_mod==0
        S = feval(fun_set,'dual',y,fun_obj,fun_constraints,param);        % dual variable
        S = 0.5*(S+S');
        S = double(S);
        [V,S_min] = eigs(S,1,'SA',opts);
        S = single(S);
        fprintf(1,'Rank: %2.0f \t min(eig(S)): %5.4f \t  min(VP):%5.9f  \t Objective: %8.5f \n',p,S_min,min(VP),f)
    else
        fprintf(1,'Rank: %2.0f \t \t  min(VP):%5.9f  \t Objective: %8.5f \n',p,min(VP),f)
    end
    
    
    %if S_min>-epsilon || min(VP)<epsilon2 ||p>=n,
    if min(VP)<epsilon2 || ( p>=1 && restart_mod~=0 ) || (restart_mod==0 && S_min>-epsilon)
        break
    end
    
    p_old  =p;
    
    
    
    p=p+delta;% WARNING !!!!!
    
    
    
    if restart_mod==0
        dir_0=V*[zeros(1,p-delta) delta];
        if trace(dir_0'*S*dir_0)<-1e-10,   % descent direction
            new_dir=dir_0;
        else
            new_dir=[];
        end
        opts.v0=V;
    else
        V=randn(n,1);
        new_dir=[];
    end
    %clear S V dir_0
end
clear S V
varargout{1}=y;
varargout{2}=f;


global lambdaConstTR
clear lambdaConstTR





%%
function varargout=line_search(varargin)
% This function performs a line search in a given direction to minimize the
% objective

% Inputs:
fun_set=varargin{1};
fun_obj=varargin{2};
x0=varargin{3};
eta=varargin{4};%feval(fun_set,'project',x0,varargin{4});
param=varargin{5};
fun_constraints=varargin{6};

f0=feval(fun_set,'f',x0,fun_obj,fun_constraints,param);
beta=0.6; sigma=0; t=2;
x=x0;
grad=feval(fun_set,'grad_f',x,fun_obj,fun_constraints,param);
f=feval(fun_set,'f',x,fun_obj,fun_constraints,param);
Delta=1;
while ~(Delta<0),
    t=t*beta;
    Delta=feval(fun_set,'f',feval(fun_set,'retraction',x0,t*eta,param),fun_obj,fun_constraints,param)-f-sigma*feval(fun_set,'metric',x,grad,t*eta,param);
    if t<1e-9,
        t=0;
        break
    end
end
varargout{1}=feval(fun_set,'retraction',x0,t*eta,param);

    
