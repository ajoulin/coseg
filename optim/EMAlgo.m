function [ y , distParam , f ] = EMAlgo(y, distParam, x, lapMatrix, param ,  projMatrix, it_max)
verbose = 0;

printMessage('EM optimization: BEGIN',1,mfilename,'m');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% EM ALGO

it      = 0;
Tol     = 1e-4;
maxIter = 1000;

while it< it_max 

    it = it+1;
    
     
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % M-step:
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    [distParam , f] = MStep( y, distParam , x , param , maxIter, Tol, lapMatrix, projMatrix);
        
    if 1
        printMessage(sprintf(' + M-step + f = %f' , f));
    end
    
    if exist('fOld' , 'var') && f-fOld > Tol
        printMessage('Wrong Mstep', 1, mfilename, 'e');
        keyboard
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %E-STEP:
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if exist('y' , 'var')
        yOld = y;
    end
   
    % compute here for speed issue
    %a =  P'* (x * distParam.a + repmat(distParam.b , size(x,1) , 1) );
    
    a               =   (x * distParam.a + repmat(distParam.b , size(x,1) , 1) );
    fun_optim       =   @(y) EStepSoftMaxCost( y  , distParam, a , lapMatrix, param, projMatrix);
    
    fT = f;
    [y , f]         = EStep(y , fun_optim , @(x)fun_proj_l1(x,param) , @condition_ARMIJO , maxIter, Tol);
    
    
    
    if 1
        printMessage(sprintf(' + E-step + f = %f' , f));
    end
    
    if f - fT > Tol
        printMessage('Wrong Estep', 1, mfilename, 'e');
        keyboard
    end
    
    if exist('fOld' , 'var') && fOld-f < Tol
        
        if exist('lastIter','var') && lastIter==1
            break
        end
        
        maxIter     = min(maxIter*10,1000);
        Tol         = max(Tol*0.1, 1e-5);
        
        lastIter    = 1;
    else
        lastIter    = 0;
    end
    
    fOld = f;
 
end

printMessage(sprintf('End: it = %i => l = %f',max(it-1,1),f));

printMessage('EM optimization: END',1,mfilename,'m');
