function varargout=functions_max_cut(varargin)
% This function defines the objective related to the max cut problem
% R^{n \times p} -> R : Y -> f(Y)= Tr(Y'*A*Y)
% It furthermore provides its gradient and hessian as well as the dual
% variable.
%
% Reference: 
% M. Journ�e, F. Bach, P.-A. Absil and R. Sepulchre, Low-rank optimization for semidefinite convex problems, arXiv:0807.4423v1, 2008
%


type    = varargin{1};
x       = varargin{2};

switch type,       
    case 'f',           % Objective
        fun_constraints = varargin{3};
        param           = varargin{4};
        
        f = 0;
        for i = 1 : size(x,2), 
            f = f + x(:,i)' * (param.C * x(:,i));
         end
        
        % contraintes :            
        ff  = feval(fun_constraints,type,x,param,[]);
        f   = f + ff;
        
        varargout{1} = f;
    
    case 'grad_f',        % gradient on the Euclidean space R^{n \times p}    
        fun_constraints = varargin{3};
        param           = varargin{4};
        
        varargout{1} = 2 * (param.C * x) + feval(fun_constraints,type,x,param,[]);

    case 'hessian',     % Hessian in the direction eta on the Euclidean space R^{n \times p}
        eta             = varargin{3};
        fun_constraints = varargin{4};
        param           = varargin{5};
        
        varargout{1} = 2 * (param.C * eta) + feval(fun_constraints, type, x, param, eta);
      
    case 'dual',         % dual variable
        fun_constraints = varargin{3};
        param           = varargin{4};
        varargout{1}    = param.C + feval(fun_constraints,type,x,param,[]);
end

