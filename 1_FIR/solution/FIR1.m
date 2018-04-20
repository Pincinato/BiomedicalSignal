close all;
clear all;
load ecg_lfn.dat
load ecg_like_lfn.dat
load ecg_lfn_synthBW.dat
complete_signal=ecg_lfn;
fs=1000;
v_time=[1:length(complete_signal)]/fs;
test_signal=ecg_like_lfn(:,2);
wanted_signal=ecg_like_lfn(:,3);
%% P1
polo= 0;% 
num= [1 -1]; %based on the -1 coeficnet
den= [1 -polo];
H=tf(num,den,1/fs,'variable','z^-1')
figure (1);
subplot(2,2,1);
pzmap(H);%zplane
grid on;
% ploting filer response
[magnitude,ph]=freqz(num,den,10001,fs);
subplot(2,2,2);
semilogx(20*log10(abs(magnitude)));
title("Magnitude");
ylabel("DB");
%applying the filter
y=filter(num,den,complete_signal);
subplot(2,2,3)
plot(v_time,complete_signal);
title("Original signal")
xlabel("time in sec");
ylabel("Amplitude");
subplot(2,2,4)
plot(v_time,y);
title("Filtered signal")
xlabel("time in sec");
ylabel("Amplitude");
% conclusion, As the filter is of order 1, having a a polo in zero, it
% means that all low-freqeuncies will be attenuated, maintent only the high-frequencies. Acting as a butterworth.
%The results show us when hte peak occurs but doent not give more
%information about the wave form.
%% Prob 2
num=[1 0 -1];
den=1;
H=tf(num,den,1/fs,'variable','z^-1')
figure (2);
subplot(2,2,1);
pzmap(H);%zplane
grid on;
[magnitude,ph]=freqz(num,den,10001,fs);
subplot(2,2,2);
semilogx(20*log10(abs(magnitude)));
title("Magnitude");
ylabel("DB");
%applying the filter
y=filter(num,den,complete_signal);
subplot(2,2,3)
plot(v_time,complete_signal);
title("Original signal")
xlabel("time in sec");
ylabel("Amplitude");
subplot(2,2,4)
plot(v_time,y);
title("Filtered signal")
xlabel("time in sec");
ylabel("Amplitude");
%conclusion, all low- frequencies are atenuatated, and in this time the
%highest -frequencies in the signal are also atenuated. It means that this
%filter acts as a bandpass filter, it is still not that good but can be
%already usefull.
%% Prob 3
%filter of order 3728
figure (3)
load ('Num_filter_pb3.mat')
Num_filter(1)=0;
Num_filter(length(Num_filter))=0;
den=1;
subplot(3,2,1)
plot(v_time,complete_signal);
title('Original ECG signal');
xlabel("time is sec");
ylabel("Amplitude");
subplot(3,2,2)
y_prob3=filter(Num_filter,den,complete_signal);
plot(v_time,y_prob3);
title('Filtered ECG signal');
xlabel("time is sec");
ylabel("Amplitude");
subplot(3,2,3)
plot(1:length(wanted_signal),test_signal);
title('Test signal');
xlabel("samples");
ylabel("Amplitude");
subplot(3,2,5)
plot(1:length(wanted_signal),wanted_signal)
title('wanted signal');
xlabel("samples");
ylabel("Amplitude");
subplot(3,2,4)
plot(1:length(wanted_signal),filter(Num_filter,den,test_signal));
title("Filtered signal")
xlabel("samples");
ylabel("Amplitude");
subplot(3,2,6)
errors_prob3=circshift(filter(Num_filter,den,test_signal),-(length(Num_filter)-1)/2)-wanted_signal;
errors_prob3=errors_prob3((length(Num_filter)-1)/2:length(errors_prob3)-(length(Num_filter)-1)/2); % removing the transiant error
plot(1:length(errors_prob3),errors_prob3);
title("Error")
ylabel("Amplitude");
max_error_prob3=max(abs(errors_prob3))
%Due to the huge order of the filter, only specificies low frequencies are attenuated.
%Part of the signal was setted to zero due to the behaviour of the FIR filter (window size).
%% Prob 4
figure (4)
den=1;
load ('Num_filter_pb4.mat') 
Num_filter_pb4(1)=0;
Num_filter_pb4(length(Num_filter_pb4))=0;
subplot(3,2,1)
plot(v_time,complete_signal);
subplot(3,2,2)
y_prob4=filter(Num_filter_pb4,den,complete_signal);
plot(v_time,y_prob4)
subplot(3,2,3)
plot(1:length(wanted_signal),test_signal);
subplot(3,2,5)
plot(1:length(wanted_signal),wanted_signal)
title('wanted signal');
subplot(3,2,4)
plot(1:length(wanted_signal),filter(Num_filter_pb4,den,test_signal));
subplot(3,2,6)
errors_prob4=circshift(filter(Num_filter_pb4,den,test_signal),-(length(Num_filter_pb4)-1)/2)-wanted_signal;
%errors=errors(1:length(errors)-(length(Num_filter_pb4)-1)/2);
errors_prob4=errors_prob4((length(Num_filter_pb4)-1)/2:length(errors_prob4)-(length(Num_filter_pb4)-1)/2); % removing the transiant error
plot(1:length(errors_prob4),errors_prob4);
%comparing error
max_error_prob4=max(abs(errors_prob4))
% Obs: We can decrease the order of the filter and by doing so we reduce
% the computation. However, the reduction of the order (which reduce also
% the number of the polos) make the filter poor, and with more ripple in
% the passing band. 
% Regarding the z-plane, it is noticed that the number of polos increases
% to reduce the ripple by adding more polos in the unitarie circle (r=1).
% The polos are added in the way that only the wnated frequencies stay
% without polos. It is the reason that high order filter has less ripple in
% the passing band. As the equiripple was chose the polos are equidistante.
% Each polo "force" the function to new zero at that point. 
% Concerning the filter dely, it is necessary wait untill the filter has
% enough samples to print out a truste value, normaly it starts after the
% order of the filter / 2. The oder of the filter is also the delya
% insered. This is valid only for FIR filter. 
% When we see the result applied in the synthetic signal it is possible to
% that some small triangule apper. It is because of the first and last coef
% of the filter that can be see by the fdatool when a impulse is applied.
%% Prob 5
decimation_factor=8;
Fs_prob5=fs/decimation_factor;
y_prob5_DV=decimate(test_signal,decimation_factor);
print_debug=0;
if(print_debug == 1)
    figure(5)
    subplot(6,1,1); 
    plot(1:length(y_prob5_DV),y_prob5_DV);hold on;
    plot(1:length(test_signal),test_signal); hold off;
    subplot(6,1,2);
    y_prob5_filtered=filter(1,1,y_prob5_DV);
    y_prob5_interp=interp(y_prob5_filtered,decimation_factor); 
    plot(1:length(y_prob5_interp),y_prob5_interp,'r');  hold on;
    plot(1:length(test_signal),test_signal,'b'); hold off;
end 
% 1- it was observed that the process of decimation and interpolation make the
% signal 7 samples big than expected, probabily due to fact that the length
% of the test signal cannot be divide by 8 using natural number. So the
% last sample is may lost in this process. Concerning thte delay, it is not
% insert any delay in the process.
if (print_debug==0)
    figure(5)
    den=1;
    load ('Num_filter_pb5.mat') 
    Num_filter_pb5(1)=0;
    Num_filter_pb5(length(Num_filter_pb5))=0;
    subplot(3,2,1);
    delay=(length(Num_filter_pb5)/2)*decimation_factor; % delay must be multiplied by the decimator factor in oder to adpat to the interpolation.
    test_signal_delayed_pb5=circshift(test_signal,delay); %inserting delay
    test_signal_delayed_pb5(1:delay)=0;
    plot(1:length(test_signal_delayed_pb5),test_signal_delayed_pb5);
    title('Signal delayed')
    y_prob5_filtered=filter(Num_filter_pb5,den,y_prob5_DV);
    y_prob5_interp=interp(y_prob5_filtered,decimation_factor); 
    subplot(3,2,2); 
    plot(1:length(y_prob5_interp),y_prob5_interp);
    title('base line wander');
    y_prob5_interp = y_prob5_interp(1:(length(y_prob5_interp)-7));
    y_prob5 = test_signal_delayed_pb5 - y_prob5_interp;
    subplot(3,2,4);
    plot(1:length(y_prob5),y_prob5);
    title('filtered signal');
    subplot(3,2,3)
    plot(1:length(wanted_signal),wanted_signal);
    title('wanted signal');
    errors_prob5=(circshift(y_prob5,-(delay))-wanted_signal);
    errors_prob5=errors_prob5(1+delay:length(errors_prob5)-delay);
    subplot(3,2,5)
    plot(1:length(errors_prob5),errors_prob5);
    title('Error');
    subplot(3,2,6);
    %doing the same with ECG signal
    y_prob5_ecg=decimate(complete_signal,decimation_factor);
    y_prob5_ecg=filter(Num_filter_pb5,den,y_prob5_ecg);
    y_prob5_ecg=interp(y_prob5_ecg,decimation_factor); 
    y_prob5_ecg = y_prob5_ecg(1:(length(y_prob5_ecg)-1));
    a=circshift(complete_signal,delay);
    a(1:delay)=0;
    y_prob5_ecg =a  - y_prob5_ecg;
    plot(1:length(y_prob5_ecg),y_prob5_ecg);
    title('filtered ECG signal');
    %
    max_error_prob5=max(abs(errors_prob5))
end
% apply a filter FIR using sample rate alteration allow us to use a filter 
% of a smaller order and have similiar results. It happens because the order 
% of the filter is also multiplied by the decimation facotr when the 
% interpolation process is applied 
% As expected this filter of order 444 (444x8= 3552) has a maximum error in btw
% the filter from pb 3 (order 3782) and the filter from prob 4 (order 2000).
figure(52)
subplot(3,1,1);
y_prob6=decimator_pincinato(test_signal,decimation_factor);
plot(1:length(y_prob6),y_prob6,'b');hold on;
plot(1:length(y_prob5_DV),y_prob5_DV,'r');hold off;
legend('Using my functions','Using decimate,interp');
y_prob6=filter(Num_filter_pb5,den,y_prob6);
y_prob6=interpolation_pincinato(y_prob6,decimation_factor,length(test_signal)/decimation_factor);
subplot(3,1,2);
plot(1:length(y_prob6),y_prob6,'b');hold on;
plot(1:length(y_prob5_interp),y_prob5_interp,'r'); hold off;
legend('Using my functions','Using decimate,interp');
y_prob6= test_signal_delayed_pb5-y_prob6;
subplot(3,1,3);
plot(1:length(y_prob6),y_prob6,'b');hold on;
plot(1:length(y_prob5),y_prob5,'r');hold off;
legend('Using my functions','Using decimate,interp');
%% Prob 6
clear_Ex1_2_3_4_5 = 0;
if (clear_Ex1_2_3_4_5==1)
    clear all;
    close all;
end
load ecg2x60.dat ;
figure(61)
fs=200;
fi=60;
ws=2*pi*fi/fs;
num= [1 -2*cos(ws) 1]; %based on the -1 coeficnet
H=tf(num,1,1/fs,'variable','z^-1')
subplot(3,2,1);
pzmap(H);% the poles are expected to be in w= (fo/fs*2pi)  (60/200)*2pi= w=0.6pi
grid on;
% ploting filer response
[magnitude,ph]=freqz(num,1,10001,fs);
subplot(3,2,3);
semilogx(20*log10(abs(magnitude)));
title("Magnitude");
ylabel("DB");
subplot(3,2,4);
plot(ph);
title("phase");
ylabel("angle");
y_1=filter(num,1,ecg2x60);
subplot(3,2,5);
plot(1:length(ecg2x60),ecg2x60);
title("Original ECG Signal");
ylabel("Amplitude");
xlabel("samples");
subplot(3,2,6);
plot(1:length(y_1),y_1);
title("Filtered Signal");
ylabel("Amplitude");
xlabel("samples");
%As the nulling filter presented a gain of about 8DB in the pass band , the signal is amplified 
%and thus we can observe that the amplitude of the filtered signal is
%higher than the original signal.
% the filter has a narrow band that is blocked and a linear phase which allow to maintain the
% original form of the signal.
load ecg_like_50Hz.dat;
signal_ecg_like_50Hz=ecg_like_50Hz(:,2);
wanted_signal=ecg_like_50Hz(:,3);
figure(62)
fs=1/(ecg_like_50Hz(2,1)-ecg_like_50Hz(1,1));
fi=50;
ws=2*pi*fi/fs;
num= [1 -2*cos(ws) 1]; 
H=tf(num,1,1/fs,'variable','z^-1') 
subplot(3,2,1);
pzmap(H);%the poles are expected to be in w= (fo/fs*2pi)  (50/1000)*2pi=(0.05*) w=0.1pi
grid on;
% ploting filer response
[magnitude,ph]=freqz(num,1,10001,fs);
subplot(3,2,3);
semilogx(20*log10(abs(magnitude)));
title("Magnitude");
ylabel("DB");
subplot(3,2,5);
plot(ph);
title("phase");
ylabel("angle");
y_2=filter(num,1,signal_ecg_like_50Hz);
subplot(3,2,2);
plot(1:length(signal_ecg_like_50Hz),signal_ecg_like_50Hz);
title("Original ECG Signal");
ylabel("Amplitude");
xlabel("samples");
subplot(3,2,4);
plot(1:length(y_2),y_2);
title("Filtered Signal");
ylabel("Amplitude");
xlabel("samples");
signal_ecg_like_50Hz_gaussian=randn(length(signal_ecg_like_50Hz),1)+signal_ecg_like_50Hz;
y_2_gaussian=filter(num,1,signal_ecg_like_50Hz_gaussian);
subplot(3,2,6);
plot(1:length(y_2_gaussian),y_2_gaussian);
title("Filtered Signal with Gaussian noise");
ylabel("Amplitude");
xlabel("samples");
%To enhance the filter we could add the polos in the high frenquencies, or
%even apply a low pass filter , given taht our interesed signal is in a low
%frequencie.
%% Prob 7

