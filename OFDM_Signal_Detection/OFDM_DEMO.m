%**************************************************************************
%OFDM信号识别与相关参数的估计
%created by Songzhiyong
%2017.03.01
%**************************************************************************
% clc;
% close all;
% clear all;
% %**************************************************************************
% % 计算信号高阶累量实现信号类间识别
% % c40_、c42_表示四阶累量，表示信噪比
% %**************************************************************************
% K = 1;           %当K的值为1的时候绘制图形
% N = 20;          %设置一个祯结构中OFDM信号的个数
% para = 128;%设置并行传输的子载波个数
% ratio = 1/4 ; %循环前缀比例
% S = 12.5e3  ;   %符号速率12.5Kbps
% snr1 = -5:5:25;   %高白信道中信噪比，演示与理论值相符所设
% snr = -4:2:10;   %高白信道中信噪比
% 
% fc = 10e6;   %信号的载波频率
% fs = 40e6;   % 采样频率
% 
 itau = floor([0,1e-8,2e-8,5e-8,2e-7,5e-7].*fs);  %多径延时
 power = [0,-1.0,-7.0,-10.0,-12.0,-17.0];  %多径信道下每径功率
 fmax = 20 ;   %多普勒频移
 itn = [10000,20000,30000,40000,50000,60000];    %瑞利信道下计数子
% 
% %**************************************************************************
% [c42_ofdm,c42_qpsk,c42_qam16,c42_qam64,c42_fsk8] = cumulant(snr1,N,para,ratio,K);
% [VAR_FSK8,VAR_QAM16,VAR_QAM64,VAR_QPSK,VAR_OFDM] = sc_ofdm_wavelet(N,snr1,para,ratio,K);
% [VAR_FSK8_Ray,VAR_QAM16_Ray,VAR_QAM64_Ray,VAR_QPSK_Ray,VAR_OFDM_Ray] = sc_ofdm_wavelet_Ray(N,snr1,para,ratio,K,itau,power,itn,fmax,fs);
% %**************************************************************************
% %高阶累量的方式不同信噪比下信号的识别率
% %rate_ofdm表示信号的正确识别率
% %**************************************************************************
% [rate_ofdm] = OFDM_rate(snr,N,para,ratio);
% [rate_ofdm1] = OFDM_rate_xiaobo(snr,N,para,ratio);
% [rate_ofdm_Ray] = OFDM_rate_xiaobo_Ray(snr,N,para,ratio,itau,power,itn,fmax,fs);
% %**************************************************************************
% %OFDM不同子载波数目对高阶累量求解值的波动情况的影响
% %c42_ofdm64,c42_ofdm128,c42_ofdm256分别表示
% %子载波数目为128,256,512时的四阶累量
% %**************************************************************************
% [V_ofdm128,V_ofdm256,V_ofdm512] = ofdm_dif_para(snr,N,ratio,K);
%  
% %**************************************************************************
% %ofdm载波频率参数估计
% %ofdm循环谱估计ofdm信号载波频率
% %**************************************************************************
% trst_rate = 5e5;  % 信号发射速率,即码片速率
% M = 16; % 平滑点数 
% sig = ofdm(N,para,ratio);
% Ns = length(sig);       % 循环谱检测采样长度，必须小于等于信号序列长度
%  
% %**************************************************************************
% %过采样后OFDM信号才有循环平稳性
% %**************************************************************************
% s_n = ceil(fs/trst_rate); % 检测采样率近似为OFDM信号速率的整数倍 
% sign = sig(ones(s_n,1),:); % 码元复制
% sign = reshape(sign, 1, s_n*length(sign));
% data = sign.*exp(1i*2*pi*fc/fs*(0:length(sign)-1));
% %高白信道下循环谱估计载频
% data_awgn = awgn(data,25,'measured');
% [f_awgn] = cyclic_spectrum(real(data_awgn), Ns, fs, M,K);  % 循环谱求频率f
% 
% %瑞利信道下循环谱估计
% %data_rayleigh = RayFade(itau,power,fmax,fs,data,25);
% data_rayleigh = (MUL_RAYLEIGH(data,itau,power,itn,length(itau),length(data),1/fs,fmax,0));
% data_rayleigh = data_rayleigh/std(data_rayleigh);
% data_rayleigh = awgn(data_rayleigh,25,'measured');
% [f_rayleigh] = cyclic_spectrum(real(data_rayleigh), Ns, fs, M,K);  % 循环谱求频率f
%**************************************************************************
%功率谱
%**************************************************************************
[sig_ofdm] = PSD_generate(N);
%[band_welch,band_ar] = PSD_OFDM(sig_ofdm,fc,fs,20,K);  %求解功率谱(25db)
%[B_rate_welch,B_rate_ar ] = Bandwidth_rate( sig_ofdm,fc,fs,snr);   %求信号的带宽估计的性能

%瑞利信道下带宽估计性能
[B_rate_welch_rayleigh,B_rate_ar_rayleigh ] = Bandwidth_rate_rayleigh(sig_ofdm,fc,fs,snr,itau,power,fmax,itn);   %求信号的带宽估计的性能
[B_welch,B_ar] =PSD_OFDM_rayleigh(sig_ofdm,fc,fs,snr,1,itau,power,fmax,itn);
figure
plot(snr,B_rate_ar_rayleigh,'r-o');
hold on
plot(snr,B_rate_ar,'k-x');
xlabel('snr/db');
ylabel('percentage/%');
legend('Rayleigh','Awgn');
title('不同信道下带宽估计性能');

%**************************************************************************
%高白信道下循环自相关特性求解有效数据长度和总长度以及循环前缀长度
%**************************************************************************
% sig_a = sig.*exp(1i*2*pi*fc/fs*(0:length(sig)-1));  %调制到载频 
% [Tu_128,Ts_128,Tg_128 ] = effectivelength(sig_a,fs,20,N,K);
% [ Tu_rate_128,Ts_rate_128,Tg_rate_128] = Length_rate(sig_a,fs,snr,N,1 );
% 
% %**************************************************************************
% %瑞利信道下估计有效数据长度和总长度以及循环前缀长度
% %**************************************************************************
% [Tu_128_rayleigh,Ts_128_rayleigh,Tg_128_rayleigh ] = effectivelength_rayleigh(sig_a,fs,10,N,1,itau,power,fmax,itn);
% [Tu_rate_128_rayleigh,Ts_rate_128_rayleigh,Tg_rate_128_rayleigh] = Length_rate_rayleigh(sig_a,fs,snr,N,0,itau,power,fmax,itn );
% figure
% plot(snr,Tu_rate_128_rayleigh,'r-o');
% hold on
% plot(snr,Tu_rate_128,'k-x');
% xlabel('snr/db');
% ylabel('percentage/%');
% legend('Rayleigh','Awgn');
% title('不同信道对有效数据长度估计的影响')
% figure
% plot(snr,Ts_rate_128_rayleigh,'r-o');
% hold on
% plot(snr,Ts_rate_128,'k-x');
% legend('Rayleigh','Awgn');
% xlabel('snr/db');
% ylabel('percentage/%');
% title('不同信道对数据总长度估计的影响')
% figure
% plot(snr,Tg_rate_128_rayleigh,'r-o');
% hold on
% plot(snr,Tg_rate_128,'k-x');
% legend('Rayleigh','Awgn');
% xlabel('snr/db');
% ylabel('percentage/%');
% title('不同信道对循环前缀长度估计的影响')
% 
% %**************************************************************************
% %高白信道下载波数目对信号参数估计性能的影响
% %**************************************************************************
% % sig_256 = ofdm(N,256,ratio);
% % sig256 = sig_256.*exp(1i*2*pi*fc/fs*(0:length(sig_256)-1));  %调制到载频 
% % [ Tu_rate_256,Ts_rate_256,Tg_rate_256] = Length_rate_difpara(sig256,fs,snr,N,0 );
% % figure
% % plot(snr,Tu_rate_256,'r-o');
% % hold on
% % plot(snr,Tu_rate_128,'k-x');
% % xlabel('snr/db');
% % ylabel('percentage/%');
% % legend('256个子载波','128个子载波');
% % title('子载波数目对有效数据长度估计的影响')
% % figure
% % plot(snr,Ts_rate_256,'r-o');
% % hold on
% % plot(snr,Ts_rate_128,'k-x');
% % legend('256个子载波','128个子载波');
% % xlabel('snr/db');
% % ylabel('percentage/%');
% % title('子载波数目对数据总长度估计的影响')
% % figure
% % plot(snr,Tg_rate_256,'r-o');
% % hold on
% % plot(snr,Tg_rate_128,'k-x');
% % legend('256个子载波','128个子载波');
% % xlabel('snr/db');
% % ylabel('percentage/%');
% % title('子载波数目对循环前缀长度估计的影响')
% 
% %**************************************************************************
% %高白信道下符号数目对信号参数估计性能的影响
% %**************************************************************************
% sig_10 = ofdm(10,para,ratio);
% sig10 = sig_10.*exp(1i*2*pi*fc/fs*(0:length(sig_10)-1));  %调制到载频 
% [ Tu_rate_10,Ts_rate_10,Tg_rate_10] = Length_rate(sig10,fs,snr,10,0 );
% sig_30 = ofdm(30,para,ratio);
% sig30 = sig_30.*exp(1i*2*pi*fc/fs*(0:length(sig_30)-1));  %调制到载频 
% [Tu_rate_30,Ts_rate_30,Tg_rate_30] = Length_rate(sig30,fs,snr,30,0 );
% figure
% plot(snr,Tu_rate_10,'r-o');
% hold on
% plot(snr,Tu_rate_128,'k-x');
% hold on
% plot(snr,Tu_rate_30,'b-*');
% legend('10个符号','20个符号','30个符号');
% xlabel('snr/db');
% ylabel('percentage/%');
% title('符号数目对有效数据长度估计的影响')
% figure
% plot(snr,Ts_rate_10,'r-o');
% hold on
% plot(snr,Ts_rate_128,'k-x');
% hold on
% plot(snr,Ts_rate_30,'b-*');
% legend('10个符号','20个符号','30个符号');
% xlabel('snr/db');
% ylabel('percentage/%');
% title('符号数目对数据总长度估计的影响')
% figure
% plot(snr,Tg_rate_10,'r-o');
% hold on
% plot(snr,Tg_rate_128,'k-x');
% hold on
% plot(snr,Tg_rate_30,'b-*');
% legend('10个符号','20个符号','30个符号');
% xlabel('snr/db');
% ylabel('percentage/%');
% title('符号数目对循环前缀长度估计的影响')
% 
% %**************************************************************************
% %高白信道下循环前缀比例对信号参数估计性能的影响
% %**************************************************************************
% sig_ratio = ofdm(N,para,1/8);
% sig_r = sig_ratio.*exp(1i*2*pi*fc/fs*(0:length(sig_ratio)-1));  %调制到载频 
% [ Tu_rate_ratio,Ts_rate_ratio,Tg_rate_ratio] = Length_rate_difratio(sig_r,fs,snr,N,0 );
% 
% sig_ratio1 = ofdm(N,para,3/16);
% sig_r1= sig_ratio1.*exp(1i*2*pi*fc/fs*(0:length(sig_ratio1)-1));  %调制到载频 
% [Tu_rate_ratio1,Ts_rate_ratio1,Tg_rate_ratio1] = Length_rate_difratio(sig_r1,fs,snr,N,0 );
% figure
% plot(snr,Tu_rate_ratio,'r-o');
% hold on
% plot(snr,Tu_rate_ratio1,'b-*');
% hold on
% plot(snr,Tu_rate_128,'k-x');
% legend('ratio=1/8','ratio=3/16','ratio=1/4');
% xlabel('snr/db');
% ylabel('percentage/%');
% title('循环前缀比例对有效数据长度估计的影响')
% figure
% plot(snr,Ts_rate_ratio,'r-o');
% hold on
% plot(snr,Ts_rate_ratio1,'b-*');
% hold on
% plot(snr,Ts_rate_128,'k-x');
% legend('ratio=1/8','ratio=3/16','ratio=1/4');
% xlabel('snr/db');
% ylabel('percentage/%');
% title('循环前缀比例对数据总长度估计的影响')
% figure
% plot(snr,Tg_rate_ratio,'r-o');
% hold on
% plot(snr,Tg_rate_ratio1,'b-*');
% hold on
% plot(snr,Tg_rate_128,'k-x');
% legend('ratio=1/8','ratio=3/16','ratio=1/4');
% xlabel('snr/db');
% ylabel('percentage/%');
% title('循环前缀比例对循环前缀长度估计的影响')
% 
% %**************************************************************************
% %高白信道下OFDM子载波数目估计
% %**************************************************************************
% [carry_num] = carrier_number(sig_a ,N,25,K);
% [Carry_num_rate_128 ] = Rate_Carrynum(sig_a,snr,para,N,K);
% 
% %**************************************************************************
% %高白信道下每帧的符号数对子载波数目估计的影响
% %**************************************************************************
% [Carry_num_rate_10 ] = Rate_Carrynum(sig_10,snr,para,10,0);
% %[Carry_num_rate_30 ] = Rate_Carrynum(sig_30,snr,para,30,0);
% Carry_num_rate_30 = Tu_rate_30 ;
% figure
% plot(snr,Carry_num_rate_10,'r-o');
% hold on
% plot(snr,Carry_num_rate_128,'k-x');
% hold on
% plot(snr,Carry_num_rate_30,'b-*');
% xlabel('snr/db');
% ylabel('percentage/%');
% legend('10个符号','20个符号','30个符号');
% title('符号数目对子载波数目估计的影响')
% 
% %**************************************************************************
% %高白信道下循环前缀的比例对子载波数目估计的影响
% %**************************************************************************
% [Carry_num_rate_ratio ] = Rate_Carrynum(sig_ratio,snr,para,N,0);
% [Carry_num_rate_ratio1 ] = Rate_Carrynum(sig_ratio1,snr,para,N,0);
% figure
% plot(snr,Carry_num_rate_ratio,'r-o');
% hold on
% plot(snr,Carry_num_rate_ratio1,'b-*');
% hold on
% plot(snr,Carry_num_rate_128,'k-x');
% xlabel('snr/db');
% ylabel('percentage/%');
% legend('ratio=1/8','ratio=3/16','ratio=1/4');
% title('循环前缀比例对子载波数目估计的影响')
% 
% %**************************************************************************
% %高白信道下子载波个数对子载波数目估计的影响
% %**************************************************************************
% %[Carry_num_rate_256 ] = Rate_Carrynum(sig_256,snr,256,N,0);
% % Carry_num_rate_256 = Tu_rate_256;
% % figure
% % plot(snr,Carry_num_rate_256,'r-o');
% % hold on
% % plot(snr,Carry_num_rate_128,'k-x');
% % legend('256个子载波','128个子载波');
% % xlabel('snr/db');
% % ylabel('percentage/%');
% % title('子载波数目对子载波数目估计的影响')
% 
% %**************************************************************************
% %瑞利信道下OFDM子载波数目估计性能
% %**************************************************************************
% [Carry_num_rate_rayleigh ]= Rate_Carrynum_rayleigh(sig_a, snr,N ,para,itau,power,fmax,fs,itn);
% figure
% plot(snr,Carry_num_rate_rayleigh,'r-o');
% hold on
% plot(snr,Carry_num_rate_128,'k-x');
% legend('Rayleigh','Awgn');
% xlabel('snr/db');
% ylabel('percentage/%');
% title('不同信道下子载波数目估计性能');
% 
% %**************************************************************************
% %利用带宽求子载波数目
% %**************************************************************************
% [BB, Carrynum_B] =solve_carrynum_rate(sig_ofdm,fc,fs,snr,N );    %利用带宽的方式求子载波数目
