function [ B_rate_welch,B_rate_ar ] = Bandwidth_rate_rayleigh(sig1_chnl,fc,fs, snr,itau,power,fmax,itn)
 %求不同信道比下带宽估计的性能
 %求不同信道比下
 B_ideal = 8e6;  %OFDM信号带宽的理论值
 numb = 1; %蒙特卡洛仿真的次数
 LL = length(snr);
 for i = 1:LL
     for j = 1:numb
         [b_welch(i,j),b_ar(i,j)]=PSD_OFDM_rayleigh(sig1_chnl,fc,fs,snr(i),0,itau,power,fmax,itn);
     end
     B_welch(i) = sum(b_welch(i,:))/numb;
     B_ar(i) = sum(b_ar(i,:))/numb;
     B_rate_welch(i) = 1-abs((B_welch(i)-B_ideal))/B_ideal;
     B_rate_ar(i) = 1-abs((B_ar(i)-B_ideal))/B_ideal;
 end

