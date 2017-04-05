
function [t,xcr,D,onsetenv,oesr] = tempo2(d,sr,tmean,tsd,debug)
if nargin < 3;   tmean = 120; end
if nargin < 4;   tsd = 0.7; end
if nargin < 5;   debug = 0; end
if sr < 2000
% Onset envelope
oesr = sr;
onsetenv = d;
else
onsetenv = [];
sro = 8000;
% specgram: 256 bin @ 8kHz = 32 ms / 4 ms hop
swin = 256;
shop = 32;
% mel channels
nmel = 40;
% sample rate for specgram frames 
oesr = sro/shop;
end
acmax = round(4*oesr);
D = 0;
if length(onsetenv) == 0
% resample to 8 kHz
if (sr ~= sro)
gg = gcd(sro,sr);
d = resample(d,sro/gg,sr/gg);
sr = sro;
end
D = specgram(d,swin,sr,swin,swin-shop);
% Construct db-magnitude-mel-spectrogram
mlmx = fft2melmx(swin,sr,nmel);
D = 20*log10(max(1e-10,mlmx(:,1:(swin/2+1))*abs(D)));
% Only look at the top 80 dB
D = max(D, max(max(D))-80);
% The raw onset decision waveform
mm = (mean(max(0,diff(D')')));
eelen = length(mm);
% dc-removed mm
onsetenv = filter([1 -1], [1 -.99],mm);
end 
% Find rough global period
% Only use the 1st 90 sec to estimate global pd (avoid glitches?)
maxd = 60;
maxt = 120; % sec
maxcol = min(round(maxt*oesr),length(onsetenv));
mincol = max(1,maxcol-round(maxd*oesr));
xcr = xcorr(onsetenv(mincol:maxcol),onsetenv(mincol:maxcol),acmax);
% find local max in the global ac
rawxcr = xcr(acmax+1+[0:acmax]);
% window it around default bpm
bpms = 60*oesr./([0:acmax]+0.1);
xcrwin = exp(-.5*((log(bpms/tmean)/log(2)/tsd).^2));
xcr = rawxcr.*xcrwin;
xpks = localmax(xcr);  
% zero for the first time)
xpks(1:min(find(xcr<0))) = 0;
% largest local max away from zero
maxpk = max(xcr(xpks));
% Quick and dirty explicit downsampling
lxcr = length(xcr);
xcr00 = [0, xcr, 0];
xcr2 = xcr(1:ceil(lxcr/2))+.5*(.5*xcr00(1:2:lxcr)+xcr00(2:2:lxcr+1)+.5*xcr00(3:2:lxcr+2));
xcr3 = xcr(1:ceil(lxcr/3))+.33*(xcr00(1:3:lxcr)+xcr00(2:3:lxcr+1)+xcr00(3:3:lxcr+2));
if max(xcr2) > max(xcr3)
[vv, startpd] = max(xcr2);
startpd = startpd -1;
startpd2 = startpd*2;
else
[vv, startpd] = max(xcr3);
startpd = startpd -1;
startpd2 = startpd*3;
end
% Weight by superfactors
pratio = xcr(1+startpd)/(xcr(1+startpd)+xcr(1+startpd2));
t = [60/(startpd/oesr) 60/(startpd2/oesr) pratio];
% ensure results are lowest-first
if t(2) < t(1)
t([1 2]) = t([2 1]);
t(3) = 1-t(3);
end  
startpd = (60/t(1))*oesr;
startpd2 = (60/t(2))*oesr;
if debug > 0
% Report results and plot weighted autocorrelation with picked peaks
disp(['Global bt pd = ',num2str(t(1)),' @ ',num2str(t(3)),[' / ' ...
                      ''],num2str(t(2)),' bpm @ ',num2str(1-t(3))]);
end
% subfunction (to avoid picking up the one from wavelet toolbox
function m = localmax(x)
% return 1 where there are local maxima in x (columnwise).
% don't include first point, maybe last point
[nr,nc] = size(x);
if nr == 1
lx = nc;
elseif nc == 1
lx = nr;
x = x';
else
lx = nr;
end
if (nr == 1) || (nc == 1)
m = (x > [x(1),x(1:(lx-1))]) & (x >= [x(2:lx),1+x(lx)]);
if nc == 1
% retranspose
m = m';
end
else
% matrix
lx = nr;
m = (x > [x(1,:);x(1:(lx-1),:)]) & (x >= [x(2:lx,:);1+x(lx,:)]);
end
