function [c42_ofdm,c42_qpsk,c42_qam16,c42_qam64,c42_fsk8] = cumulant(snr,N,para,ratio,K)
%**************************************************************************
%功能：高阶累量识别信号
%awgn信道中OFDM信号呈现高斯性，单载波信号没有高斯性，利用高斯信号的高阶累积量为零来区分单载波与OFDM信号
% 理论值： c42_ofdm=0；c42_qpsk=-1；c42_qam16=-0.6800；c42_qam64=-0.6190
% 由仿真可见只有在信噪比大于10dB时求得的m42才与理论值相符
%snr：信噪比
%N：符号个数
%para:子载波数目
%ratio：循环前缀比例
%**************************************************************************

meantimes = 20;     %10次取平均
for i=1:length(snr)
    for j=1:meantimes
        st_ofdm=ofdm(N,para,ratio);
        rt_ofdm = awgn(st_ofdm,snr(i));
        c42_ofdm(i,j)=rt_C42(rt_ofdm);    %c42 是特征参数
        
        st_qpsk=QPSK();
        rt_qpsk= awgn(st_qpsk,snr(i),'measured');%加高斯白噪声
        c42_qpsk(i,j)=rt_C42( rt_qpsk); 
%         c40_qpsk(i,j)=rt_C40( rt_qpsk); 
        
        st_qam16=QAM16();
        rt_qam16= awgn(st_qam16,snr(i),'measured');%加高斯白噪声
        c42_qam16(i,j)=rt_C42(rt_qam16);
%         c40_qam16(i,j)=rt_C40(rt_qam16); 
        
        st_qam64=QAM64();
        rt_qam64 = awgn(st_qam64,snr(i),'measured');%加高斯白噪声
        c42_qam64(i,j)=rt_C42(rt_qam64);
        
        st_fsk8=FSK8();
        rt_fsk8 = awgn(st_fsk8,snr(i),'measured');%加高斯白噪声
        c42_fsk8(i,j)=rt_C42(rt_fsk8); 
%         c40_fsk8(i,j)=rt_C40(rt_fsk8); 
    end
end
c42_ofdm=mean(c42_ofdm.');
c42_qpsk=mean(c42_qpsk.');
c42_qam16=mean(c42_qam16.');
c42_qam64=mean(c42_qam64.');
c42_fsk8=mean(c42_fsk8.');

% c40_qpsk=mean(c40_qpsk.');
% c40_fsk8=mean(c40_fsk8.');
% c40_qam16=mean(c40_qam16.');

if K==1
  figure
  plot(snr,c42_ofdm,'r-o');
  hold on
  plot(snr,c42_qpsk,'k-x');
  hold on
  plot(snr,c42_qam16,'b-o');
  hold on
  plot(snr,c42_qam64,'k-o');
  hold on
  plot(snr,c42_fsk8,'r-v');
  hold on;

  legend('ofdm:0','qpsk:-1','16qam:-0.68','64qam:-0.619','8fsk:-1');
  xlabel('snr(dB)')
  ylabel('C42')
  title('信号的高阶累量C42')

%   figure
%   plot(snr,c40_qpsk,'k-x');
%   hold on
%   plot(snr,c40_fsk8,'r-o');
%   hold on;
%   plot(snr,c40_qam16,'b-*');
%   hold on;
%   legend('qpsk:-x','8fsk:-o','qam16');
%   xlabel('snr(dB)')
%   ylabel('C40')
%   title('信号的高阶累量C40')
end
