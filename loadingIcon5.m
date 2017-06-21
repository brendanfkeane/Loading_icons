%% Options

radii = [10 15 20 25 30 35 40 45 50];

gifFPS = 24;
imageSize = 600; % pixels

backgroundColour = [0 0 0]; % default = [.94 .94 .94]

%% Setup

phaseShiftIncrements = 0:(2*pi)/100:2*pi-pi/100;
numFrames = length(phaseShiftIncrements);
if IsWindows
    images = zeros(imageSize,imageSize,3,numFrames);
else
    images = zeros(imageSize*2,imageSize*2,3,numFrames);
end

%% Draw and store

fig = figure;
fig.Color = backgroundColour;
for phaseShift = phaseShiftIncrements
    
    cla
    fig.Position = [100 100 imageSize imageSize];
    
    for rad = 1:length(radii)
        mult = length(radii) - rad + 1;
        
        x = 0:pi/ceil((radii(rad)/2)):2*pi;
        xCoords = radii(rad)*sin(x);
        yCoords = radii(rad)*cos(x);
        
        colours = 0.5 + 0.5*[sin(x+0+phaseShift*mult) ; ...
            sin(x+2*pi/3+phaseShift*mult) ; ...
            sin(x + 2*2*pi/3+phaseShift*mult)];
        for a = 1:size(x,2)
            plot(xCoords(a),yCoords(a),'wo','MarkerFaceColor',colours(:,a),'MarkerEdgeColor','none','MarkerSize',10)
            hold on
        end
    end
    
    axis square
    axis off
    drawnow
    
    thisImage = getframe(fig);
    thisImage = double(thisImage.cdata)/255;
    images(:,:,:,phaseShiftIncrements == phaseShift) = thisImage;
    
end

delete(fig)

%% Export

fprintf('Exporting as .gif to desktop')
filename = '/Users/Brendan/Desktop/rotating_colourwheel.gif';
create_gif(images,filename,gifFPS);
fprintf('\nExported\n')

%% Brendan Keane, 2017.