try
clear all
vid = videoinput('winvideo', 1);
%constant for PID an LQR

Setpoint=30;
kp=-133.8;%-8.512;-2.848;
ki=-30.98;%-0.9695;%-0.1659;
kd=-150;%-11.87;%-1.382;
k1=82.9526;
k2=-252.8252;

%pid variables needed
flag=1;
bias=1650;
fase=5;
timed=0.001;
rminf=1200;
rmin=rminf;
rmaxf=2000;
rmax=rmaxf;
error=0;
integral=0;
errorpasado=0;


% Set the properties of the video object
set(vid, 'FramesPerTrigger', Inf);
set(vid, 'ReturnedColorspace', 'rgb')
vid.FrameGrabInterval = 1;
%variable to record data 
t=0;
tag=cell(100000,1);
tag=cell2mat(tag);
tag2=cell(100000,1);
tag2=cell2mat(tag2);
%start the video aquisition here
start(vid)
flag=1;
%f2=fihure(2);
%ax1=axes('parent',f2);
% Set a loop that stop after 100 frames of aquisition
while(1)
    
    % Get the snapshot of the current frame
    data = getsnapshot(vid);
    
    % Now to track red objects in real time
    % we have to subtract the red component 
    % from the grayscale image to extract the red and blue  components in the image.
    diff_im = imsubtract(data(:,:,1), rgb2gray(data));
    diff_immm = imsubtract(data(:,:,3), rgb2gray(data));
    
    diff_im = medfilt2(diff_im, [3 3]);
    diff_immm = medfilt2(diff_immm, [3 3]);
    
    % Convert the resulting grayscale image into a binary image.
    diff_im = im2bw(diff_im,0.18);
    diff_immm = im2bw(diff_immm,0.18);
    % Remove all those pixels less than needed
    diff_im = bwareaopen(diff_im,700);
    diff_immm = bwareaopen(diff_immm,000);
     %imshow(diff_imm)

    
    %%
    % Label all the connected components in the image.
    bw = bwlabel(diff_im, 8);
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
     x1=(bccc(2)-bc(2));
     y1=abs(bccc(1)-bc(1));
    distancia=round((sqrt(abs((x1*x1)+(y1*y1)))*tri)-3);
      angle=(atan(x1/y1))*180/3.1416;
    tag(flag)=distancia;
    tag2(flag)=angle;
    plot(tag)
    flag=flag+1;
  %fprintf(arduino,'%f',pos); 
   % vec = [angle pos distancia];
    %disp(vec)
    pause(0.001)
    
vec = [angle distancia  Setpoint];
    disp(vec)
    hold off
end
% Both the loops end here.

% Stop the video aquisition.
stop(vid);
% Flush all the image data stored in the memory buffer.
flushdata(vid);
% Clear all variables
sprintf('%s','error');

    catch exception
       stop(vid);
% Flush all the image data stored in the memory buffer.
flushdata(vid);
%clear all;
% Clear all variables
     
end