%% Notes
% 
% You will have to add your own output directory in line 130
%
% I have added some code to facilitate playing with line and background
% colours.
%
% You will need polygon.m and create_gif.m to run this code.
%
% Brendan Keane, 2017.

%% Options

numTriangles = 30;

gifFPS = 16;
imageSize = 300; % pixels

backgroundColour = [0 0 0]; % default = [.94 .94 .94]

%% Basic setup

close all
commandwindow
clc

% Build a triangle - you'll need the polygon function on the path
numSides = 3; % Can edit this to make other polygons!
sideLength = 50; % arbitrary for this usage
sideComponents = 2; % min: 2; also arbitrary for this usage, so go simple
shapeCoords = polygon(numSides,sideLength,sideComponents,0);

rotMat = @(angle,x,y)([x,y]*[cosd(angle) -sind(angle) ; sind(angle) cosd(angle)]);
% prepare a quick & dirty rotation matrix function

increment = 1; % rotation increment between .gif frames
rotationAngles = 0:increment:360-increment;
numFrames = length(rotationAngles);

images = zeros(imageSize,imageSize,3,numFrames);
% store each frame of the animation in this 4D array

%% Play with colours

% colour = [1 .2 .2]; % updated with thisColour to cycle between R G & B

colours = rand(numTriangles,3); % constant colour, but random for each triangle
% If using this, probably a good idea to set the background colour to black

%% Loop & store

a = figure;
a.Color = backgroundColour;
for angle = rotationAngles
    
    cla
    a.Position = [0 0 imageSize imageSize];

    for multiple = 1:1:numTriangles
        out = rotMat(angle*multiple,shapeCoords(:,1),shapeCoords(:,2));
%         plot(out(:,1),out(:,2),'k-') % black lines
        plot(out(:,1),out(:,2),'LineStyle','-','Color',colours(multiple,:)); % (constant) random colours
        hold on
    end
%     set(get(gca,'Children'),'LineWidth',2); % set the line width (default: 1)
    
    % update triangle colours between R, G, & B
%     if ceil(angle/60) == angle/60
%         thisColour = colour(mod(ceil(angle/60):ceil(angle/60)+2,3)+1);
%     end
%     set(get(gca,'Children'),'Color',thisColour) 
    
    axis([-sideLength sideLength -sideLength sideLength]*3/4)
    axis square
    axis off
    drawnow
    
    thisImage = getframe(a);
    thisImage = double(thisImage.cdata)/255;
    images(:,:,:,rotationAngles == angle) = thisImage;
end

%% Export

fprintf('Exporting as .gif to desktop')
filename = ['Enter your output location here!' '\rotating_polygons.gif'];
create_gif(images,filename,gifFPS);
fprintf('\nExported\n')

%% Brendan Keane, 2017.