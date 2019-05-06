function c42=rt_C42(rt)%获得4阶累积量C42
crt=conj(rt);   %rt的共轭
P=mean(rt.*crt); %信号的平均功率

m20=mean(rt.^2);
m21=mean(rt.*crt);  %信号的平均功率亦可用var()库函数来求，var()求方差
m42=mean(rt.^2.*crt.^2);

M20=m20/P;
M21=m21/P;
M42=m42/P^2;
 
c42=M42-(abs(M20)).^2-2*(M21.^2);
% c42=m42-(abs(m20)).^2-2*(m21.^2);