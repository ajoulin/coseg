function [zmax,mumax,ymax] = kmeans_restarts_1_0(data,kkk, varargin);
% REQUIRED PARAMETERS
% data : d x n array
% kkk : number of clusters
%
[ndata , data_dim ] = size(data);


% OPTIONAL PARAMETERS
negative_constraints = [];  % only specific type (correspond to semi supervised classification)
spherical = 0;              % orthogonal centroids
weights = ones(ndata,1);    % weights
iter_max = 1000;            % maximum number of iterations
restarts  = 100;            % number of restarst;
lambda0 = 0;                % minimum number of elements per clusters

args = varargin;
nargs = length(args);

for i=1:2:nargs
    switch args{i},
        case 'spherical',        spherical = args{i+1};
        case 'negative_constraints',  negative_constraints = args{i+1};
        case 'weights',         weights = args{i+1};
        case 'iter_max',         iter_max = args{i+1};
        case 'restarts',         restarts = args{i+1};
        case 'lambda0',         lambda0 = args{i+1};
    end
end

maxcost = Inf;
zmax = [];
mumax = [];
ymax = [];

n=ndata;
data = data';


% check that negative constraints have proper form
if ~isempty(negative_constraints)
    if size(negative_constraints,1)~=kkk-1,
        error('wrong negative constraints');
    end
    indices_negative_constraints = unique(negative_constraints(:));
    if length(indices_negative_constraints)~=kkk,
        error('wrong negative constraints');
    end
end

for i=1:restarts
    if mod(i,10)==0, fprintf('%d ',i); end
    if ~isempty(negative_constraints) & i==1
        % first initialize with proper centers corresponding to negative constraints
        centres=data(:,indices_negative_constraints);
        [z,mu,y,cost] = kmeans_1_0(data,kkk, 'spherical',spherical, ...
            'negative_constraints',negative_constraints,...
            'weights',weights,'iter_max',iter_max,'centres',centres,'lambda0',lambda0);
    else
        if i <= round(restarts/2)
            % RANDOM INITIALISATION
            [z,mu,y,cost] = kmeans_1_0(data,kkk, 'spherical',spherical, ...
                'negative_constraints',negative_constraints, ...
                'weights',weights,'iter_max',iter_max,'lambda0',lambda0);
        else
            %   INITIALIZATION WITH FURTHEST POINTS
            centres=[];
            for j=1:kkk
                if (j==1),
                    centres=data(:,floor(rand*ndata)+1);
                else
                    % take point furthest to current centers
                    temp = sqdist(centres,data);
                    temp = min(temp);
                    [a,b] = max(temp);
                    centres=[centres data(:,b)];
                end
            end
            [z,mu,y,cost] = kmeans_1_0(data,kkk, 'spherical',spherical, ...
                'negative_constraints',negative_constraints,...
                'weights',weights,'iter_max',iter_max,'centres',centres,'lambda0',lambda0);
        end

        % check negative constraints
        if ~isempty(negative_constraints)
            if length(unique(z(negative_constraints)))<kkk, cost = Inf; end
        end

    end



    if cost <= maxcost,
        zmax = z; mumax = mu; ymax = y; maxcost = cost;
    end
end
fprintf('\n');