close all
clear
% Read in the video file
v = VideoReader("Video\Sample1.mp4");
% Loop through the video frames
figure;
ax = axes;
%This is when the program starts
%v.CurrentTime = 8;
%Takes the first frame and makes you crop
[a,b,c,d] = imcrop(readFrame(v));
% Neat lil optimization
results = cell(v.NumFrames,3);
tic
for i = 1:v.NumFrames-1
    % Read the current frame
    framecropped = readFrame(v); 

    % ALL THE EFFECTS
    % Comment these lines to see normal till end
    % framecropped = rgb2gray(framecropped);   
    % framecropped = imcomplement(framecropped);
    % framecropped = imsharpen(framecropped,'Radius',2,'Amount',2);

    % Ocr gets the frame
    ocrResults = ocr(framecropped,d,Model="seven-segment");

    % Discriminate the number set from the text
    numbers = regexp(ocrResults.Text, '\w*', 'match');
    % Get the confidences to remove uncertainty
    confidences = ocrResults.WordConfidences;

    % Change the treshold of the confidence to be more sure about the
    % results
    if(size(confidences,2) ~= 1 ||  max(confidences) < 0.7 || size(numbers,1) ~= 1)
        fprintf("Not a good estimation %f \n", v.CurrentTime);
    else       
        time = v.CurrentTime;
        results(i,1:size(numbers,2)+1) = [numbers(1:size(numbers,2)),time];
    end
    

    % Add the info to the rendered frame
    frameInfo = insertObjectAnnotation(framecropped,"rectangle", ...
                           ocrResults.WordBoundingBoxes, ...
                           ocrResults.WordConfidences);

    % Print every frame you can render
    imshow(frameInfo, 'Parent', ax);

    % uncomment this to watch it
    pause(1.0/v.FrameRate);
end
toc
close
writecell(results,'Results\Sample1.txt')

