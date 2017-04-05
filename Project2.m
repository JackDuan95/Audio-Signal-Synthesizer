clear all;
close all;
clc; 

[Bach, fs1] = audioread('bach_850.mp3');
[Chopin, fs2] = audioread('chpn_op7_1.mp3');
[Elise, fs3] = audioread('elise.mp3');
Bach(:,2) = [];
Chopin(:,2) = [];
Elise(:,2) = [];

%Task One: Determine the number of beats per second for each piece.
[t1,xcr,D,onsetenv,oesr] = tempo2(Bach, fs1);
if t1(:,3) >= 0.5 
    BachBeat = t1(1,1);
elseif t1(:,3) < 0.5 
   BachBeat = t1(1,2);
end
[t2,xcr,D,onsetenv,oesr] = tempo2(Chopin, fs2);
if t2(:,3) >= 0.5 
    ChopinBeat = t2(1,1);
elseif t2(:,3) < 0.5 
   ChopinBeat = t2(1,2);
end
[t3,xcr,D,onsetenv,oesr] = tempo2(Elise, fs3);
if t3(:,3) >= 0.5 
    EliseBeat = t3(1,1);
elseif t3(:,3) < 0.5 
   EliseBeat = t3(1,2);
end

%Task Two: Transcribe each of the 3 music pieces into piano notes including the note and amplitude.
%Extract the amplitude values, frequency values, and time values 
[Bach_complex_domain,Bach_freq_domain,Bach_time_domain]=spectrogram(Bach,rectwin(length(Bach)/(BachBeat*4)),0,[],44100,'yaxis');
%convert the complext amplitude to real amplitude
Bach_amp_domain=abs(Bach_complex_domain);
Bach_time_domain=transpose(Bach_time_domain);
%get the critical frequency for each time interval
[CFrequencyBach, CAmplitudeBach]=pickCriticalFreq(Bach_freq_domain,Bach_time_domain,Bach_amp_domain);
%Convert the freqeuncy to notes
BachNotes=FreqToNotes(CFrequencyBach);
%Store the Notes and amplitude in sheet music array
BachmusicSheet=[BachNotes,CAmplitudeBach];

[Chopin_complex_domain,Chopin_freq_domain,Chopin_time_domain]=spectrogram(Chopin,rectwin(length(Chopin)/(ChopinBeat*4)),0,[],44100,'yaxis');
Chopin_amp_domain=abs(Chopin_complex_domain);
Chopin_time_domain=transpose(Chopin_time_domain);
[CFrequencyChopin, CAmplitudeChopin]=pickCriticalFreq(Chopin_freq_domain,Chopin_time_domain,Chopin_amp_domain);
ChopinNotes=FreqToNotes(CFrequencyChopin);
ChopinmusicSheet=[ChopinNotes,CAmplitudeChopin];

[Elise_complex_domain,Elise_freq_domain,Elise_time_domain]=spectrogram(Elise,rectwin(length(Elise)/(EliseBeat*4)),0,[],44100,'yaxis');
Elise_amp_domain=abs(Elise_complex_domain);
Elise_time_domain=transpose(Elise_time_domain);
[CFrequencyElise, CAmplitudeElise]=pickCriticalFreq(Elise_freq_domain,Elise_time_domain,Elise_amp_domain);
EliseNotes=FreqToNotes(CFrequencyElise);
ElisemusicSheet=[EliseNotes,CAmplitudeElise];
 
%Task Three: take the transcribed music and resynthesize it into a mp3 file.
BachSythesisMP3=NoteToMp3(BachmusicSheet,(BachBeat*4));
Bach2=EnergyEqualizer(Bach,BachSythesisMP3);
audiowrite('Bach2.0.wav',Bach2,44100);

ChopinSythesisMP3=NoteToMp3(ChopinmusicSheet,(ChopinBeat*4));
Chopin2=EnergyEqualizer(Chopin,ChopinSythesisMP3);
audiowrite('Chopin2.0.wav',Chopin2,44100);

EliseSythesisMP3=NoteToMp3(ElisemusicSheet,(EliseBeat*4));
Elise2=EnergyEqualizer(Elise,EliseSythesisMP3);
audiowrite('Elise2.0.wav',Elise2,44100);

%Task Four: Derive quantization statistics on how accurate your re-synthesized process was

% Get the fourier transformed frequency response of both original signal
% and resynthesized signal
Bachf=abs(fft(Bach));
Bach2f=abs(fft(Bach2));
% get the mean of the difference of amplitude and the standard deviation of
% the difference in each time interval, time domain
[AmpDiffSD,AmpDiffM]=diffAmpComp(abs(Bach),abs(Bach2),BachBeat*4);
%get the mean of the difference of amplitude and the standard deviation of
% the difference in frequency domain
[AmpFreqSD,AmpFreqM]=diffFreqComp(Bach,Bach2f);
%get the mean value of the amplitude difference in each time interval
BM=mean(AmpDiffM)
%get the mean value of the amplitude SD in each time interval
BSD=mean(AmpDiffSD)


% Get the fourier transformed frequency response of both original signal
% and resynthesized signal
Chopinf=abs(fft(Chopin));
Chopin2f=abs(fft(Chopin2));
% get the mean of the difference of amplitude and the standard deviation of
% the difference in each time interval, time domain
[AmpDiffSD,AmpDiffM]=diffAmpComp(abs(Chopin),abs(Chopin2),ChopinBeat*4);
%get the mean of the difference of amplitude and the standard deviation of
% the difference in frequency domain
[AmpFreqSD,AmpFreqM]=diffFreqComp(Chopin,Chopin2f);
%get the mean value of the amplitude difference in each time interval
CM=mean(AmpDiffM)
%get the mean value of the amplitude SD in each time interval
CSD=mean(AmpDiffSD)

% Get the fourier transformed frequency response of both original signal
% and resynthesized signal
Elisef=abs(fft(Elise));
Elise2f=abs(fft(Elise2));
% get the mean of the difference of amplitude and the standard deviation of
% the difference in each time interval, time domain
[AmpDiffSD,AmpDiffM]=diffAmpComp(abs(Elise),abs(Elise2),EliseBeat*4);
%get the mean of the difference of amplitude and the standard deviation of
% the difference in frequency domain
[AmpFreqSD,AmpFreqM]=diffFreqComp(Elise,Elise2f);
%get the mean value of the amplitude difference in each time interval
EM=mean(AmpDiffM)
%get the mean value of the amplitude SD in each time interval
ESD=mean(AmpDiffSD)
