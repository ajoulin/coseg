function [f_proj,x_proj,step] = backtrackingWithProj(f,x,gradient,step,verbose,fun_set,fun_optim,fun_condtion,varargin)

% on applique la armijo rule dans le cas d'une projection


param.kmax_     = 20 ;
param.beta_     = .25 ;
param.sigma_    = .1 ;
param.step_     = step;

ialpha = 1;

check_solution = 0;

while ialpha<param.kmax_
    
    % projection de x sur le convex set :

    x_proj=feval(fun_set, (x-param.step_*gradient) );

    
    
    %on evalue la cost function sur le projete :
    f_proj =feval(fun_optim, x_proj);
    
    
    % condition de l'AMIJO RULE ( cf. Bertsekas p230 - Nonlinear progr - 2eme edition)
    %f - f_proj >= - sigma_ARMIJO * gradient(:)' * ( x_proj(:) - x(:) )
 
    if feval(fun_condtion,f,f_proj,x,x_proj,gradient,param)
        
         while feval(fun_condtion,f,f_proj,x,x_proj,gradient,param) && ialpha<param.kmax_  
            param.step_        = param.step_  / param.beta_;

            x_proj=feval(fun_set, (x-param.step_*gradient));

 
            f_proj =feval(fun_optim,x_proj);
            
            ialpha = ialpha+1;
            
        end
        
        param.step_ =param.step_ *param.beta_;

        x_proj = feval(fun_set,(x-param.step_*gradient));
     
        f_proj = feval(fun_optim,x_proj);
        check_solution = 1;
        break;
    else
        % backtracking
        % on cherche  un pt verifiant la condition
        % en diminuant le step avant projection
        param.step_            = param.step_  * param.beta_;
    end
    ialpha = ialpha+1;
end

if check_solution==0
    x_proj=x;
    f_proj=f;
end

if verbose==1
    fprintf('f=%.16f - it=%d - dx=%e  \n',f_proj,ialpha,norm(x_proj(:)-x(:)));
end

step = 1;