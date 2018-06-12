%takes a long time to complete because of the amount of processing
%sounds like a clarinet
function soundOut = waveshapesynth(fs,dur,root);
%recommended Fs be lower than 11025 and duration of 1 second,
%because of the number of computations needed.
dt = 1/fs;
t = dt:dt:dur;
fm = root;
x = cos(2*pi*fm*t);
%this is to generate the attack/delay sequence as seen in the Jerse diagram
%used .12 and .88 as estimations of the 0.085 and 0.65 second attack/delay
%by scaling the total time of the note up to 1 second
%this method of doing attack/delay would not allow decimal durations.
A = linspace(0,1,0.12*length(t));
D = linspace(1,0,0.88*length(t));
ad = [A D];
y = 255.*ad.*x;
yu = y + 256;
%%%building the transfer function using a piecewise defined function
%%%generator
syms F(x) 
F(x) = piecewise(0<=x<=200, ((1/400)*x)-1, 200<x<312, ((1/112)*x)-(0.5+(200/112)), x>=312, ((1/(2*199))*x) +((1/2)-(312/(2*199))));
%creating this sound takes a lot of time
sound = F(yu);
soundOut = real(double(sound));
end