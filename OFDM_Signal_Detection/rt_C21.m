function c21=rt_C21(rt)%获得累积量C21
crt=conj(rt);%rt的共轭
c21=mean(rt.*crt);%求方差