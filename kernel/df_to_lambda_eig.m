function lambda = df_to_lambda_eig(df,e)


e = e(e>1e-12);
n = length(e);
if df>n-1e-12, df=n-1; end


% binary search on log(lambda)
a = 0;
b = 0;

% first increase b and decrease a to
while sum(  e./ ( n * exp(b) + e ) ) > df, b = b + 1; end
while sum(  e./ ( n * exp(a) + e ) ) < df, a = a - 1; end
while (b-a)>1e-12
         c=(a+b)/2;
         if sum(  e./ ( n * exp(c) + e ) ) > df, a = c; else b=c; end
end

lambda = exp((a+b)/2);

% n = length(e);
% if df>n+1e-12, lambda = NaN; return; end
% if df>n-1e-12, df=length(e)-1; end
% 
% 
% % % % binary search
% 
% a = 0;
% b = .5 * ( df + n );
% b = 1/min(e) * b/n / ( 1 - b/n);
% 
% i=1;
% while (b-a)/(b+a)>1e-12
%     i=i+1;
%     c=(a+b)/2;
%     if sum(  c * e./ ( 1 + c*e ) ) > df, b = c; else a=c; end
% if (i>1000), keyboard; end
% end
% lambda =c;
