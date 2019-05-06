function [rate_ofdm]=OFDM_rate(snr,N,para,ratio)
%**************************************************************************
%功能：信号识别率
%awgn信道中OFDM信号呈现高斯性，单载波信号没有高斯性，利用高斯信号的高阶累积量为零来区分单载波与OFDM信号
% 理论值： c42_ofdm=0；c42_qpsk=-1；c42_qam16=-0.6800；c42_qam64=-0.6190
% 由仿真可见只有在信噪比大于20dB时求得的m42才与理论值相符
% snr：信噪比
%N:符号数
%**************************************************************************

MM = 0.0295;  %设置识别信号的门限
num = 10;     %100次蒙特卡洛仿真
ofdm1 = zeros(1,length(snr));
rate_ofdm = zeros(1,length(snr));

for i = 1:num
    [c42_ofdm,c42_qpsk,c42_qam16,c42_qam64,c42_fsk8] = cumulant(snr,N,para,ratio,0);
  
    for j = 1:length(snr)
          if ((abs(c42_ofdm(j))<MM&&(abs(c42_qpsk(j))>MM)&&(abs(c42_qam16(j))>MM...
                &&(abs(c42_qam64(j))>MM)&&(abs(c42_fsk8(j))>MM))))
            ofdm1(j) = ofdm1(j)+1;
          end
    end
end

for j =  1:length(snr)
   rate_ofdm(j) = ofdm1(j)/num;
end
figure
plot(snr,rate_ofdm,'k-x');
axis([snr(1) snr(end) 0.95 1.1]);
xlabel('snr/db');
ylabel('percentage/%')
title('128个子载波数OFDM信号识别正确率（高阶累量）');

% %****************************************************
% %单载波信号间的识别
% %****************************************************
% Single = zeros(3,length(snr));
% rate_single = zeros(3,length(snr));
% for i = 1:num
%     for j=1:length(snr)
%       if ((abs(c40_qpsk(j))>0.9))
%         Single(1,j )= Single(1,j)+1;
%       end
%       if (0.65<(abs(c40_qam16(j))<0.8))
%         Single(2,j) = Single(2,j)+1;
%       end
%       if (0.1<(abs(c40_fsk8(j))<0.65))
%         Single(3,j) = Single(3,j)+1;
%       end
%     end
% end
% 
% for z = 1:3
%     for j = 1:length(snr)
%        rate_single(z,j) = Single(z,j)/num;
%     end
% end
% figure;
% plot(snr,rate_single(1,:),'k-*');
% hold on
% plot(snr,rate_single(2,:),'b-s');
% hold on
% plot(snr,rate_single(3,:),'r-o');
% xlabel('snr/db');
% ylabel('percentage/%');
% legend('rate_qpsk','rate_16qam','rate_8fsk');
% axis([snr(1) snr(end) 0.9 1.1]);
% title('单载波信号间识别正确率');