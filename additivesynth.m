%sort of sounds like a bell
%dies off very slowly
function x = addsynth(fs,dur,root);
%setting all the constants based on the figure in Jerse 4.27
dt = 1/fs;
t = 0:dt:dur;
A = 1;
f = root;
A1 = A ;
A2 = A*0.67;
A3 = A;
A4 = A*1.8;
A5 = A*2.67;
A6 = A*1.67;
A7 = A*1.46;
A8 = A*1.33;
A9 = A*1.33;
A10 = A;
A11 = A*1.33;
f1  = f*.56;
f2 = f*.56+1;
f3 = f*.92;
f4 = f*.92;+1.7;
f5 = f*1.19;
f6 = f*1.7;
f7 = f*2;
f8 = f*2.74;
f9 = f*3;
f10 = f*3.78;
f11 = f*4.07;
t1 = t;
t2 = t*.9;
t3 = t*.65;
t4 = t*.55;
t5 = t*.325;
t6 = t*.35;
t7 = t*.25;
t8 = t*.2;
t9 = t*.15;
t10 = t*.1;
t11 = t*.075;
%generating the sum of sinewaves with varying amplitude envelopes
x = A1*exp(-t1).*cos(2*pi*f1*t) ...
    + A2*exp(-t2).*cos(2*pi*f2*t) ...
    + A3*exp(-t3).*cos(2*pi*f3*t)...
    + A4*exp(-t4).*cos(2*pi*f4*t)...
    + A5*exp(-t5).*cos(2*pi*f5*t)...
    + A6*exp(-t6).*cos(2*pi*f6*t)...
    + A7*exp(-t7).*cos(2*pi*f7*t)...
    + A8*exp(-t8).*cos(2*pi*f8*t)...
    + A9*exp(-t9).*cos(2*pi*f9*t)...
    + A10*exp(-t10).*cos(2*pi*f10*t)...
    + A11*exp(-t11).*cos(2*pi*f11*t);
end
