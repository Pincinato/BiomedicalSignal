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
plot(complete_signal);
%P1
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
%%Prob 2
num=[1 0 -1];
den=1;
H=tf(num,den,1/fs,'variable','z^-1')
figure (4);
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
figure (7)
load ('Num_filter_pb3.mat')
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
errors=circshift(filter(Num_filter,den,test_signal),-(length(Num_filter)-1)/2)-wanted_signal;
errors=errors((length(Num_filter)-1)/2:length(errors)-(length(Num_filter)-1)/2); % removing the transiant error
plot(1:length(errors),errors);
max_error=max(abs(errors))
%Due to the huge order of the filter, only specificies low frequencies are attenuated.
%Part of the signal was setted to zero due to the behaviour of the FIR filter (window size).
%% Prob 4
figure (8)
load ('Num_filter_pb4.mat') % Gaus filter with order 100.
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
errors2=circshift(filter(Num_filter_pb4,den,test_signal),-(length(Num_filter_pb4)-1)/2)-wanted_signal;
%errors=errors(1:length(errors)-(length(Num_filter_pb4)-1)/2);
errors2=errors2((length(Num_filter_pb4)-1)/2:length(errors2)-(length(Num_filter_pb4)-1)/2); % removing the transiant error
plot(1:length(errors2),errors2);
%comparing error
max_error2=max(abs(errors2))
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
