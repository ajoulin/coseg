function [x,f]=EStep(x0,fun_optim,fun_set,fun_condition,itmax, tol,varargin)


verbose = 0;


it      = 0;
f_old   = 0;
x       = feval(fun_set, x0);

% Stepsize BEFORE projection
step    = 1;


% tolerence d arret :
tol_df  = tol ;


%on commence la decent de gradient projete
while it <= itmax
    
    it  = it+1;

    if it>=2 &&  f_old-f<-1e-8
        fprintf('[ERROR] EStep.m : The function is increasing instead of decreasing\n')
        keyboard
    end
    
    if  it>=3 && ( abs(f_old-f)  < tol_df * abs(f) ) 
        if verbose==1
            fprintf('stopping condition fulfilled\n')
        end
        break;
    end
    

    [f, gradient] = feval(fun_optim, x);

    if it>=2
        f_old = f;
    end

    
    if sum(abs(gradient(:)))==0
        fprintf('[ERROR] EStep.m :  gradient == 0!\n');
        keyboard;
    end
 
    [f,x,step] = backtrackingWithProj(f, x, gradient, step, verbose, fun_set, fun_optim, fun_condition);
   
     
end




