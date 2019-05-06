function [B_welch,B_ar] =PSD_OFDM(sig1_chnl,fc,fs,snr,k)
%**************************************************************************
%功能：求功率谱
%sig1_chnl：输入信号
%fc：载频
%fs：采样频率
%snr：信噪比
%k=1的时候绘制PSD
%B_welch：Welch算法求解带宽值
%B_ar：AR模型求解带宽值
%**************************************************************************
sig2_chnl = real(sig1_chnl.*exp(1j*2*pi*fc/fs*(0:length(sig1_chnl)-1)));
sig2_chnl = awgn(sig2_chnl, snr,'measured');
%q = Burg(sig1_chnl,'AIC');
%P=mean(abs(sig1_chnl));           %求y的标准差，用库函数来求，作用与mean（abs（））相同。标准差是方差的开方
%sig1_chnl=sig1_chnl/P;            %P1和P显然不同，归一化是除以标准差？还是除以模的均值,还是除以平方和的开方
% [Pxx1,f]=pburg(sig2_chnl,q,4096*2,fs);  %用AR模型法进行功率谱估计
% [Pxx1,f]=pburg(sig2_chnl,100,4096*2,fs);  %用AR模型法进行功率谱估计
[Pxx1, f, p] = Burg(sig2_chnl,fs, 'AIC');   %用AR模型法进行功率谱估计
[Pxx2,f1]=pwelch(sig2_chnl,hanning(100),55,4096*2,fs);  %用welch算法进行功率谱估计

Frc=0:fs/(length(sig2_chnl)):fs/2-1;
OfdmSymComput = 20 * log10(abs(fft(sig2_chnl)));
OfdmSymPSDy = fftshift(OfdmSymComput) - max(OfdmSymComput);

Pxx22 = Pxx2;
Pxx22=Pxx22/min(Pxx22);%找出谱密度中的最小值，作归一化处理 
Pxx22=10*log10(Pxx22);%产生谱密度的dB数据
Pxx22=Pxx22-max(Pxx22);
if k==1
	figure
	plot(f,Pxx1);
	grid on;
	xlabel('频率f'); 
	ylabel('PSD/db');
	title('AR模型法估的功率谱密度曲线'); 

	figure
	plot(f1,Pxx22);
	grid on;
	xlabel('频率f');
	ylabel('PSD/db');
	title('Welch算法估计功率谱密度曲线'); 

	figure
	%plot(Frc,OfdmSymPSDy(1,1:end/2));
	plot(Frc,OfdmSymPSDy(1,1:end/2));
	xlabel('频率f');
	ylabel('PSD/db');
	title('OFDM信号频谱'); 
end
%****************************
%求信号的带宽
%****************************

L1=ceil(length(Pxx22)/2);
P1=Pxx22(1:L1,1);
P2=Pxx22(L1:end,1);
[as1, as11]=Proximate(-3,P1);  %取最接近-3db的信号的f的值
band1=f1(as1);
[as2, as22]=Proximate(-3,P2);
band2=f1(as2+L1-1);
B_welch =abs(band1-band2);

L2=ceil(length(Pxx1)/2);
P3=Pxx1(1:L2,1);
P4=Pxx1(L2:end,1);
if snr>4
    [as3, as33]=Proximate(-5,P3);  %取最接近-3db的信号的f的值
    band3=f(as3);
    [as4, as44]=Proximate(-5,P4);
    band4=f(as4+L2-1);
    B_ar =abs(band4-band3);
elseif (snr>0&&snr<=4)
    [as3, as33]=Proximate(-4,P3);  %取最接近-3db的信号的f的值
    band3=f(as3);
    [as4, as44]=Proximate(-4,P4);
    band4=f(as4+L2-1);
    B_ar =abs(band4-band3);
else
    [as3, as33]=Proximate(-3,P3);  %取最接近-3db的信号的f的值
    band3=f(as3);
    [as4, as44]=Proximate(-3,P4);
    band4=f(as4+L2-1);
    B_ar =abs(band4-band3);
end
end