% Clear the workspace and the screen
sca;
close all;
clearvars;

%rosinit;
%mySub = rossubscriber('/jaco/feedback',callback);
%command = recieve(mySub);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% SETUP %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Screen('Preference', 'SkipSyncTests', 0);
bgc = [0 0 0]; % Set background color
screenNumber = 0; % Set Screen number
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, bgc); % Open an on screen window
PsychDefaultSetup(2); % Here we call some default settings for setting up Psychtoolbox
[sXp, sYp] = Screen('WindowSize', window); % Get the size of the on screen window
[xCenter, yCenter] = RectCenter(windowRect);% Get the centre coordinate of the window
ifi = Screen('GetFlipInterval', window); % Measure the vertical refresh rate of the monitor
topPriorityLevel = MaxPriority(window); % Retreive the maximum priority number
waitframes = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%% OTHER VARIALBES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

runtime = 15; % Setting Runtime, in sec. 
box = 50; % Size of each small box
size = 2.5; % Size of box if not use Chessboard
numLn = 6; % number of lines per Chessboard
numSq = 4; % number of (boxes*2) pr line
swapType = 1; % 0 if full flash, 1 if chessboard
colorMode = 0; % Set to 1, if color should change over time
grow = 0; % pixel growth
interface = 1; % 0 = 4 flicker, 1 = 5 flicker, 2 = 6 flicker

% Set the colors [R G B]
c1 = [1 1 1]; % Color Chess 1
c2 = [1 1 1]; % Color Chess 2
c3 = [1 1 1]; % Color Chess 3
c4 = [1 1 1]; % Color Chess 4
c5 = [1 1 1]; % Color Chess 5
c6 = [1 1 1]; % Color Chess 6

color1 = [c1(1) c1(1) c1(1) c1(1) ; c1(2) c1(2) c1(2) c1(2) ; c1(3) c1(3) c1(3) c1(3)];
color2 = [c2(1) c2(1) c2(1) c2(1) ; c2(2) c2(2) c2(2) c2(2) ; c2(3) c2(3) c2(3) c2(3)];
color3 = [c3(1) c3(1) c3(1) c3(1) ; c3(2) c3(2) c3(2) c3(2) ; c3(3) c3(3) c3(3) c3(3)];
color4 = [c4(1) c4(1) c4(1) c4(1) ; c4(2) c4(2) c4(2) c4(2) ; c4(3) c4(3) c4(3) c4(3)];
color5 = [c5(1) c5(1) c5(1) c5(1) ; c5(2) c5(2) c5(2) c5(2) ; c5(3) c5(3) c5(3) c5(3)];
color6 = [c6(1) c6(1) c6(1) c6(1) ; c6(2) c6(2) c6(2) c6(2) ; c6(3) c6(3) c6(3) c6(3)];

black = [0 0 0 0 ; 0 0 0 0 ; 0 0 0 0 ]; % black color

% Setting Frequencies 
f = [8.6 10 12 15];
numS = [1/f(1) 1/f(2) 1/f(3) 1/f(4)]; % Number of Seconds before switch colorF
%numF = [round(numS(1)/ifi) round(numS(2)/ifi) round(numS(3)/ifi) round(numS(4)/ifi)];
numF = [5 4 9 7 6];% Number of Frames for each frequencies
%runT = round([f(1)/2*runtime f(2)/2*runtime f(3)/2*runtime f(4)/2*runtime]); % Number of frames the loop goes through 
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                       Creating Chessbord                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%% TOP LEFT CHESS %%%%
   for i = 1:numSq
       for j = 1:numLn
           if mod(j,2) == 1
               chess1(:,i,j) = [(i-1) * (box*2), box * (j-1), (i-1) * (box*2) + box, box*j];
               chess1_off(:,i,j) = [((i-1) * (box*2)) + box, box * (j-1), (i-1) * (box*2) + (box*2), box*j];
           else
               chess1(:,i,j) = [((i-1) * (box*2)) + box, box * (j-1), (i-1) * (box*2) + (box*2), box*j];
               chess1_off(:,i,j) = [((i-1) * (box*2)), box * (j-1), (i-1) * (box*2) + box, box*j];
           end
       end
   end
  
%%%% BOT LEFT CHESS %%%%
   for i = 1:numSq
       for j = 1:numLn
           if mod(j,2) == 1
               chess3(:,i,j) = [(i-1) * (box*2), sYp - (box*(numLn-j+1)), (i-1) * (box*2) + box, sYp - (box*(numLn-j))];
               chess3_off(:,i,j) = [(i-1) * (box*2) + box, sYp - (box*(numLn-j+1)), (i-1) * (box*2) + (box*2), sYp - (box*(numLn-j))];
           else
               chess3(:,i,j) = [((i-1) * (box*2)) + box, sYp - (box*(numLn-j+1)), (i-1) * (box*2) + (box*2), sYp - (box*(numLn-j))];
               chess3_off(:,i,j) = [((i-1) * (box*2)), sYp - (box*(numLn-j+1)), (i-1) * (box*2) + box, sYp - (box*(numLn-j))];
           end
       end
   end

%%%% TOP RIGHT CHESS %%%%
   for i = 1:numSq
       for j = 1:numLn
           if mod(j,2) == 1
                chess2(:,i,j) = [sXp - (numSq*2*box)+((i-1)*box*2), box * (j-1), (sXp - (numSq*2*box)+((i-1)*box*2)) + box, box*j];
                chess2_off(:,i,j) = [sXp - (numSq*2*box)+(i-1) * box*2 + box, box * (j-1), (sXp - (numSq*2*box)+(i-1) * box*2) + (box*2), box*j];
           else
               chess2(:,i,j) = [sXp - (numSq*2*box)+((i-1)*box*2) + box, box * (j-1), (sXp - (numSq*2*box)+(i-1) * box*2) + (box*2), box*j];
               chess2_off(:,i,j) = [sXp - (numSq*2*box)+(i-1)*box*2, box * (j-1), (sXp - (numSq*2*box)+(i-1) * box*2) + box, box*j];
           end
       end
   end

%%%% BOT RIGHT CHESS %%%%
   for i = 1:numSq
       for j = 1:numLn
           if mod(j,2) == 1
               chess4(:,i,j) = [sXp-(numSq*2*box)+((i-1)*box*2), sYp-(box*(numLn-j+1)), (sXp-(numSq*2*box)+((i-1)*box*2))+box, sYp-(box*(numLn-j))];
               chess4_off(:,i,j) =[sXp-(numSq*2*box)+(i-1)*box*2+box, sYp-(box*(numLn-j+1)), (sXp-(numSq*2*box)+(i-1)*box*2)+(box*2), sYp-(box*(numLn-j))];
           else
               chess4(:,i,j) = [sXp-(numSq*2*box)+((i-1)*box*2)+box, sYp - (box*(numLn-j+1)),(sXp-(numSq*2*box)+(i-1)*box*2)+(box*2), sYp-(box*(numLn-j))];
               chess4_off(:,i,j) = [sXp-(numSq*2*box)+(i-1)*box*2, sYp-(box*(numLn-j+1)), (sXp-(numSq*2*box)+(i-1)*box*2)+box, sYp-(box*(numLn-j))];
           end
       end
   end
   
%centerbox position
if box == 50
    cb = box*15.3;
end
if box == 55
    cb = box*13.5;
end
if box == 60
    cb = box*12;
end

%%%% TOP LEFT MIDDLE %%%%
   for i = 1:numSq
       for j = 1:numLn
           if mod(j,2) == 1
               chess5(:,i,j) = [(i-1) * (box*2) + (cb), box * (j-1), (i-1) * (box*2) + box + (cb), box*j];
               chess5_off(:,i,j) = [((i-1) * (box*2)) + box + (cb), box * (j-1), (i-1) * (box*2) + (box*2) + (cb), box*j];
           else
               chess5(:,i,j) = [((i-1) * (box*2)) + box + (cb), box * (j-1), (i-1) * (box*2) + (box*2) + (cb), box*j];
               chess5_off(:,i,j) = [((i-1) * (box*2)) + (cb), box * (j-1), (i-1) * (box*2) + box + (cb) , box*j];
           end
       end
   end
  
  
%%%% BOT LEFT MIDDLE %%%%
   for i = 1:numSq
       for j = 1:numLn
           if mod(j,2) == 1
               chess6(:,i,j) = [(i-1) * (box*2) + (cb), sYp - (box*(numLn-j+1)), (i-1) * (box*2) + box + (cb), sYp - (box*(numLn-j))];
               chess6_off(:,i,j) = [(i-1) * (box*2) + box + (cb), sYp - (box*(numLn-j+1)), (i-1) * (box*2) + (box*2) + (cb), sYp - (box*(numLn-j))];
           else
               chess6(:,i,j) = [((i-1) * (box*2)) + box + (cb), sYp - (box*(numLn-j+1)), (i-1) * (box*2) + (box*2) + (cb), sYp - (box*(numLn-j))];
               chess6_off(:,i,j) = [((i-1) * (box*2)) + (cb), sYp - (box*(numLn-j+1)), (i-1) * (box*2) + box + (cb), sYp - (box*(numLn-j))];
           end
       end
   end
     
%%%%%%%%%%%%%%%%%% Full Size Flash %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

flash_1 = [0;0; sXp/8*size; sYp/6*size];
flash_2 = [sXp-(sXp/8*size);0;sXp;sYp/6*size];
flash_3 = [0; sYp-(sYp/6*size); sXp/8*size; sYp];
flash_4 = [sXp-(sXp/8*size);sYp-(sYp/6*size);sXp;sYp];
 
for i = 1:4
    if i == 1
        center_1(:,i) = [round(((flash_1(3)-flash_1(1))/2)-(box/6));round(((flash_1(4)-flash_1(2))/2)-(box/6));round((flash_1(3)/2)+(box/6));round((flash_1(4)/2)+(box/6))];
    end
    if i == 2
        center_1(:,i) = [round((flash_2(1)+(flash_2(3)-flash_2(1))/2)-(box/6));round((flash_2(2)+(flash_2(4)-flash_2(2))/2)-(box/6));round((flash_2(1)+(flash_2(3)-flash_2(1))/2)+(box/6));round(((flash_2(2)+flash_2(4)-flash_2(2))/2)+(box/6))];
    end
    if i == 3
        center_1(:,i) = [round((flash_3(1)+(flash_3(3)-flash_3(1))/2)-(box/6));round((flash_3(2)+(flash_3(4)-flash_3(2))/2)-(box/6));round((flash_3(1)+(flash_3(3)-flash_3(1))/2)+(box/6));round((flash_3(2)+(flash_3(4)-flash_3(2))/2)+(box/6))];
    end
    if i == 4
        center_1(:,i) = [round((flash_4(1)+(flash_4(3)-flash_4(1))/2)-(box/6));round((flash_4(2)+(flash_4(4)-flash_4(2))/2)-(box/6));round((flash_4(1)+(flash_4(3)-flash_4(1))/2)+(box/6));round((flash_4(2)+(flash_4(4)-flash_4(2))/2)+(box/6))];
    end
end

%%%%%%%%%%%%%%%%%% CREATING RED SQUARES IN CENTER %%%%%%%%%%%%%%%%%%%%%%%%%
for i = 1:5
    if i == 1
        center(:,i) = [box*4 - box/5 ; box*3 - box/5 ; box*4 + box/5 ; box*3 + box/5];
    end
    if i == 2
        center(:,i) = [box*4 - box/5 ; sYp - (box*3 + box/5) ; box*4 + box/5 ; sYp - (box*3 - box/5)];
    end        
    if i == 3
        center(:,i) = [sXp - box*4 - box/5 ; box*3 - box/5 ; sXp - box*4 + box/5 ; box*3 + box/5];
    end
    if i == 4
        center(:,i) = [sXp - box*4 - box/5 ; sYp - (box*3 + box/5) ; sXp - box*4 + box/5 ; sYp - (box*3 - box/5)];
    end
    if i == 5
        center(:,i) = [box*4 - box/5 + cb ; box*3 - box/5 ; box*4 + box/5 + cb ; box*3 + box/5];
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                              MAIN CODE                                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Priority(topPriorityLevel);
vbl = Screen('Flip', window);
counter = [0 0 0 0 0 0];
swap = [0 0 0 0 0 0];
white = [1 1 1];
colorChange = 0.001;
count = [0 0 0 0 0];
countx = [0 0 0 0 0];
rate = 0.3; 
command = 1;
ccheck = [0 0 0 0 0];
%for i = (1:(60*runtime))
while ~KbCheck
     
%%%Draw Text%%%

%if KbCheck()
%    colorChange = colorChange + 0.001;
%end

%Screen('DrawText', window, '15', 630 , 70, white);
Screen('DrawText', window, 'c3 (12Hz)', 100 , 340, white);
%Screen('DrawText', window, 'Home Position', 630 , 120, white);

%Screen('DrawText', window, '12', 1100, 70, white);
Screen('DrawText', window, 'c2 STOP (10Hz)', 870, 340, white);
%Screen('DrawText', window, 'Open Door', 1100, 120, white);

%Screen('DrawText', window, '10', 630,  730, white);  
Screen('DrawText', window, 'c4 (15Hz)', 1640,  340, white);    
%Screen('DrawText', window, 'Move Object', 630,  780, white);    

%Screen('DrawText', window, '8.5', 1100, 730, white);
Screen('DrawText', window, 'c0 (6.66Hz)', 100, 700, white);
%Screen('DrawText', window, ' 1', 1100, 780, white);

Screen('DrawText', window, 'c1 (8.57Hz)', 1640, 700, white);

%%%%%%%%%%%%%%%%%%%%%%% Flickering 1 %%%%%%%%%%%%%%%%%%%%%%%
  
    if counter(1) == 0
        counter(1) = numF(1);
        if swap(1) == 1
            swap(1) = 0;
        else
            swap(1) = 1;
        end
   end
    
    % reset color 
    for k = 1:5
        if ccheck(k) == 100
            c3 = [1 1 1];
            command = 5;
            ccheck(1) = 0;
        end
        if ccheck(k) == 100
            c4 = [1 1 1];
            command = 5;
            ccheck(2) = 0;
        end
        if ccheck(k) == 100
            c5 = [1 1 1];
            command = 5;
            ccheck(3) = 0;
        end
        if ccheck(k) == 100
            c1 = [1 1 1];
            command = 5;
            ccheck(4) = 0;
        end
        if ccheck(k) == 100
            c2 = [1 1 1];
            command = 5;
            ccheck(5) = 0;
        end
    end
    
    if swapType == 1
        if swap(1) ~= 0
            for j = 1:numLn
                Screen('FillRect', window, color1, chess1(:,:,j));
                Screen('FillRect', window, black, chess1_off(:,:,j));            
            end
        else
            for j = 1:numLn
                Screen('FillRect', window, black, chess1(:,:,j));
                Screen('FillRect', window, color1, chess1_off(:,:,j));
            end
        end
        
    elseif swapType == 0
        if swap(1) ~= 0
            Screen('FillRect', window, c1, flash_1);
        else
            Screen('FillRect', window, bgc, flash_1);
        end
    end
   
 %   if colorMode == 1
 %       c1(2) = c1(2)-colorChange;
 %       c1(3) = c1(3)-colorChange;
 %   else
 %       c1 = [1 1 1];
 %   end
    
    counter(1) = counter(1) - 1;
    
%%%%%%%%%%%%%%%%%%%%%%% Flickering 2 %%%%%%%%%%%%%%%%%%%%%%%
    
    if counter(2) == 0
        counter(2) = numF(2);
        if swap(2) == 1
            swap(2) = 0;
        else
            swap(2) = 1;
        end
    end
    if swapType == 1    
        if swap(2) ~= 0
            for j = 1:numLn
                Screen('FillRect', window, color2, chess2(:,:,j));
                Screen('FillRect', window, black, chess2_off(:,:,j));            
            end
        else
            for j = 1:numLn
                Screen('FillRect', window, black, chess2(:,:,j));
                Screen('FillRect', window, color2, chess2_off(:,:,j));
            end
        end
    elseif swapType == 0
        if swap(2) ~= 0
            Screen('FillRect', window, c2 , flash_2);
        else
            Screen('FillRect', window, bgc, flash_2);
        end
    end
    
%    if colorMode ==1
%        c2(1) = c2(1)-colorChange;
%        c2(3) = c2(3)-colorChange;
%    else
%        c2 = [1 1 1];
%    end
    
    counter(2) = counter(2) - 1;
    
%%%%%%%%%%%%%%%%%%%%%%% Flickering 3 %%%%%%%%%%%%%%%%%%%%%%%
    
    if counter(3) == 0
        counter(3) = numF(3);
        if swap(3) == 1
            swap(3) = 0;
        else
            swap(3) = 1;
        end
     end
    
    if swapType == 1
        if swap(3) ~= 0
            for j = 1:numLn
                Screen('FillRect', window, color3, chess3(:,:,j));
                Screen('FillRect', window, black, chess3_off(:,:,j));            
            end
        else
            for j = 1:numLn
                Screen('FillRect', window, black, chess3(:,:,j));
                Screen('FillRect', window, color3, chess3_off(:,:,j));
            end
        end
    elseif swapType == 0
        if swap(3) ~= 0
            Screen('FillRect',window,c3,flash_3);
        else
            Screen('FillRect',window,bgc,flash_3);
        end    
    end
    
%    if colorMode == 1
%        c3(1) = c3(1)-colorChange;
%        c3(2) = c3(2)-colorChange;
%    else
%        c3 = [1 1 1];
%    end
    
    counter(3) = counter(3) - 1;
            
%%%%%%%%%%%%%%%%%%%%%%% Flickering 4 %%%%%%%%%%%%%%%%%%%%%%%
      
    if counter(4) == 0
        counter(4) = numF(4);
        if swap(4) == 1
            swap(4) = 0;
        else
            swap(4) = 1;
        end
      end
    
    if swapType == 1
        if swap(4) ~= 0
            for j = 1:numLn
                Screen('FillRect', window, color4, chess4(:,:,j));
                Screen('FillRect', window, black, chess4_off(:,:,j));            
            end
        else
            for j = 1:numLn
                Screen('FillRect', window, black, chess4(:,:,j));
                Screen('FillRect', window, color4, chess4_off(:,:,j));
            end
        end
   elseif swapType == 0
        if swap(4) ~= 0
            Screen('FillRect', window, c4, flash_4);
        else
            Screen('FillRect', window, bgc, flash_4);
        end
    end
 
%    if colorMode == 1
%       c4(1) = c4(1)-colorChange;
%    else 
%        c4 = [1 1 1];
%    end
    
    counter(4) = counter(4) - 1;

    %%%%%%%%%%%%%%%%%%%%%%% Flickering 5 %%%%%%%%%%%%%%%%%%%%%%%
  
    if interface == 1     
    if counter(5) == 0
        counter(5) = numF(5);
        if swap(5) == 1
            swap(5) = 0;
        else
            swap(5) = 1;
        end
      end
    
    if swapType == 1
        if swap(5) ~= 0
            for j = 1:numLn
                Screen('FillRect', window, color5, chess5(:,:,j));
                Screen('FillRect', window, black, chess5_off(:,:,j));            
            end
        else
            for j = 1:numLn
                Screen('FillRect', window, black, chess5(:,:,j));
                Screen('FillRect', window, color5, chess5_off(:,:,j));
            end
        end
    elseif swapType == 0
         if swap(5) ~= 0
             Screen('FillRect', window, c5, flash_5);
         else
             Screen('FillRect', window, bgc, flash_5);
         end
     end
 
%     if colorMode == 1
%         c4(1) = c4(1)-colorChange;
%     else 
%         c4 = [1 1 1];
%     end
    
    counter(5) = counter(5) - 1;
  end

     %%%%%%%%%%%%%%%%%%%%%%% Flickering 6 %%%%%%%%%%%%%%%%%%%%%%%
 
     if interface == 2  
      if counter(5) == 0
        counter(5) = numF(5);
        if swap(5) == 1
            swap(5) = 0;
        else
            swap(5) = 1;
        end
      end
    
    if swapType == 1
        if swap(5) ~= 0
            for j = 1:numLn
                Screen('FillRect', window, color5, chess5(:,:,j));
                Screen('FillRect', window, black, chess5_off(:,:,j));            
            end
        else
            for j = 1:numLn
                Screen('FillRect', window, black, chess5(:,:,j));
                Screen('FillRect', window, color5, chess5_off(:,:,j));
            end
        end
    end
    counter(5) = counter(5) - 1;
  
    if counter(6) == 0
        counter(6) = numF(6);
        if swap(6) == 1
            swap(6) = 0;
        else
            swap(6) = 1;
        end
      end
    
    if swapType == 1
        if swap(6) ~= 0
            for j = 1:numLn
                Screen('FillRect', window, color6, chess6(:,:,j));
                Screen('FillRect', window, black, chess6_off(:,:,j));            
            end
        else
            for j = 1:numLn
                Screen('FillRect', window, black, chess6(:,:,j));
                Screen('FillRect', window, color6, chess6_off(:,:,j));
            end
        end
    end    
    counter(6) = counter(6) - 1;
     end
 
 %%%%%% RED VISUAL FEEDBACK %%%%%

 if command == 0 && ccheck(1) < 100
    ccheck(1) = ccheck(1)+1;
    ccheck(2) = 0; ccheck(3) = 0; ccheck(4) = 0; ccheck(5) = 0;
    c3 = [1 0 0];
 end
 if command == 1 && ccheck(2) < 100
    ccheck(1) = 0;    
    ccheck(2) = ccheck(2)+1;
    ccheck(3) = 0; ccheck(4) = 0;ccheck(5) = 0;
    c4 = [1 0 0];
 end
 if command == 2 && ccheck(3) < 100
    ccheck(1) = 0; ccheck(2) = 0;
    ccheck(3) = ccheck(3)+1;
    ccheck(4) = 0; ccheck(5) = 0;
    c5 = [1 0 0];
 end
 if command == 3 && ccheck(4) < 100
    ccheck(1) = 0; ccheck(2) = 0; ccheck(3) = 0;
    ccheck(4) = ccheck(4)+1; 
    ccheck(5) = 0;
    c1 = [1 0 0];
 end 
 if command == 4 && ccheck(5) < 100
    ccheck(1) = 0; ccheck(2) = 0; ccheck(3) = 0; ccheck(4) = 0;
    ccheck(5) = ccheck(5)+1;
    c2 = [1 0 0];
 end
 
 
 %%%RED_DOTS%%%
 
 if grow == 1 && count < 50
    count = count+1;
    for i = 1:4
         if i == 1
            for i = 1:5
            center((4*i)-3)=center((4*i)-3)-rate;
            end
         elseif i == 2
            for i = 1:5
            center((4*i)-2)=center((4*i)-2)-rate;
            end
         elseif i == 3
            for i = 1:5
            center((4*i)-1)=center((4*i)-1)+rate;
            end
         elseif i == 4
            for i = 1:5
            center((4*i))=center(4*i)+rate;
          end
       end
    end
 end

 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %TEXT FEEDBACK
 
 
 
 if command == 5
    Screen('DrawText', window, 'WAITING FOR COMMAND', 800 , 800, white);
    Screen('DrawText', window, 'GAZE UPON A FLICKER', 800 , 850, white);
 end
 if command == 0
    Screen('DrawText', window, 'Command 1 recieved', 800 , 800, white);
    Screen('DrawText', window, 'SHUT DOWN', 800 , 850, white);
 end
 if command == 1
    Screen('DrawText', window, 'Command 2 recieved', 800 , 800, white);
    Screen('DrawText', window, 'HOME POSITION', 800 , 850, white);
 end
 if command == 2
    Screen('DrawText', window, 'Command 3 recieved', 800 , 800, white);
    Screen('DrawText', window, 'OPENING DOOR', 800 , 850, white);
 end 
 if command == 3
    Screen('DrawText', window, 'Command 4 recieved', 800 , 800, white);
    Screen('DrawText', window, 'CLOSING DOOR', 800 , 850, white);
 end
 if command == 4
    Screen('DrawText', window, 'Command 5 recieved', 800 , 800, white);
    Screen('DrawText', window, 'FULL STOP', 800 , 850, white);
 end
 
%  RED BOX EXPAND ON FEEDBACK
%  if command == 0 && count(1) < 50
%      count(1) = count(1)+1;
%      
%      center(1) = center(1)-rate;
%      center(2) = center(2)-rate;
%      center(3) = center(3)+rate;
%      center(4) = center(4)+rate;
%  end
%  
%  if count(1) == 50
%     countx(1) = countx(1)+1;
%  end
%  
%  if countx(1) == 100
%      count(1) = 0;
%      countx(1) = 0;
%      rate = rate*-1;
%  end
%  
%  if command == 1 && count(2) < 50
%      count(2) = count(2)+1;
%      center(5) = center(5)-rate;
%      center(6) = center(6)-rate;
%      center(7) = center(7)+rate;
%      center(8) = center(8)+rate;
%  end
%  if count(2) == 50
%     countx(2) = countx(2)+1;
%  end
%   if countx(2) == 100
%      count(2) = 0;
%      countx(2) = 0;
%      rate = rate*-1;
%  end
%  
%  if command == 2 && count(3) < 50
%     count(3) = count(3)+1;
%     center(9) = center(9)-rate;
%     center(10) = center(10)-rate;
%     center(11) = center(11)+rate;
%     center(12) = center(12)+rate;
%  end
%  if count(3) == 50
%     countx(3) = countx(3)+1;
%  end
%  if countx(3) == 100
%      count(3) = 0;
%      countx(3) = 0;
%      rate = rate*-1;
%  end
%  
%  if command == 3 && count(4) < 50
%     count(4) = count(4)+1;
%     center(13) = center(13)-rate;
%     center(14) = center(14)-rate;
%     center(15) = center(15)+rate;
%     center(16) = center(16)+rate;
%  end
%  if count(4) == 50
%     countx(4) = countx(4)+1;
%  end
%  if countx(4) == 100
%      count(4) = 0;
%      countx(4) = 0;
%      rate = rate*-1;
%  end
%   
%  if command == 4 && count(5) < 50
%     count(5) = count(5)+1;
%     center(17) = center(17)-rate;
%     center(18) = center(18)-rate;
%     center(19) = center(19)+rate;
%     center(20) = center(20)+rate;
%  end       
%  if count(5) == 50
%     countx(5) = countx(5)+1;
%  end
%  if countx(5) == 100
%      count(5) = 0;
%      countx(5) = 0;
%      rate = rate*-1;
 %end
  
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
 if swapType == 1
     Screen('FillRect', window, [1; 0; 0], center(:,1)); % draw red center
     Screen('FillRect', window, [1; 0; 0], center(:,2));
     Screen('FillRect', window, [1; 0; 0], center(:,3));
     Screen('FillRect', window, [1; 0; 0], center(:,4));
 elseif swapType == 0
     Screen('FillRect', window, [1; 0; 0], center_1(:,1));
     Screen('FillRect', window, [1; 0; 0], center_1(:,2));
     Screen('FillRect', window, [1; 0; 0], center_1(:,3));
     Screen('FillRect', window, [1; 0; 0], center_1(:,4));
 end    
 
 if interface == 1
    Screen('FillRect', window, [1; 0; 0], center(:,5));
 end
 
color1 = [c1(1) c1(1) c1(1) c1(1) ; c1(2) c1(2) c1(2) c1(2) ; c1(3) c1(3) c1(3) c1(3)];
color2 = [c2(1) c2(1) c2(1) c2(1) ; c2(2) c2(2) c2(2) c2(2) ; c2(3) c2(3) c2(3) c2(3)];
color3 = [c3(1) c3(1) c3(1) c3(1) ; c3(2) c3(2) c3(2) c3(2) ; c3(3) c3(3) c3(3) c3(3)];
color4 = [c4(1) c4(1) c4(1) c4(1) ; c4(2) c4(2) c4(2) c4(2) ; c4(3) c4(3) c4(3) c4(3)];
color5 = [c5(1) c5(1) c5(1) c5(1) ; c5(2) c5(2) c5(2) c5(2) ; c5(3) c5(3) c5(3) c5(3)];

vbl = Screen('Flip', window, vbl + (waitframes -0.5) * ifi); % flip the screen 
    
end

sca;

 
