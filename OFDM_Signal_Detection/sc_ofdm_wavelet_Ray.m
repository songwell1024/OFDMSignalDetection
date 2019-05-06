function [VAR_FSK8,VAR_QAM16,VAR_QAM64,VAR_QPSK,VAR_OFDM]=sc_ofdm_wavelet_Ray(N,snr,para,ratio,K,itau,power,itn,fmax,fs)
%**************************************************************************
%功能：小波变换变换的特征值个小波变换的尺度因子和中值滤波器长度有关
%N:符号数
%snr:信噪比
%VAR:小波变换特征值
%**************************************************************************
scal =8;%小波变换的尺度因子
fc = 10e6;   %信号集载波频率
for i=1:length(snr)
    for m=1:10%每个信噪比做1100次蒙特卡罗试验

        %******************************************************************
        %8fsk的小波变换，求解VAR
        %******************************************************************
        data= FSK8();
        data=(data.*exp(1i*2*pi*fc/fs*(0:length(data)-1)));
        data = (MUL_RAYLEIGH(data,itau,power,itn,length(itau),length(data),1/fs,fmax,0));
        data1 = awgn(data,snr(i),'measured');%加高斯白噪声
        data1=hilbert(real(data1));%希尔波特变换
        data2 = data1/sqrt(sum(real(data1).*real(data1)+imag(data1).*imag(data1))/length(data1));%功率归一化
        coef= cwt(data2,scal,'haar');%第一次小波变换
        coef= cwt(abs(coef),scal,'haar');%第二次小波变换
        coef=medfilt1(abs(coef),30);%中值滤波
        v_qam=var(coef);%求包络方差
        VAR_fsk8(m,i)=v_qam;
        %******************************************************************
        %16qam的小波变换，求解VAR
        %******************************************************************
        data=QAM16();
        data=(data.*exp(1i*2*pi*fc/fs*(0:length(data)-1)));
        data = (MUL_RAYLEIGH(data,itau,power,itn,length(itau),length(data),1/fs,fmax,0));
        data1 = awgn(data,snr(i),'measured');
        data1=hilbert(real(data1));%希尔波特变换
        data2 = data1/sqrt(sum(real(data1).*real(data1)+imag(data1).*imag(data1))/length(data1));
        coef = cwt(data2,scal,'haar');
        coef = cwt(abs(coef),scal,'haar');
        coef=medfilt1(abs(coef),30);
        v_qam=var(coef);%求包络方差
        VAR_qam16(m,i)=v_qam;
        %******************************************************************
        %64qam的小波变换，求VAR
        %******************************************************************
        data=QAM64();
        data=(data.*exp(1i*2*pi*fc/fs*(0:length(data)-1)));
        data = (MUL_RAYLEIGH(data,itau,power,itn,length(itau),length(data),1/fs,fmax,0));
        data1 = awgn(data,snr(i),'measured');
        data1=hilbert(real(data1));%希尔波特变换
        data2 = data1/sqrt(sum(real(data1).*real(data1)+imag(data1).*imag(data1))/length(data1));
        coef = cwt(data2,scal,'haar');
        coef = cwt(abs(coef),scal,'haar');
        b=medfilt1(abs(coef),30);
        v_qam=var(b);%求包络方差
        VAR_qam64(m,i)=v_qam;
        %******************************************************************
        %qpsk的小波变换，求VAR
        %******************************************************************
        data=QPSK();
        data = (MUL_RAYLEIGH(data,itau,power,itn,length(itau),length(data),1/fs,fmax,0));
        data1 = awgn(data,snr(i),'measured'); 
        data1=hilbert(real(data1));%希尔波特变换
        data2 = data1/sqrt(sum(real(data1).*real(data1)+imag(data1).*imag(data1))/length(data1));
        coef = cwt(data2,scal,'haar');
        coef = cwt(abs(coef),scal,'haar');
        b=medfilt1(abs(coef),30);
        v_qam=var(b);%求包络方差
        VAR_qpsk(m,i)=v_qam;
        %******************************************************************
        %ofdm的小波变换，求VAR
        %******************************************************************
        y2=ofdm(N*2,para,ratio);
%         fc = 10e6;   %信号的载波频率
        data = (y2.*exp(1i*2*pi*fc/fs*(0:length(y2)-1)));
        data = (MUL_RAYLEIGH(data,itau,power,itn,length(itau),length(data),1/fs,fmax,0));
        data1 = awgn(data,snr(i),'measured'); 
        data1=hilbert(real(data1));%相应的注释与QAM信号相同
        data2 = data1/sqrt(sum(real(data1).*real(data1)+imag(data1).*imag(data1))/length(data1));
        coef = cwt(data2,scal,'haar');
        coef = cwt(abs(coef),scal,'haar');
        b=medfilt1(abs(coef),30);   %中值滤波
        v_qam=var(b);%求包络方差
        VAR_ofdm(m,i)=v_qam;
    end
end
VAR_FSK8=mean(VAR_fsk8);%求包络方差的平均值
VAR_QAM16=mean(VAR_qam16);
VAR_QAM64=mean(VAR_qam64);
VAR_QPSK=mean(VAR_qpsk);
VAR_OFDM=mean(VAR_ofdm);
%绘制不同信号包络方差随信噪比的变化
if K==1
    figure
    plot(snr,VAR_FSK8,'k-o');
    hold on;
    plot(snr,VAR_QAM16,'b-s');
    hold on;
    plot(snr,VAR_QAM64,'g-*');
    hold on;
    plot(snr,VAR_QPSK,'r-v');
    hold on;
    plot(snr,VAR_OFDM,'r-o');
    hold on;
    xlabel('SNR(dB)');
    ylabel('VAR');
    title('瑞利衰落信道下小波变换特征值')
    legend('8fsk','16qam','64qam','qpsk','ofdm');
    grid on;
end