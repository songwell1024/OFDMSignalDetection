 function [Tu,Ts] = auto_xcorr(data, P, xcorr_len, N,t,K)
 %*************************************************************************
 %功能：计算发送数据或接收数据自相关
 %data：输入数据
 %P：循环周期
 %N：OFDM符号数
 %xcorr_len：自相关长度,以OFDM符号为单位
 %K=1时绘制图形  
 %Rx自相关函数
 %*************************************************************************
 kk = xcorr_len+2 ;
 xcorr_len = xcorr_len*P;
 Rx = zeros(xcorr_len, 2*P);
 data1=[zeros(1,P),data,zeros(1,P)];
 for i = 1 : N-kk+1
    for tao = 1-P : P
        for n = 1 : xcorr_len
            Rx(n,tao+P) = Rx(n,tao+P) + data1(P*(i-1)+n+P)*conj(data1(P*(i-1)+n+tao+P));
        end
    end
 end

 Rx = Rx./(N-kk+1);
 R_tao =zeros(1,length(Rx(1,:)));
 for i=1:length(Rx(:,1))
    R_tao= R_tao+Rx(i,:);
 end

 R_tao= abs(R_tao)/length(Rx(:,1));
 
 if K==1
     figure
     stem ((1-P)*t :t:( P)*t ,R_tao);   %P*t是将由采样点数表示的有效数据长度变为由时间表示的
     xlabel('delay/s');
     ylabel('amplitute');
     title('短波可变延时自相关')
     figure
     stem ((1-P) :( P) ,R_tao);   %P*t是将由采样点数表示的有效数据长度变为由时间表示的
     xlabel('delay/s');
     ylabel('amplitute');
     title('基带可变延时自相关')
 end
 %********************************************
 %取有效数据长度
 %********************************************
 abc=sort( R_tao(1,1:end/2));    %按升序排序
 Z=length(abc);
 [as1 ,Tu1] =find( R_tao(1,1:end/2)==abc(1,Z-1));%取峰值高度为第二高的峰值对应坐标
 Tu=(length(R_tao)/2-Tu1)*t;       %为信号的有效数据长度

 %********************************************
 %取数据的总长度
 %********************************************
 
 sigma0 = 6;   %观测数据的长度因子
 L_fft=sigma0*P;     %观测数据的长度，即fft的长度
 RR = zeros(xcorr_len, L_fft);
 data111=[zeros(1,P),data,zeros(1,P)];   %将观测的数据长度延长，避免求自相关时超出长度
 for i = 1 : N-4 
    for k=1:L_fft
            RR(i,k) =data111(P*(i-1)+k)*conj(data111(P*(i-1)+k+length(R_tao)/2-Tu1));
    end
 end

 RRR_tao =zeros(1,length(RR(1,:)));
 for i=1:length(RR(:,1))
    RRR_tao= RRR_tao+RR(i,:);
 end

 RRR_tao= abs(RRR_tao)/length(RR(:,1));
 RRR_T=ifft(RRR_tao);
 RRR_fft= abs(RRR_T(1,1:20*sigma0));
 if K==1
     figure
     LL=t:t:20*sigma0*t;
     stem(LL,RRR_fft);
     title('短波固定延时自相关的IFFT')
     figure
     stem(RRR_fft);
     title('基带固定延时自相关的IFFT')
 end

a=sort(RRR_fft);    %按升序排序
Z=length(a);
[a1 ,T1] =find(RRR_fft==a(1,Z));%取峰值高度为第一高的峰值对应坐标
[a2 ,T2] =find(RRR_fft==a(1,Z-1));%取峰值高度为第二高的峰值对应坐标
[a3 ,T3] =find(RRR_fft==a(1,Z-2));%取峰值高度为第三高的峰值对应坐标
Ts1 = abs(T2-T1);
Ts2 = abs(T3-T2);
Ts3 = abs(T3-T1);
Tss = [Ts1 Ts2 Ts3];
TT = sort(Tss);  %按升序排序取间隔最小值
Ts= L_fft/TT(1)*t;       %为信号的有效数据长度