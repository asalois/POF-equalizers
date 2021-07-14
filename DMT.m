%%%%%%%%%%%%%%%%%%%%%%%%%%%%% SIMULATION OF A DMT SYSTEM %%%%%%%%%%%%%%%%%%%
%% This program starts off with assigning the number of bits to each subchannel 
% (bit-loading)in the DMT system. Since the SNR of each subchannel is unavailable 
% this allocation is done in a random manner.

% A random data is generated for transmission through each sub-channel.
% Constellation Encoding and Decoding were done with the help of a piece 
% of code available on the Internet.
% Y. SRIRAJA, DEC 2001

clear all;
clc;close all;
% For each of N channels assign no. of bits and genration of the data stream
% such that sum of all (bits/subchannel) = the data length.
N=32; %No. of sub-channels
v=5; % Cyclic prefix length
h1=[1 0.5 0.3 0.2 -0.1 0.02 0.05 0.08 0.01]; % channel impulse response.
k=input('1 Ideal Channel\n  2 Channel with length v+1 \n  3 Channel with length greater than v+1 \n');

if k==1, 
    h=[1];
elseif k==2,
    h=h1(1:6);
elseif k==3, 
    h=h1;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%% Bit Allocation and data generation %%%%%%%%%%%%%%%%%%%%%
for i=1:N-1,
    %Since the SNR of each subchannel is unknown, bit loading is random
    bit_channel(i)=ceil(rand*15);
end
bar(bit_channel,'w');
title('Bit Distribution');
xlabel('Channel Number');
ylabel('bits/channel');

fprintf('Press Enter to continue')
pause
clc
% Data assignment in each channel
for i=1:N-1
    data_channel=[];
    % data_channel is the particular data assigned to the subchannel.
    for j=1:bit_channel(i),
        val=round(rand);
        data_channel=[data_channel val];
    end
    % data conatains all the data_channel values.
    data{i}=data_channel;
end
clear i j;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% CONSTELLATION ENCODING %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculate the intersymbol spacing (based on a transmit 
	% symbol energy of 1).
for i=1:N-1,
    d = sqrt (6/((2^bit_channel(i))-1));
    % The number of bits sent to the top and bottom DACs
	bits_top = ceil(bit_channel(i)/2);
	bits_bot = floor(bit_channel(i)/2);
    % The actual binary data sent to the top and bottom DACs
	data_top = [data{i}(1:bits_top)];
	data_bot = [data{i}(bits_top+1:bit_channel(i))];

	% The decimal value of the data at the top and bottom DACs
    
	v_top = sum(data_top(1:bits_top).*(2.^(0:(bits_top-1))));
	v_bot = sum(data_bot(1:bits_bot).*(2.^(0:(bits_bot-1))));

	% The output values of the top and bottom DACs
	d_top =(v_top*d)-(((2^bits_top-1)/2)*d);
	d_bot =(v_bot*d)-(((2^bits_bot- 1)/2)*d);

	% Since the top DAC output is the amplitude of the cosine wave
	% and the bottom DAC output is the amplitude of the sine wave, 
	% we can consider them to be the inphase and quadrature 
	% components of the complex QAM symbol.
	i_comp(i)=d_top;
	q_comp(i)=d_bot;
    complex_symbol(i)=[i_comp(i)+j*q_comp(i)];
end
figure,subplot(2,1,1),stem(real(complex_symbol));
title('Complex encoded signal');
ylabel('Real Part');
subplot(2,1,2), stem(imag(complex_symbol));
ylabel('Imaginary Part');
xlabel('Channel/Frequency')
fprintf('Press Enter to continue')
pause
clc
clear i i_comp q-comp;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calcuate the IFFT of the encoded complex symbol.

x_mod=ifft([1 complex_symbol 1 fliplr(conj(complex_symbol))],2*N);
figure,subplot(2,1,1),stem(real(x_mod));
title('IFFT Modulated signal');
ylabel('Real Part');
subplot(2,1,2), stem(imag(x_mod));
ylabel('Imaginary Part');
xlabel('Time samples')
fprintf('Press Enter to continue')
pause
clc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Define a cyclic prefix length and add the cyclic prefix to the serailized data stream.

x=[x_mod(2*N+1-v:2*N) x_mod];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Transmission across the channel. Convolution with the channel impulse response.

figure,freqz(h);
title('Channel Frequency Resonse')
fprintf('Press Enter to continue')
pause
clc
y=conv(x,h); % received data stream.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Receiver Side 
%remove cyclic prefix

y_mod=y(v+1:2*N+v);

% Due to the cyclic prefix the convolution is translated to a circular convolution 
% and hence the encoded complex symbol with its conjugate is received after FFT demodulation 

x_recd=fft(y_mod)./fft(h,2*N);

% removing the conjugate parts
complex_recd_symbol=x_recd(2:N);figure,subplot(2,1,1),stem(real(complex_recd_symbol));
title('Signal after FFT and removal of mirrored data');
ylabel('Real Part');
subplot(2,1,2), stem(imag(complex_recd_symbol));
ylabel('Imaginary Part');
xlabel('Channel/Frequency')
fprintf('Press Enter to continue')
pause
clc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% DECODER %%%%%%%%%%%%%%%%%%%%%%%%

for i=1:N-1,
i_comp(i)=real(complex_recd_symbol(i));
q_comp(i)=imag(complex_recd_symbol(i));
%Calculate the intersymbol spacing (based on a transmit 
	% symbol energy of 1).
	d = sqrt (6/((2^bit_channel(i))-1));

	% The number of bits sent to the top and bottom DACs
	l_top = ceil(bit_channel(i)/2);
	l_bot = floor(bit_channel(i)/2);

	d_top = i_comp(i);
	d_bot = q_comp(i);

	v_top = round((d_top/d)+((2.^l_top-1)/2));
	v_bot = round((d_bot/d)+((2.^l_bot-1)/2));

    b_top = [];	
	for j=(1:l_top)
		b_top = [b_top, rem(v_top,2)];
		v_top = floor(v_top/2);
	end

	b_bot = [];	
for j=(1:l_bot)
		b_bot = [b_bot, rem(v_bot, 2)];
		v_bot = floor(v_bot/2);
	end

	data_recd{i}=[b_top, b_bot];
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% ERROR Calculations %%%%%%%%%%%%

err=(complex_recd_symbol-complex_symbol);
figure,subplot(2,1,1),stem(real(err));
title('Real part of the error signal')
%figure,
subplot(2,1,2),stem(imag(err));
title('Imaginary part of the error signal')
xlabel('Channel number')

bit_err=[data_recd{1,:}]-[data{1,:}];
 figure,stem(bit_err)
title('Bit error')
xlabel('Samples')

