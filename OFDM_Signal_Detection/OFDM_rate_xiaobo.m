function [rate_ofdm1]=OFDM_rate_xiaobo(snr,N,para,ratio)
%功能：小波变换的正确识别率
Me=0.0172;  %设置识别信号的门限
num=2;     %100次蒙特卡洛仿真
ofdm2=zeros(1,length(snr));
rate_ofdm1=zeros(1,length(snr));

for i=1:num
    [VAR_FSK8,VAR_QAM16,VAR_QAM64,VAR_QPSK,VAR_OFDM] = sc_ofdm_wavelet(N,snr,para,ratio,0);
    
    for j=1:length(snr)
          if ((VAR_OFDM(j)>Me)&&(VAR_FSK8(j)<Me)&&(VAR_QAM16(j)<Me)&&(VAR_QAM64(j)<Me)...
                  &&(VAR_QPSK(j)<Me))
            ofdm2(j)=ofdm2(j)+1;
          end
    end
end

for j=1:length(snr)
   rate_ofdm1(j)=ofdm2(j)/num;
end
figure;
plot(snr,rate_ofdm1,'k-x');
axis([snr(1) snr(end) 0.95 1.1]);
xlabel('snr/db');
ylabel('percentage/%');
title('128个子载波数OFDM信号识别正确率(小波变换高白信道)');