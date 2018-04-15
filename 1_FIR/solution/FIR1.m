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
%applying the filter
y=filter(num,den,complete_signal);
subplot(2,2,3)
plot(v_time,complete_signal);
subplot(2,2,4)
plot(v_time,y);
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
%applying the filter
y=filter(num,den,complete_signal);
subplot(2,2,3)
plot(v_time,complete_signal);
subplot(2,2,4)
plot(v_time,y);
%conclusion, all low- frequencies are atenuatated, and in this time the
%highest -frequencies in the signal are also atenuated. It means that this
%filter acts as a bandpass filter, it is still not that good but can be
%already usefull.
%% Prob 3
%filter of order 3728
figure (3)
load ('Num_filter_pb3.mat')
den=1;
subplot(3,2,1)
plot(v_time,complete_signal);
subplot(3,2,2)
y_prob3=filter(Num_filter,den,complete_signal);
plot(v_time,y_prob3);
subplot(3,2,3)
plot(1:length(wanted_signal),test_signal);
subplot(3,2,5)
plot(1:length(wanted_signal),wanted_signal)
subplot(3,2,4)
plot(1:length(wanted_signal),filter(Num_filter,den,test_signal));
subplot(3,2,6)
errors_prob3=circshift(filter(Num_filter,den,test_signal),-(length(Num_filter)-1)/2)-wanted_signal;
errors_prob3=errors_prob3((length(Num_filter)-1)/2:length(errors_prob3)-(length(Num_filter)-1)/2); % removing the transiant error
plot(1:length(errors_prob3),errors_prob3);
max_error_prob3=max(abs(errors_prob3))
%Due to the huge order of the filter, only specificies low frequencies are attenuated.
%Part of the signal was setted to zero due to the behaviour of the FIR filter (window size).
%% Prob 4
figure (4)
den=1;
load ('Num_filter_pb4.mat') 
subplot(3,2,1)
plot(v_time,complete_signal);
subplot(3,2,2)
y_prob4=filter(Num_filter_pb4,den,complete_signal);
plot(v_time,y_prob4)
subplot(3,2,3)
plot(1:length(wanted_signal),test_signal);
subplot(3,2,5)
plot(1:length(wanted_signal),wanted_signal)
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
    y_prob5=decimate(complete_signal,decimation_factor);
    y_prob5=filter(Num_filter_pb5,den,y_prob5);
    y_prob5=interp(y_prob5,decimation_factor); 
    y_prob5 = y_prob5(1:(length(y_prob5)-1));
    a=circshift(complete_signal,delay);
    a(1:delay)=0;
    y_prob5 =a  - y_prob5;
    plot(1:length(y_prob5),y_prob5);
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
%% Prob 6
clear_Ex1_2_3_4_5 = 1;
if (clear_Ex1_2_3_4_5==1)
    clear all;
end
