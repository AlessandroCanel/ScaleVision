close all
clear all
% Read in the video file
v = VideoReader('Video/Sample1.mp4');
% Loop through the video frames
figure;
ax = axes;
%This is when the program starts
%v.CurrentTime = 8;
%Takes the first frame and makes you crop
tic
[a,b,c,d] = imcrop(readFrame(v));
results = [];
while hasFrame(v)
    % Read the current frame
    framecropped = readFrame(v); 

    % ALL THE EFFECTS
    % Comment these lines to see normal till end
    % framecropped = imcrop(framecropped,[610 125 120 90]);
    % framecropped = rgb2gray(framecropped);   
    % framecropped = imcomplement(framecropped);
    %framecropped = imsharpen(framecropped,'Radius',2,'Amount',5);
    
    % roi = [600 120 160 100];
    roi = d;
    % roi = [0.332454918032787,0.099639855942377,0.274273224043716,0.334933973589436]
    % Use OCR to detect text in the frame
    ocrResults = ocr(framecropped,d,Model="seven-segment");


frameInfo = insertObjectAnnotation(framecropped,"rectangle", ...
                           ocrResults.WordBoundingBoxes, ...
                           ocrResults.WordConfidences);

    %disp(ocrResults);

    % Display the numbers
    if(ocrResults.WordConfidences > 0.8)
        numbers = regexp(ocrResults.Text, '\w', 'match');
        time = v.CurrentTime;
        results = [results ; numbers(1,:) , time];
        %results = [results;transpose(ocrResults.Words) , v.CurrentTime];
    else
        fprintf("Not a good estimation %f \n", time);
    end

    imshow(frameInfo, 'Parent', ax);

    %Comment the line below for having the results immediately
    pause(1.0/v.FrameRate);
end
writecell(results)
type 'Results\resultsPrev.txt'
toc