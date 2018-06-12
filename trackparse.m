%will assume for this func that all input values are hex converted into
%decimal already. if not, must reconcile
A = [77 84 114 107 00 00 00 26 00 255 88 04 04 02 24 08 00 255 81 03 07 161 32 00 192 05 00 91 60 64 30 96 91 60 00 00 255 47];
if isequal(A(1:4)',[77 84 114 107])  % double('MTrk')
    error('File does not begin with the proper track ID (MTrk)');
end
track_length = A(8);
n = 9;
for i= 1:track_length
if ~(isequal(A(n:n+2),[00 255 88]) || isequal(A(n:n+2),[00 255 81]) || isequal(A(n:n+1),[00 192]))
    break
elseif A(n:n+2) == [00 255 88]
    numtimesig = A(n+4);
    dentimesig = (A(n+5)^2);
    clickpermetronome = A(n+6);
    BBQnote = A(n+7);
    n = n+8
elseif A(n:n+2) == [00 255 81]
    str = dec2hex(A(n+4));
    str1 = dec2hex(A(n+5));
    str2 = dec2hex(A(n+6));
    str = [str str1 str2];
    uSecperppq = hex2dec(str);
    BPM = 60/(uSecperppq/1e6);
    n = n+7;
elseif A(n:n+1) == [00 192]
      patchnum = A(n+2);
      n = n+3;
else 
    fprintf('Error in the metadata');
end
end


track_length
numtimesig
dentimesig
clickpermetronome
BBQnote
uSecperppq
BPM
patchnum
n
Asound = A(n:track_length+9);
Asound
Y = play_sound(Asound);
    
    