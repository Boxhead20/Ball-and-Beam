%a = imaqhwinfo;
%[camera_name, camera_id, format] = getCameraInfo(a);

try
   clear all
    vid = videoinput('winvideo', 1);



% Set the properties of the video object
set(vid, 'FramesPerTrigger', Inf);
set(vid, 'ReturnedColorspace', 'rgb')
vid.FrameGrabInterval = 4;
arduino = serial('COM4','BaudRate',9600); % Set ComPort
fopen(arduino);
pause(2.0)

nd=3000;
datosx=cell2mat(cell(nd,1));
datosy=cell2mat(cell(nd,1));
%start the video aquisition here
start(vid)
flag=1;
u = idinput(nd,'prbs',[0,1],[1200,2000]);
% Set a loop that stop after 100 frames of aquisition
while(flag <=nd)
    
    % Get the snapshot of the current frame
    data = getsnapshot(vid);
    
    % Now to track red objects in real time
    % we have to subtract the red component 
    % from the grayscale image to extract the red components in the image.
    diff_im = imsubtract(data(:,:,1), rgb2gray(data));
    % diff_imm = imsubtract(data(:,:,2), rgb2gray(data));
        diff_immm = imsubtract(data(:,:,3), rgb2gray(data));
    %Use a median filter to filter out noise
    diff_im = medfilt2(diff_im, [3 3]);
   %  diff_imm = medfilt2(diff_imm, [3 3]);
      diff_immm = medfilt2(diff_immm, [3 3]);
    
    % Convert the resulting grayscale image into a binary image.
    diff_im = im2bw(diff_im,0.18);
     %  diff_imm = im2bw(diff_imm,0.18);
          diff_immm = im2bw(diff_immm,0.18);
      %imshow(diff_im)
    % Remove all those pixels less than 300px
    diff_im = bwareaopen(diff_im,500);
     %diff_imm = bwareaopen(diff_imm,300);
      diff_immm = bwareaopen(diff_immm,000);
     %imshow(diff_imm)

    
    %%
    % Label all the connected components in the image.
    bw = bwlabel(diff_im, 8);
   %  bww = bwlabel(diff_imm, 8);
      bwww = bwlabel(diff_immm, 8);
    
    % Here we do the image blob analysis.
    % We get a set of properties for each labeled region.
    stats = regionprops(bw, 'BoundingBox', 'Centroid');
    % statss = regionprops(bww, 'BoundingBox', 'Centroid');
      statsss = regionprops(bwww, 'BoundingBox', 'Centroid');
   
    
    % Display the image
    imshow(data)
    
    hold on
    
    %This is a loop to bound the red objects in a rectangular box.
    try   
     
    bb = stats(1).BoundingBox;
        bc = stats(1).Centroid;
        rectangle('Position',bb,'EdgeColor','r','LineWidth',2)
        plot(bc(1),bc(2), '-m+')
         a=text(bc(1)+15,bc(2), strcat('X: ', num2str(round(bc(1))), '    Y: ', num2str(round(bc(2)))));
        set(a, 'FontName', 'Arial', 'FontWeight', 'bold', 'FontSize', 12, 'Color', 'blue');
       
       bbbb = statsss(1).BoundingBox;
       %bbbb(3)
       tri=(4.08/bb(3));
       
    
        bccc = statsss(1).Centroid;
        rectangle('Position',bbbb,'EdgeColor','b','LineWidth',2)
        plot(bccc(1),bccc(2), '-m+')
      
        a=text(bccc(1)+15,bccc(2), strcat('X: ', num2str(round(bccc(1))), '    Y: ', num2str(round(bccc(2)))));
        set(a, 'FontName', 'Arial', 'FontWeight', 'bold', 'FontSize', 12, 'Color', 'blue');
     plot([bc(1) bccc(1)],[bc(2) bccc(2)],'r')
    catch exception
    end
    
    %diametro 4.08
       % fprintf(arduino,'%s',1); 
     x1=bccc(2)-bc(2);
     y1=bccc(1)-bc(1);
    distancia=(sqrt(abs((x1*x1)+(y1*y1)))*tri)-4 ;
   pos=u(flag);
   fprintf(arduino,'%f',pos); 
%   pause(0.4);
       datosx{flag}=distancia;
       datosy{flag}=u(flag);
       flag=flag+1
    hold off
end
% Both the loops end here.

% Stop the video aquisition.
stop(vid);
% Flush all the image data stored in the memory buffer.
flushdata(vid);

fclose(arduino); 
% Clear all variables
sprintf('%s','error');

datosx=cell2mat(datosx);
datosy=cell2mat(datosy);
    catch exception
       stop(vid);
fclose(arduino); 
% Flush all the image data stored in the memory buffer.
flushdata(vid);
% Clear all variables
     
end
% Capture the video frames using the videoinput function
% You have to replace the resolution & your installed adaptor name.
