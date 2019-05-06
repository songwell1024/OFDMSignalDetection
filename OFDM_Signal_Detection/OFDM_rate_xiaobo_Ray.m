function [rate_ofdm_R]=OFDM_rate_xiaobo_Ray(snr,N,para,ratio,itau,power,itn,fmax,fs)
%功能：小波变换的正确识别率
Me_R=0.0172;  %设置识别信号的门限
num=2;     %100次蒙特卡洛仿真
ofdm_R=zeros(1,length(snr));
rate_ofdm_R=zeros(1,length(snr));

for i=1:num
    [VAR_FSK8_R,VAR_QAM16_R,VAR_QAM64_R,VAR_QPSK_R,VAR_OFDM_R] = sc_ofdm_wavelet_Ray(N,snr,para,ratio,0,itau,power,itn,fmax,fs);
    
    for j=1:length(snr)
          if ((VAR_OFDM_R(j)>Me_R)&&(VAR_FSK8_R(j)<Me_R)&&(VAR_QAM16_R(j)<Me_R)&&(VAR_QAM64_R(j)<Me_R)...
                  &&(VAR_QPSK_R(j)<Me_R))
            ofdm_R(j)=ofdm_R(j)+1;
          end
    end
end

for j=1:length(snr)
   rate_ofdm_R(j)=ofdm_R(j)/num;
end
figure;
plot(snr,rate_ofdm_R,'k-x');
axis([snr(1) snr(end) 0.95 1.1]);
xlabel('snr/db');
ylabel('percentage/%');
title('128个子载波数OFDM信号识别正确率(小波变换瑞利衰落信道)');