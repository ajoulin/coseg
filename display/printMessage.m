function printMessage(msg, eol , funName, typeMsg)

if nargin<2
    eol = 1;
end

if nargin<4 || isempty(typeMsg)
    beginText = '';
elseif strcmp(typeMsg,'e')
    beginText = '[ERROR] ';
    eol = 1;
elseif strcmp(typeMsg,'w')
    beginText = '[WARNING] ';
elseif strcmp(typeMsg,'m')
    beginText = '[MESSAGE] ';
end

if nargin<3 || isempty(funName)
    middleText = '';
else
    middleText = sprintf('%s.m : ',funName);
end

fprintf('%s%s%s', beginText, middleText, msg)
    
if eol == 1
    fprintf('\n');
end

