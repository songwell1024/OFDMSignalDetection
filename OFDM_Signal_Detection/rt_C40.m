function c40=rt_C40(rt)%获得4阶累积量C42
%crt=conj(rt);%rt的共轭
m40=mean(rt.^4);
m20=mean(rt.^2);
%m21=mean(rt.*crt);
c40=abs(m40-3*m20.^2);