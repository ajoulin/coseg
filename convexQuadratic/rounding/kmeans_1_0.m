function [z,mu,y,cost] = kmeans_1_0(data,kkk, varargin)
% REQUIRED PARAMETERS
% data : d x n array
% kkk : number of clusters
%
data = data';
[ndata, data_dim] = size(data);

% OPTIONAL PARAMETERS
spherical = 0;              % orthogonal centroids
centres = [];               % center initialisation (default = random);
weights = ones(ndata,1);    % weights
iter_max = 1000;            % maximum number of iterations
lambda0 = 0;                % minimum number of elements per cluster

args = varargin;
nargs = length(args);
for i=1:2:nargs
    switch args{i},
        case 'spherical',        spherical = args{i+1};
        case 'centres',          centres = args{i+1};
        case 'weights',          weights = args{i+1};
        case 'iter_max',         iter_max = args{i+1};
        case 'lambda0',          lambda0 = args{i+1};
    end
end

if ~isempty(centres),
    centres = centres';
else
    % take a random set
    rp = randperm(ndata);
    centres = data(rp(1:kkk),:);
end
[ncentres, dim] = size(centres);

% CHECKING DIMENSIONS
if dim ~= data_dim
    error('Data dimension does not match dimension of centres')
end

if ndata ~= length(weights)
    error('Wrong number of weights');
end

if (ncentres ~= kkk)
    error('Wrong number of centers')
end

n=ndata;



% Matrix to make unit vectors easy to construct
id = eye(ncentres);
z = [];

% Main loop of algorithm
for n = 1:iter_max


    % Assign centroids (E-step)
    d2 = dist2(data, centres);
    oldz = z;
    [minvals, z] = min(d2', [], 1);
    change = 0;

    % enforce minimum cluster size
    if lambda0 >0
        z=z;
        post = id(z,:);
        num_points = sum(post .* repmat( weights,1,kkk ), 1);
        while any(num_points<lambda0)
            change = 1;
            % compute all delta costs of all reassignements
            deltacost = repmat( weights, 1 , kkk) .* ( d2 - repmat( sum( d2 .* post, 2 ),1,kkk) );
            % NB: must all be positive if no negative constraints

           
            % if length(find(num_points<=lambda0))>=2, keyboard; end
            % only consider the ones with a progress towards meeting the minimum number of elements requirements
            adding_one_point = max( lambda0 -  repmat( num_points, ndata , 1 ) - repmat( weights, 1 , kkk) , 0) ... % new
                - max( lambda0 -  repmat( num_points, ndata , 1 ) , 0);    % old
            changing_that_point = repmat( max(lambda0 - sum( post.* repmat( num_points, ndata , 1 ) , 2 ), 0) ... % old
                - max( lambda0 -  sum( post.* repmat( num_points, ndata , 1 ) ,2) + weights,0) , 1, kkk ); %new

            ind_non_ok =  find( adding_one_point - changing_that_point >= 0 );

            deltacost(ind_non_ok) = Inf;
            %             deltacost = deltacost + post*1e100;
            %             deltacost(find(deltacost>1e99))=Inf;
            % take the minimum cost move ....
            [ a1,b1] = min(deltacost);
            [a2,b2]=min(a1);
            if isinf(a2);
                fprintf('cannot make it more than lambda0!\n');
                break;
            end
            z(b1(b2))=b2;
            post = id(z,:);
            num_points = sum(post .* repmat( weights,1,kkk ), 1);
            % sum( max(lambda0 - num_points,0))
        end

    end


    % now we can make local searches to optimize locally
    % only if there was a change
    if change,
        z=z;
        a2=-1;
        while a2<-1e-12  % while there is still some positive cost decrease
            
            post = id(z,:);
            num_points = sum(post .* repmat( weights,1,kkk ), 1);
            
            improvements = repmat( weights, 1 , kkk) .* ( d2 - repmat( sum( d2 .* post, 2 ),1,kkk) );

            
            % find saturated cluster
            ind=find(num_points==lambda0);
            for i=1:length(ind), improvements = improvements + repmat(post(:,ind(i)),1,kkk)*1e100; end

           


            [a,b]=min(improvements,[],2);
            [a2,b2] = min(a);
            if a2<-1e-12
                fprintf('p');
                % moving b2 to b(b2)
                y(b2,:)=0;
                y(b2,b(b2))=1;
            end
            z=indmat2class(post)+1;
        end

        if n>1
            % compute costs of old z and new z
            oldcost = sum( sum( repmat( weights, 1 , kkk) .* d2 .* class2indmat(oldz-1,kkk) ) );
            newcost = sum( sum( repmat( weights, 1 , kkk) .* d2 .* class2indmat(z-1,kkk) ) );
            %oldcost - newcost
            if newcost > oldcost-1e-12; z = oldz; end
        end

    end

    post = id(z,:);
    num_points = sum(post, 1);

    if n==1,
        cost0 = sum( sum( repmat( weights, 1 , kkk) .* d2 .* post ) );
        cost = cost0;
    else
        oldcost = cost;
        cost = sum( sum( repmat( weights, 1 , kkk) .* d2 .* post ) );
        if (oldcost - cost ) < 1e-8 * cost0,
            mu = centres';
            y = post;
            z = z';
            break;
        end
    end
    % M-Step: Adjust the centres based on new posteriors
    for j = 1:ncentres
        if (num_points(j) > 0)
            ind=find(post(:,j));
            centres(j,:) = sum(data(ind,:).*repmat(weights(ind),1,dim), 1)/sum(weights(ind));
        end
    end
    if spherical,
        % orthogonalize
        [uu,ss,vv ] = svd( centres,'econ');
        centres = uu * vv';
    end

end


mu = centres';
y = post;

