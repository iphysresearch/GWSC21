%% Plot the linear transient chirp signal
% Signal parameters
A = 10;
f0 = 50;
f1 = 30;
phi0 = pi;
ta = 0.2;
L = 0.4;
% Instantaneous frequency after 1 sec is 
MaxFreq = f0+2*f1;
samplFreq = 5*MaxFreq;
HalfFreq = 1/2 * MaxFreq;
samplIntrvl = 1/samplFreq;

% Time samples
timeVec = 0:samplIntrvl:1.0;
% Number of samples
nSamples = length(timeVec);

% Generate the signal
sigVec = hwgenltcsig(timeVec,A,f0,f1,phi0,ta,L);

%Plot the signal 
figure;
plot(timeVec,sigVec,'Marker','.','MarkerSize',24);
hold;
plot(0:(1/HalfFreq):1.0,hwgenltcsig(0:(1/HalfFreq):1.0,A,f0,f1,phi0,ta,L),'Marker','o','MarkerSize',14);

%Plot the periodogram
%--------------
%Length of data 
dataLen = timeVec(end)-timeVec(1);
%DFT sample corresponding to Nyquist frequency
kNyq = floor(nSamples/2)+1;
% Positive Fourier frequencies
posFreq = (0:(kNyq-1))*(1/dataLen);
% FFT of signal
fftSig = fft(sigVec);
% Discard negative frequencies
fftSig = fftSig(1:kNyq);

%Plot periodogram
figure;
plot(posFreq,abs(fftSig));

%% Plot a spectrogram
%----------------
sampFreq = 1024/2;
nSamples = 2048/2;
L = 1.4;
timeVec = (0:(nSamples-1))/sampFreq;

% Generate signal
sigVec = hwgenltcsig(timeVec,A,f0,f1,phi0,ta,L);

winLen = 1/64; % perc
ovrlp = winLen/4; % perc
%Convert to integer number of samples 
winLenSmpls = floor(winLen*nSamples);
ovrlpSmpls = floor(ovrlp*nSamples);
[S,F,T]=spectrogram(sigVec,winLenSmpls,ovrlpSmpls,[],sampFreq);

% Plot
figure;
subplot(2,1,1);
plot(timeVec,sigVec);title('l6lab - the linear transient chirp signal');

subplot(2,1,2);
imagesc(T,F,abs(S)); axis xy;
xlabel('Time (sec)');
ylabel('Frequency (Hz)');
saveas(gcf,'l6lab_hwgenltcsig','png')