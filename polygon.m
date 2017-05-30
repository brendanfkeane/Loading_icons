function shapeCoords = polygon(numSides,sideLength,sideComponents,varargin)

%% Deal with input

if nargin >= 4 && ~isempty(varargin{1}) && ~ischar(varargin{1})
    plt = varargin{1};
else
    plt = 0;
end

if nargin >= 5 && ~isempty(varargin{2}) && ~ischar(varargin{2})
    allowOverlap = varargin{1};
else
    allowOverlap = 1;
end

%% Setup

angle = 360/numSides;

if allowOverlap == 1
    shapeCoords = zeros(numSides*sideComponents,2);
else
    shapeCoords = zeros(numSides*(sideComponents-1),2);
end

rotMat = @(angle,x,y)([x,y]*[cosd(angle) -sind(angle) ; sind(angle) cosd(angle)]);

%% Go build

prevX = 0;
prevY = 0;
for side = 1:numSides
    
    if allowOverlap == 1
        x = 0:sideLength/(sideComponents-1):sideLength; % overlaps on the vertices
        y = zeros(1,sideComponents);
        output = rotMat(angle*(side-1),x',y') + ones(size(x,2),1)*[prevX,prevY];
        shapeCoords((side-1)*sideComponents+1:side*sideComponents,:) = output;
    else
        
        x = sideLength/(sideComponents-1):sideLength/(sideComponents-1):sideLength;
        y = zeros(1,sideComponents-1);
        output = rotMat(angle*(side-1),x',y') + ones(size(x,2),1)*[prevX,prevY];
        shapeCoords((side-1)*(sideComponents-1)+1:side*(sideComponents-1),:) = output;
    end
    
    prevX = output(end,1);
    prevY = output(end,2);
    
end

%% Position it nicely

shapeCoords(:,2) = -shapeCoords(:,2);
shapeCoords(:,1) = shapeCoords(:,1) - min(shapeCoords(:,1));
shapeCoords(:,1) = shapeCoords(:,1) - max(shapeCoords(:,1))/2;

shapeCoords(:,2) = shapeCoords(:,2) - min(shapeCoords(:,2));
shapeCoords(:,2) = shapeCoords(:,2) - max(shapeCoords(:,2))/2;


if plt ~= 0
    plot(shapeCoords(:,1),shapeCoords(:,2),'ko-')
    axis tight
    axis square
end

%% Brendan Keane, 2017.