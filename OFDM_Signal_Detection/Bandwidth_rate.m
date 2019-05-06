function [ B_rate_welch,B_rate_ar ] = Bandwidth_rate(sig1_chnl,fc,fs, snr)
%**************************************************************************
%功能：求不同信道比下带宽估计的性能
%sig1_chnl:输入信号
%fc:载波频率
%fs:信道采样频率
%snr:信噪比
%B_rate_welch:Welch算法下带宽估计准确性
%B_rate_ar：AR模型下带宽估计的准确性
%**************************************************************************
 
 B_ideal = 8e6;  %OFDM信号带宽的理论值
 numb = 10; %蒙特卡洛仿真的次数
 LL = length(snr);
 B_welch = zeros(1,LL);
 B_ar = zeros(1,LL);
 for i=1:LL
     for j=1:numb
         [b_welch(i,j),b_ar(i,j)]=PSD_OFDM(sig1_chnl,fc,fs,snr(i),0);
     end
     B_welch(i)=sum(b_welch(i,:))/numb;
     B_ar(i)=sum(b_ar(i,:))/numb;
     B_rate_welch(i)=1-abs((B_welch(i)-B_ideal))/B_ideal;
     B_rate_ar(i)=1-abs((B_ar(i)-B_ideal))/B_ideal;
 end
 
figure
plot(snr,B_rate_welch,'b-o');
hold on
plot(snr,B_rate_ar,'k-*');
legend('welch','AR');
grid on;
xlabel('snr/db')
ylabel('percentage/%');
title('带宽估计性能');
