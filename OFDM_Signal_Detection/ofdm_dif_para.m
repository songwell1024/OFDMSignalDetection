function [V_ofdm128,V_ofdm256,V_ofdm512] = ofdm_dif_para(snr,N,ratio,K)
meantimes=20;     %100次取平均蒙特卡洛仿真次数
para1=[128,256,512];
for i=1:length(snr)
     SNR=10^(snr(i)/10);         %信号功率除以噪声功率
     sigma=1/sqrt(2*SNR);        %对信号功率归一化之后求得的噪声的功率开方（噪声的幅度），
    for j=1:meantimes
        st_ofdm128=ofdm(N,para1(1),ratio);
        ofdm_noise1=sigma*(randn(1,length(st_ofdm128))+sqrt(-1)*randn(1,length(st_ofdm128)));
        rt_ofdm128=st_ofdm128+ofdm_noise1;
        c42_ofdm128(i,j)=rt_C42(rt_ofdm128);    %c42 是特征参数
        
        st_ofdm256=ofdm(N,para1(2),ratio);
        ofdm_noise1=sigma*(randn(1,length(st_ofdm256))+sqrt(-1)*randn(1,length(st_ofdm256)));
        rt_ofdm256=st_ofdm256+ofdm_noise1;
        c42_ofdm256(i,j)=rt_C42(rt_ofdm256);    %c42 是特征参数
       
        st_ofdm512=ofdm(N,para1(3),ratio);
        ofdm_noise1=sigma*(randn(1,length(st_ofdm512))+sqrt(-1)*randn(1,length(st_ofdm512)));
        rt_ofdm512=st_ofdm512+ofdm_noise1;
        c42_ofdm512(i,j)=rt_C42(rt_ofdm512);    %c42 是特征参数
    end
end
c42_ofdm128=mean(c42_ofdm128.');
c42_ofdm256=mean(c42_ofdm256.');
c42_ofdm512=mean(c42_ofdm512.');
if K==1
    figure
    plot(snr,abs(c42_ofdm128),'r-o');
    hold on
    plot(snr,abs(c42_ofdm256),'g-*');
    hold on
    plot(snr,abs(c42_ofdm512),'b-s');
    hold on
    plot([snr(1) snr(end)],[-0.0295 -0.0295],'k');
    hold on
    legend('c42_ofdm128','c42_ofdm256','c42_ofdm512','门限值');
    axis([snr(1) snr(end) -0.10 0.10]);
    title('不同子载波数目对C42值的影响')
    
end
V_ofdm128 = sum(c42_ofdm128.^2);   %相对误差平方和
V_ofdm256 = sum(c42_ofdm256.^2);    %相对误差平方和
V_ofdm512 = sum(c42_ofdm512.^2);    %相对误差平方和