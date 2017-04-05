

function [wts,binfrqs] = fft2melmx(nfft, sr, nfilts, width, minfrq, maxfrq, htkmel, constamp)
if nargin < 2;     sr = 8000;      end
if nargin < 3;     nfilts = 40;    end
if nargin < 4;     width = 1.0;    end
if nargin < 5;     minfrq = 0;     end  % default bottom edge at 0
if nargin < 6;     maxfrq = sr/2;  end  % default top edge at nyquist
if nargin < 7;     htkmel = 0;     end
if nargin < 8;     constamp = 0;   end
wts = zeros(nfilts, nfft);
% Center freqs of each FFT bin
fftfrqs = [0:(nfft/2)]/nfft*sr;
% 'Center freqs' of mel bands - uniformly spaced between limits
minmel = hz2mel(minfrq, htkmel);
maxmel = hz2mel(maxfrq, htkmel);
binfrqs = mel2hz(minmel+[0:(nfilts+1)]/(nfilts+1)*(maxmel-minmel), htkmel);
binbin = round(binfrqs/sr*(nfft-1));
for i = 1:nfilts
fs = binfrqs(i+[0 1 2]);
% scale by width
fs = fs(2)+width*(fs - fs(2));
% lower and upper slopes for all bins
loslope = (fftfrqs - fs(1))/(fs(2) - fs(1));
hislope = (fs(3) - fftfrqs)/(fs(3) - fs(2));
 wts(i,1+[0:(nfft/2)]) = max(0,min(loslope, hislope));
end
if (constamp == 0)
wts = diag(2./(binfrqs(2+[1:nfilts])-binfrqs(1:nfilts)))*wts;
end
% Make sure 2nd half of FFT is zero
wts(:,(nfft/2+1):nfft) = 0;
function f = mel2hz(z, htk)
if nargin < 2
htk = 0;
end
if htk == 1
f = 700*(10.^(z/2595)-1);
else
f_0 = 0; 
f_sp = 200/3; 
brkfrq = 1000;
brkpt  = (brkfrq - f_0)/f_sp;  % starting mel value for log region
logstep = exp(log(6.4)/27); 
linpts = (z < brkpt);
f = 0*z;
% fill in parts separately
f(linpts) = f_0 + f_sp*z(linpts);
f(~linpts) = brkfrq*exp(log(logstep)*(z(~linpts)-brkpt));
end
function z = hz2mel(f,htk)
if nargin < 2
htk = 0;
end
if htk == 1
z = 2595 * log10(1+f/700);
else
% Mel fn to match Slaney's Auditory Toolbox mfcc.m
f_0 = 0; 
f_sp = 200/3; 
brkfrq = 1000;
brkpt  = (brkfrq - f_0)/f_sp;  % starting mel value for log region
logstep = exp(log(6.4)/27); 
linpts = (f < brkfrq);
z = 0*f;
z(linpts) = (f(linpts) - f_0)/f_sp;
z(~linpts) = brkpt+(log(f(~linpts)/brkfrq))./log(logstep);
end

