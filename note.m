function music = note(keyNum,duration,amp)
frequency = (2^((keyNum-49)/12))*440;
fs=44100;  % sampling frequency
values=0:1/fs:duration;
a=(amp/800)*sin(2*pi* frequency*values);
ADSR = adsr(duration,a);
dif = length(a) - length(ADSR); %find out the difference
x = cat(2, ADSR, zeros(1,dif)); %concatenates a horrizontal (2) ADSR + the difference of ADSR and the signal
music = a.* x; %times them together
end
