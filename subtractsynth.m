%fade in by envelope on the final filtered x, but needs a envelope on the
function y2 = subsynth(fs,dur,root)
dt = 1/fs;
t = 1:dt:dur;
fm = root;
x = sawtooth(2*pi*fm*t); %generation of sawtooth wave
%filtering attenuates the higher frequencies, which makes a "softer", less
%harsh noise
%N = 2; want a second order iir filter
%Wn = 0.9; raising the cutoff frequency means less frequencies are attenuated, so more of the actual signal
%is present in the final result
%[b,a] = butter(N,Wn); using butterworth filter to get the coefficients of the second order filter
%%%%%%%%coeff where filter is closed,low cutoff frequency means "softer tones"
bclosed = [0.0201    0.0402    0.0201];
aclosed = [1.0000   -1.5610    0.6414];
%%%%%%%%coeff where filter is open, high cutoff frequency means harsher ton
bopen = [0.8006    1.6012    0.8006];
aopen = [1.0000    1.5610    0.6414];
%making the b,a filter coefficients change with time using a for loop
n = length(t);
y = zeros(1,length(x));
b = zeros(n,3);
a = zeros(n,3);
prevb1 = bopen(1);
preva1 = aopen(1);
prevb2 = bopen(2);
preva2 = aopen(2);
prevb3 = bopen(3);
preva3 = aopen(3);
%generates the vectors for b and a from a "closed" state to an "open" state
for i = 1:n
    b1(i) = bclosed(1)+((bopen(1)-prevb1)*((t(i)/dur)));
    prevb1 = b1(i);
    a1(i) = aclosed(1)+((aopen(1)-preva1)*(t(i)/dur));
    preva1 = a1(i);
    b2(i) = bclosed(2)+((bopen(2)-prevb2)*((t(i)/dur)));
    prevb2 = b2(i);
    a2(i) = aclosed(2)+((aopen(2)-preva2)*(t(i)/dur));
    preva2 = a2(i);
    b3(i) = bclosed(3)+((bopen(3)-prevb3)*((t(i)/dur)));
    prevb3 = b3(i);
    a3(i) = aclosed(3)+((aopen(3)-preva3)*(t(i)/dur));
    preva3 = a3(i);
    b(i,:) = [b1(i) b2(i) b3(i)];
    a(i,:) = [a1(i) a2(i) a3(i)];
end
for i = 1:n
    y = filter(b(i,:),a(i,:),x);
end
%not sure how to apply all the b,a vectors from the for loop to make y
%change with time

y1 = filter(bclosed,aclosed,x); 
%amplitude envelope to make sound fade in
y2 = log(t).*y1;
%}
end