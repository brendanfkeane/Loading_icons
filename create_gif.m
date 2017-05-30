function create_gif(movie_array,filename,FPS,varargin)

%% Help text

if nargin == 0 || ischar(movie_array)
    help_text = ['Usage:\n' ...
        '  create_gif(movie_array,filename,FPS);\n\n' ...
        ...
        'movie_array must be an array with 4 dimensions:\n' ...
        '  height x width x 3 (RGB) x frames\n\n' ...
        ...
        'filename must be a string input, ending with .gif\n' ...
        'You can supply a path if you want here, else it will be saved in the\n' ...
        'current directory.\n\n' ...
        ...
        'FPS (frames per second) is the number of frames of the gif presented per\n' ...
        'second (i.e., 1/seconds per frame)\n\n' ...
        ...
        'Brendan Keane, 2016.\n\n'];
    
    fprintf('create_gif help\n\n')
    fprintf(help_text)
    return
end

%% Check input

if size(movie_array,3) ~= 3
    error('movie_array must have 3 layers in the 3rd dimension, detailing the RGB values of this frame')
end

the_dot = find(filename == '.',1);
if isempty(the_dot)
    filename = [filename,'.gif'];
    warning(['Filename edited to include the .gif suffix: ' filename])
end

if ischar(FPS)
    error('frames_per_second must be numeric')
end

if FPS <= 0
    error('frames_per_second must be a positive number')
end

if nargin >= 4 && ~isempty(varargin{1}) && ~ischar(varargin{1})
    LoopCount = varargin{1};
else
    LoopCount = Inf;
end

%% Create gif

for frame = 1:size(movie_array,4)
    [imind,cm] = rgb2ind(movie_array(:,:,:,frame),256);
    if frame == 1
        imwrite(imind,cm,filename,'gif', 'Loopcount',inf,'DelayTime',1/FPS,'LoopCount',LoopCount);
    else
        imwrite(imind,cm,filename,'gif','WriteMode','append','DelayTime',1/FPS);
    end
end

%% Brendan Keane, 2016.