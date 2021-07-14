clear; clc; close all;

Fs = (6 * 10^4);    % the sampling frequency
Ts = 1 * 10^-3;   % 1 ms symbol spacing, i.e. the baseband samples are Ts seconds apart.
BN = 1/(2*Ts);   % the Nyquist bandwidth of the baseband signal.
ups = (Ts*Fs) ;% number of samples per symbol in the "analog" domain
N = 10         ;  % number of transmitted baseband samples
Nband = 2; % number  of multibands
% Calculate the filter coefficients (N=number of samples in filter)
rolloff = 1;
span = 10;
sps = 10;
my_rrc = rcosdesign(rolloff, span, sps);
t_rrc = (0:length(my_rrc)-1) / Fs;  % the time points that correspond to the filter values
fc = ((1 + rolloff)/(2 * Ts));    %  carrier frequency

% Step T1
M = 4;
ip = randi([0 M-1],Nband,N);
dk = qammod(ip,M);
t_symbols = Ts * (0:N-1) ;   % time instants of the baseband samples

% Step T2)
x = upsample(dk',ups)'; % upsampling
t_x = (0:length(x)-1)/Fs;

% Step T3)
i = real(x);
q = imag(x);

% Step T4)
for nn = 1 : Nband
    iup(nn,:) = conv(i(nn,:), my_rrc .* cos(2*(2*nn-1)*pi*t_rrc*fc) );
    qup(nn,:) = conv(q(nn,:), my_rrc .* -sin(2*(2*nn-1)*pi*t_rrc*fc));
end
t_u = (0:length(iup)-1)/Fs;

% Step T5)
s = iup + qup;
tx = sum(s,1); % mCAP signal

figure()
plot(tx)