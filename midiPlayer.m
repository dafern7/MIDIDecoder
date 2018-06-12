midiplayer('dont_speak-no_doubt.mid', 'normal');
%additive and Fm sound strange
%first play is more desynchronized than the second
%need to try twice to hear the proper sound
%could be a result of parfor command?
%tested using mario.mid, ROW.mid, jesu.mid, around_the_world-atc.mid
%MIDI_sample.mid, dont_speak-no_doubt.mid
function midiplayer(filename, patch)

[A] = fread(fopen(filename),'uint8');
%referenced Ken Schutte's midi reader to help with converting from deltatime to duration.
%%%%%%%%%%%%%%%%%%headerstuff%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%check header 
if ~(A(1:4) == [77 84 104 100])
    fprintf('wrong header!');
end
%getting information from header
headlength = bytedecoder(A(5:8));
format = bytedecoder(A(9:10));
tracknum = bytedecoder(A(11:12));
ppq = bytedecoder(A(13:14));
%%%%%%%%%%%%%%%%%%%%%%%%%%endofheaderstuff%%%%%%%%%%%%%%%%%%%%
%header puts byte count at 15
%separate into tracks cell array
counter = 15;
for i = 1:tracknum
    %check TRACK header 
    if ~(A(counter:counter+3) == [77 84 114 107])
        fprintf('wrong trkheader!');
    end
    %increment after checking header
    counter = counter+4;
    %track length follows track header
    trklen = bytedecoder(A(counter:counter+3));
    counter = counter+4;
    %storing tracks in a cell array of variable size
    %not sure how to initialize 
    track{i} = A((counter-8):(counter+trklen-1)); %counts from the initial 'count' to the last element in the track
    %before the final track bytes
    %increment to next track
    counter = counter+trklen;
end
%end of separating into tracks
%start looking through tracks
for i = 1:tracknum
%renaming each element in the array
currtrk = track{i};
x = 1; 
counter = 9; %command bits start after the header/length
while(counter < length(currtrk))
    clear command; %making another subarray(vector) of command within each array in the cell array
    %see varlengthdecode for details on this function
    [duration,counter] = varlengthdecode(currtrk,counter);
    %the first 1 or 2 bytes are always deltatime (even for metaevents)
    if counter == length(currtrk)
        %added as an extra precaution to force this loop to break after the
        %track ends
        break
    end
    %catching all the occasions of metaevents
    if currtrk(counter) == 255 %FF metaevent
        if currtrk(counter+1) == 00
            len = currtrk(counter+2);
            counter = counter + 3
            str = currtrk(counter:counter+len);
            counter = counter + len;
        elseif currtrk(counter+1) == 01
            len = currtrk(counter+2);
            counter = counter + 3;
            str = currtrk(counter:counter+len);
            counter = counter + len;
        elseif currtrk(counter+1) == 02
            len = currtrk(counter+2);
            counter = counter + 3;
            str = currtrk(counter:counter+len);
            counter = counter + len;
        elseif currtrk(counter+1) == 03
            len = currtrk(counter+2);
            counter = counter + 3;
            trkname = currtrk(counter:counter+len-1);
            counter = counter + len;
        elseif currtrk(counter+1) == 04
            len = currtrk(counter+2);
            counter = counter + 3;
            str = currtrk(counter:counter+len);
            counter = counter + len;
        elseif currtrk(counter+1) == 05
            len = currtrk(counter+2);
            counter  = counter + 3;
            str = currtrk(counter:counter+len);
            counter = counter + len;
        elseif currtrk(counter+1) == 06
            len = currtrk(counter+2);
            counter = counter + 3;
            str = currtrk(counter:counter+len);
            counter = counter + len;
        elseif currtrk(counter+1) == 32 %don't know what this does
            len = currtrk(counter+2);
            counter = counter + 3;
            str = currtrk(counter:counter+len);
            counter = counter + len;
        elseif currtrk(counter+1) == 33 %unsure
            len = currtrk(counter+2);
            counter = counter + 3;
            str = currtrk(counter:counter+len);
            counter = counter + len;
        elseif currtrk(counter+1) == 47
            if currtrk(counter) == 0 
                break
            end
        elseif currtrk(counter+1) == 81
            len = currtrk(counter+2);
            counter = counter+3;
            tempo = bytedecoder(currtrk(counter:counter+len-1));
            counter = counter + len;
        elseif currtrk(counter+1) == 84
            len = currtrk(counter+2);
            %not sure
            counter = counter + len+1;
        elseif currtrk(counter+1) == 88
            len = currtrk(counter+2);
            counter = counter + 3;
            num = currtrk(counter);
            dec = 2^(currtrk(counter+1));
            ticksperclick = currtrk(counter+2);
            bb = currtrk(counter+3);
            counter = counter + len;
        elseif currtrk(counter+1) == 89
            len = currtrk(counter+2);
            counter = counter + 3;
            sharpflat = currtrk(counter);
            minormajor = currtrk(counter+1);
            counter = counter + len;
        end
        %{
    elseif currtrk(counter) == 241
    elseif currtrk(counter) == 242
    elseif currtrk(counter) == 243
    elseif currtrk(counter) == 244
    elseif currtrk(counter) == 245
    elseif currtrk(counter) == 246
    %system real time message
    elseif currtrk(counter) == 248
    elseif currtrk(counter) == 249     
    elseif currtrk(counter) == 250
    elseif currtrk(counter) == 251
    elseif currtrk(counter) == 252
    elseif currtrk(counter) == 253
    elseif currtrk(counter) == 254
        %}
    %the manufacturer code begin at 240 , end at a value of 247
    elseif currtrk(counter) == 240
        n = 1;
        manu = [];
        while n
            if currtrk(counter) == 247
                n = 0;
                counter = counter+1;
            else
               y = currtrk(counter+1);
               manu = [manu y];
               counter = counter + 1;
            end
        end
        manu(1,end) = 0; %truncate manufacturer code as it default ends in 247    
    else
        %running mode means perform previous command, usually denoted as
        %the deltatime followed immediately by the databits
        %commands all are greater than 128, so no command means the current
        %track value must be less than 128 if in running mode
        if (currtrk(counter) < 128)
            com = prev; %prev is the previous command
        else
            %when there is a command
            com = currtrk(counter);
            counter = counter + 1;
        end
        %not sure how to implement channel
        %commands are always the first four bytes right shift for easier to read value
        %voice commands
        bitshiftedCom = bitshift(com,-4);
        if (bitshiftedCom >= 8 && bitshiftedCom<=14) 
        % bin(8) = 1000, bin(14) = 1110 -> reference table of voice
        % commands
            vcomm = bitshift(bitshiftedCom,4); 
            %reshift bytes to get a specific type of voice command
            if vcomm == 128;
                len = 2;
            elseif vcomm==144;
                len = 2;
            elseif vcomm==160;
                len = 2;
            elseif vcomm==176;
                len = 2;
            elseif vcomm==192; %patch change
                len = 1;
            elseif vcomm==208
                len = 1;
            elseif vcomm==224
                len = 2;
            else 
                fprintf('not a supported channel voice type');
            end
         data = currtrk(counter:(counter+len-1));
         counter = counter + len;
         prev = vcomm;  
        end
        %use class based system (struct?)
        %storing vcomm (usually note on/note off) [vcomm]
        command.vcomm = vcomm;
        %storing duration of note [deltatime]
        command.deltatime = duration;
        %storing the data of the note [freq(midi) vel]
        command.data = data;
        %command is the subarray of the array element in the cell array 
        output.currtrk{i}.commands(x) = command;
        x = x+1; %increment the row of currtrk to put the command vector
    end
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%this section is to prevent the next section from trying to read an empty
%array (an array with no commands)
%need to find a more efficient way to do this
y = length(output.currtrk);
w = 1;
n = 1;
while n
    if isequal(output.currtrk{w}, []) 
    w = w+1;
    else 
        break
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
plays = cell(y,1);
%plays in the cell array that stores arrays called play
%play is a compilation of all the rows of command
for i = w:y
    play = zeros(0,4);
    sec = 0;
    for z = 1:length(output.currtrk{i}.commands)
        command = output.currtrk{i}.commands(z); 
        %increment 'sec' by each deltatime
        sec = sec + ((command.deltatime/ppq)*((tempo/1000000))); 
        if command.vcomm == 144 && command.data(2) > 0 %144 -> note on, if vel is 0, means note off, so avoid that
            play(end+1,:) = [command.data(1) command.data(2) sec 0]; %storing each command in an array that can be played
            %sec is the starting time for the command, 0 initializes the
            %endtime dependent on the deltatime stored in command
        elseif (command.vcomm == 144 && command.data(2) == 0) || command.vcomm == 128 %128 -> note off, see above
            %when note off is come across, look through the array for the
            %same midi freq and the end time has not been set yet.
            f = find((play(:,1)==command.data(1))+(play(:,4)==0)==2);
            %set end time for that particular note
            play(f,4) = sec;
        end
    end
    %put each array play in cell array plays
    plays{i} = play;
end

if exist('minormajor', 'var') 
    if minormajor == 0
    fprintf('major\n');
    elseif minormajor == 1
    fprintf('minor\n');
    end
else
    fprintf('no information on major/minor\n');
end
if exist('bb', 'var')
    if bb == 8
    fprintf('standard number of 32nd notes per quarter note\n');
    else
    fprintf('%d 32nd notes per quarter note\n',bb);
    end
else
    fprintf('no information on 32nd notes per quarter note\n');
end
if exist('ticksperclick', 'var')
    if ticksperclick == 24
    fprintf('standard number of metronome ticks\n');
    end
else
    fprintf('no information on metronome ticks\n');
end
if exist('num', 'var') && exist('dec','var')
    fprintf('time signature: %d/%d\n',num,dec);
end
if exist('tempo','var')
    fprintf('tempo is %d\n',tempo);
end

%format 0, play track in a row
%format 1, play tracks simul
%format 2, unsure
if format == 0
    for n = 1:y
        playsound(plays{n},patch)
    end
elseif format == 1
    parfor n=1:y %uses parallel processing function in matlab
        playsound(plays{n},patch)
    end  
end

end

%was unsure how to implement patch changes, since there are only two in
%addition to normal sine tone, additive, Fm
%no waveshaping because of the duration of time it takes to run
function playsound(play,patch)
deltime = [];
for i = 1:length(play);
Fs = 44100;
if play(i,1) < 40
    %if pitch is lower than 40, won't play, to remedy this
f = 3*(33*2.^((play(i,1)-24)/12));
else
    %midi frequency equation conversion using equal temperament
f = 33*2.^((play(i,1)-24)/12);
end
dur = play(i,4) - play(i,3);
t = 0:1/Fs:dur;
switch patch
    case 'normal'
        y = sin(2*pi*f*t);
    case {'Additive','FM'}
        y = create_sound(patch,f,Fs,dur);
end
%to time the pauses in between each note
if i == 1
    deltime(i) = play(i,3);
else
    deltime(i) = play(i,3) - play(i-1,3);
end
pause(deltime(i))
soundsc(y,Fs)
end
end








       






    
    



    
    
    