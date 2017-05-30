%% Notes
% 
% You will have to add your own output directory in line 130
%
% You will need polygon.m and create_gif.m to run this code.
%
% Brendan Keane, 2017.

%% Options

rotationIncrement = 8; % degrees

rotateShape = 1;
% (1) square
% (2) circle

lockPairs = 1;
checkPairs = 0;

outlineShapes = 0;

gifFPS = 12;
imageSize = 300; % pixels

startingSquareRotation = 45;

%% First, need a circle

circleDots = 120;
circleRadius = 30;

x = 1/circleDots:1/circleDots:1;
circleCoords = circleRadius * [sin(x*pi*2) ; cos(x*pi*2)]';

%% Now, need a square

% Build a square - you'll need the polygon function on the path
numSides = 4; % Can edit this to make other polygons!
squareDotsPerSide = 120; % dots per side
squareSize = 30;
% squareSize = 2*circleRadius*cosd(45); % have the corner of the square run
% along the circle when it rotates

squareCoords = polygon(numSides,squareSize,squareDotsPerSide,0);

rotationMatrix = [cosd(startingSquareRotation) -sind(startingSquareRotation) ; sind(startingSquareRotation) cosd(startingSquareRotation)];
squareCoords = squareCoords*rotationMatrix;


images = zeros(imageSize,imageSize,3,numFrames);
% store each frame of the animation in this 4D array

%% Prepare animation frames

a = figure;
closest = zeros(circleDots,1);
for rotationAngle = rotationAngles
    
    rotationMatrix = [cosd(rotationAngle) -sind(rotationAngle) ; sind(rotationAngle) cosd(rotationAngle)];
    rotSqCoords = squareCoords*rotationMatrix;
    rotCircCoords = circleCoords*rotationMatrix;
    
    cla
    a.Position = [0 0 imageSize imageSize];
    hold on
    if outlineShapes == 1
        plot(circleCoords(:,1),circleCoords(:,2),'ro')
        plot(rotSqCoords(:,1),rotSqCoords(:,2),'bo')
    end
    
    for circle = 1:circleDots
        if rotateShape == 1
            if lockPairs == 1
                if rotationAngle == rotationAngles(1)
                    distances = sqrt((circleCoords(circle,1)-rotSqCoords(:,1)).^2+(circleCoords(circle,2)-rotSqCoords(:,2)).^2);
                    theseClosest = find(distances == min(distances));
                    closest(circle,1) = theseClosest(randperm(length(theseClosest),1));
                end
            else
                distances = sqrt((circleCoords(circle,1)-rotSqCoords(:,1)).^2+(circleCoords(circle,2)-rotSqCoords(:,2)).^2);
                theseClosest = find(distances == min(distances));
                closest(circle,1) = theseClosest(randperm(length(theseClosest),1));
            end
            plot([circleCoords(circle,1) rotSqCoords(closest(circle),1)],[circleCoords(circle,2) rotSqCoords(closest(circle),2)],'k-')
        else
            if lockPairs == 1
                if rotationAngle == rotationAngles(1)
                    distances = sqrt((rotCircCoords(circle,1)-squareCoords(:,1)).^2+(rotCircCoords(circle,2)-squareCoords(:,2)).^2);
                    theseClosest = find(distances == min(distances));
                    closest(circle,1) = theseClosest(randperm(length(theseClosest),1));
                end
            else
                distances = sqrt((rotCircCoords(circle,1)-squareCoords(:,1)).^2+(rotCircCoords(circle,2)-squareCoords(:,2)).^2);
                theseClosest = find(distances == min(distances));
                closest(circle,1) = theseClosest(randperm(length(theseClosest),1));
            end
            plot([rotCircCoords(circle,1) squareCoords(closest(circle),1)],[rotCircCoords(circle,2) squareCoords(closest(circle),2)],'k-')
        end
    end
    axis(1.1*[-axisVal axisVal -axisVal axisVal])
    axis square
    axis off
    drawnow
    
    if lockPairs == 0 && length(unique(closest)) < squareDotsPerSide*4
        error('Dodgy frame!')
    end
    
    thisImage = getframe(a);
    thisImage = double(thisImage.cdata)/255;
    images(:,:,:,rotationAngles == rotationAngle) = thisImage;
    
    if checkPairs == 1 && rotationAngle == rotationAngles(1)
        pause
    end
end

%% Notes

% Inspired by the subreddit r/loadingicons
%
% Nice settings: (work with checks at line 97)
% rotationIncrement = 10; % degrees
% circleDots = 120;
% circleRadius = 30;
% squareSides = 40; % dots per side
% squareSize = 30;
% 
% Note that few combinations work with the checks at line 97!

%% Export

fprintf('Exporting as .gif to desktop')
% filename = '/Users/Brendan/Desktop/square_in_circle.gif';
create_gif(images,filename,gifFPS);
fprintf('\nExported\n')

%% Brendan Keane, 2017.