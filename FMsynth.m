%dies off quickly
%supposed to sound like a bell
function yc = fmsynth(fs,dur,root)
dt = 1/fs;
t = 0:dt:dur;
IMAX = 1; %raising this makes the tone sound much harsher
fm = root; %lowering this lowers the pitch of the tone
A = 5;%arbitrarily chosen value for amplitude
fc = 200; %different combinations of IMAX,fm,fc lead to very interesting results
A1 = (A*exp(-t));
A2 = (IMAX*exp(-t));
ym = A2.*cos(2*pi*fm*t); %modulating wave
yc = A1.*cos(2.*pi.*(fc+ym).*t);
end