% Clear the workspace and the screen
sca;
close all;
clearvars;

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

runtime = 55; % Setting Runtime, in sec. 
box = 60; % Size of each small box
size = 2.5; % Size of box if not use Chessboard
numLn = 6; % number of lines per Chessboard
numSq = 4; % number of (boxes*2) pr line
swapType = 0; % 0 if full flash, 1 if chessboard
colorMode = 0; % Set to 1, if color should change over time
grow = 0; % pixel growth

% Set the colors [R G B]
c1 = [1 1 1]; % Color Chess 1
c2 = [1 1 1]; % Color Chess 2
c3 = [1 1 1]; % Color Chess 3
c4 = [1 1 1]; % Color Chess 4

color1 = [c1(1) c1(1) c1(1) c1(1) ; c1(2) c1(2) c1(2) c1(2) ; c1(3) c1(3) c1(3) c1(3)];
color2 = [c2(1) c2(1) c2(1) c2(1) ; c2(2) c2(2) c2(2) c2(2) ; c2(3) c2(3) c2(3) c2(3)];
color3 = [c3(1) c3(1) c3(1) c3(1) ; c3(2) c3(2) c3(2) c3(2) ; c3(3) c3(3) c3(3) c3(3)];
color4 = [c4(1) c4(1) c4(1) c4(1) ; c4(2) c4(2) c4(2) c4(2) ; c4(3) c4(3) c4(3) c4(3)];

black = [0 0 0 0 ; 0 0 0 0 ; 0 0 0 0 ]; % black color

% Setting Frequencies 
f = [8.6 10 12 15];
f = f;
numS = [1/f(1) 1/f(2) 1/f(3) 1/f(4)]; % Number of Seconds before switch color
numF = [round(numS(1)/ifi) round(numS(2)/ifi) round(numS(3)/ifi) round(numS(4)/ifi)];
%numF = [5 4 3 2]% Number of Frames for each frequencies
runT = round([f(1)/2*runtime f(2)/2*runtime f(3)/2*runtime f(4)/2*runtime]); % Number of frames the loop goes through 
 
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
for i = 1:4
    if i == 1
        center(:,i) = [box*4 - box/4 ; box*3 - box/4 ; box*4 + box/4 ; box*3 + box/4];
    end
    if i == 2
        center(:,i) = [box*4 - box/4 ; sYp - (box*3 + box/4) ; box*4 + box/4 ; sYp - (box*3 - box/4)];
    end        
    if i == 3
        center(:,i) = [sXp - box*4 - box/4 ; box*3 - box/4 ; sXp - box*4 + box/4 ; box*3 + box/4];
    end
    if i == 4
         center(:,i) = [sXp - box*4 - box/4 ; sYp - (box*3 + box/4) ; sXp - box*4 + box/4 ; sYp - (box*3 - box/4)];
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%% SOUND SETUP %%%%%%%%%%%

% wavfilename_1 = 'C:\Users\munch\Desktop\SoundBites\initiating_program.wav';
% wavfilename_2 = 'C:\Users\munch\Desktop\SoundBites\moving_robot.wav';
% 
% % Read WAV file from filesystem:
% [y, freq_1] = psychwavread(wavfilename_1);
% wavedata = y';
% [y, freq_2] = psychwavread(wavfilename_2);
% wavedata = y';

% % Perform basic initialization of the sound driver:

% InitializePsychSound;

% % Read WAV file from filesystem:
% [y, freq] = psychwavread(wavfilename_1);
% wavedata = y';
% nrchannels = size(wavedata,1); % Number of rows == number of channels.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                              MAIN CODE                                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Priority(topPriorityLevel);
vbl = Screen('Flip', window);
counter = [0 0 0 0];
swap = [0 0 0 0];
white = [1 1 1];
colorChange = 0.001;
count = 0 ;
count2 = 0;
rate = 0.3;
%for i = (1:(60*runtime))
while ~KbCheck
     
%%%Draw Text%%%

%if KbCheck()
%    colorChange = colorChange + 0.001;
%end

Screen('DrawText', window, 'Command 1', 630 , 70, white);
Screen('DrawText', window, 'Open Door', 630 , 120, white);

Screen('DrawText', window, 'Command 2', 1100, 70, white);
Screen('DrawText', window, 'Hello world', 1100, 120, white);

Screen('DrawText', window, 'Command 3', 630,  730, white);    
Screen('DrawText', window, 'Move Object', 630,  780, white);    

Screen('DrawText', window, 'Command 4', 1100, 730, white);
Screen('DrawText', window, 'Sleep Mode', 1100, 780, white);

% xy = [0 0];
% % Screen('DrawLines', window, xy , 10 , white);
% Screen('DrawDots', window, xy , 20 , white);

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
    for k = 1:3
        if c1(k)<0
            c1 = [1 1 1];
        elseif c2(k)<0
            c2 = [1 1 1];
        elseif c3(k)<0
            c3 = [1 1 1];
        elseif c4(k)<0
            c4 = [1 1 1];
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

    
    if colorMode == 1
        c1(2) = c1(2)-colorChange;
        c1(3) = c1(3)-colorChange;
    else
        c1 = [1 1 1];
    end
    
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
    
    if colorMode ==1
        c2(1) = c2(1)-colorChange;
        c2(3) = c2(3)-colorChange;
    else
        c2 = [1 1 1];
    end
    
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
    
    if colorMode == 1
        c3(1) = c3(1)-colorChange;
        c3(2) = c3(2)-colorChange;
    else
        c3 = [1 1 1];
    end
    
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
 
    if colorMode == 1
        c4(1) = c4(1)-colorChange;
    else 
        c4 = [1 1 1];
    end
    
    counter(4) = counter(4) - 1;

 %%%RED_DOTS%%%
 
 if grow == 1 && count < 100
    count = count+1;
    for i = 1:4
         if i == 1
            for i = 1:4
            center_1((4*i)-3)=center_1((4*i)-3)-rate;
            end
         elseif i == 2
            for i = 1:4
            center_1((4*i)-2)=center_1((4*i)-2)-rate;
            end
         elseif i == 3
            for i = 1:4
            center_1((4*i)-1)=center_1((4*i)-1)+rate;
            end
         elseif i == 4
            for i = 1:4
            center_1((4*i))=center_1(4*i)+rate;
            end
         end
    end
 end
 
 if count == 100
    count2 = count2+1;
 end
    
 if count2 == 200
     count = 0;
     count2 = 0;
     rate = rate*-1;
 end
 
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
     
color1 = [c1(1) c1(1) c1(1) c1(1) ; c1(2) c1(2) c1(2) c1(2) ; c1(3) c1(3) c1(3) c1(3)];
color2 = [c2(1) c2(1) c2(1) c2(1) ; c2(2) c2(2) c2(2) c2(2) ; c2(3) c2(3) c2(3) c2(3)];
color3 = [c3(1) c3(1) c3(1) c3(1) ; c3(2) c3(2) c3(2) c3(2) ; c3(3) c3(3) c3(3) c3(3)];
color4 = [c4(1) c4(1) c4(1) c4(1) ; c4(2) c4(2) c4(2) c4(2) ; c4(3) c4(3) c4(3) c4(3)];

vbl = Screen('Flip', window, vbl + (waitframes -0.5) * ifi); % flip the screen 
    
end


%
%  BasicSoundOutputDemo(1,wavfilename_1,2);

% BasicSoundOutputDemo(1,wavfilename_2,2);
% % Stop playback:
% PsychPortAudio('Stop', pahandle_1);
% 
% % Close the audio device:
% PsychPortAudio('Close', pahandle_2);

 
% % Flip to the screen
% Screen('Flip', window);

% Clear the screen
sca;

 