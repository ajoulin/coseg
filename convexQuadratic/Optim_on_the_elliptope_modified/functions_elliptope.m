function varargout=functions_elliptope(varargin)
% This function defines the geometry of the quotient manifold M/O_p,
% where O_p is the orthogonal group and M={Y \in R^{n \times p} s.t. diag(Y Y')=1}
%
% Reference: 
% M. Journ�e, F. Bach, P.-A. Absil and R. Sepulchre, Low-rank optimization for semidefinite convex problems, arXiv:0807.4423v1, 2008
%


type        = varargin{1};
fun_set     = @functions_elliptope;
switch type,
    case 'metric',              
        eta     = varargin{3};
        zeta    = varargin{4};
        f       = 0;
        for i = 1 : size(eta,2),
            f   = f + eta(:,i)'*zeta(:,i);
        end
        varargout{1} = f;%trace(eta'*zeta);

    case 'project',             % Projection
        x   = varargin{2};
        eta = varargin{3};%======================ICI : hessian %======================ICI : grad
        SS  = x'*x;           
        mat = x'*eta;%======================ICI : hessian %======================ICI : grad
        AS  = mat-mat';  
        O   = sylvester(SS,AS);
        
        %eta_d=aux_fct(x,eta,x);  
        eta_d = aux_fct_new(x,eta,x); 
        
        varargout{1} = eta-x*O-eta_d;
    
    case 'retraction',         
        x       = varargin{2};
        eta     = varargin{3};
        x       = x + eta;   
        x_proj  = normalize_rows_new(x);
        
        varargout{1} = x_proj;
    case 'f',                   
        x               = varargin{2};
        fun_obj         = varargin{3};
        fun_constraints = varargin{4};
        param           = varargin{5};
        varargout{1}    = feval(fun_obj,'f',x, fun_constraints, param);              
        
    case 'grad_f',      
        x               = varargin{2};
        fun_obj         = varargin{3};
        fun_constraints = varargin{4};
        param           = varargin{5};
        grad=feval(fun_obj,'grad_f',x,fun_constraints,param);%======================ICI : grad
        varargout{1} = feval(fun_set,'project',x,grad);%======================ICI : grad

    case 'hessian',
        x       = varargin{2};
        eta     = varargin{3};
        fun_obj = varargin{4}; 
        fun_constraints = varargin{5};
        param = varargin{6};
        
        grad=feval(fun_obj,'grad_f',x,fun_constraints,param);
        hess=feval(fun_obj,'hessian',x,eta,fun_constraints,param);
        SS=x'*x;
        xT_grad=x'*grad;
        AS=xT_grad-xT_grad';
        skew=sylvester(SS,AS);
        etaT_grad=eta'*grad;
        xT_hess=x'*hess;
        xT_eta=x'*eta;
        skew_xT_eta_xT_eta=skew*(xT_eta+xT_eta');
        AS2=etaT_grad-etaT_grad'+xT_hess-xT_hess-skew_xT_eta_xT_eta-skew_xT_eta_xT_eta';
        Dskew=sylvester(SS,AS2);
        
        %         eta_grad_x=aux_fct(eta,grad,x);
        %         x_hess_x=aux_fct(x,hess,x);
        %         x_grad_eta=aux_fct(x,grad,eta);
        
        eta_grad_x=aux_fct_new(eta,grad,x);
        x_hess_x=aux_fct_new(x,hess,x);
        x_grad_eta=aux_fct_new(x,grad,eta);
        
        hess=hess-eta*skew-x*Dskew-eta_grad_x-x_hess_x-x_grad_eta;
        varargout{1}=feval(fun_set,'project',x,hess);
                   
   case 'dual',                     % Dual variable
       x = varargin{2};
       fun_obj = varargin{3};
       fun_constraints = varargin{4};
       param = varargin{5};
       
       S=feval(fun_obj,'dual',x,fun_constraints,param);
       varargout{1}=S-diag(diag(S*x*x'));

end

