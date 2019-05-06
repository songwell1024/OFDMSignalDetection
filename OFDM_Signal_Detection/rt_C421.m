function c42=rt_C421(rt)
M=length(rt);
data=rt;
a=real(data);
b=imag(data);

a2=a.^2;  b2=b.^2; a4=a.^4; b4=b.^4;
a6=a.^6;  b6=b.^6; a8=a.^8; b8=b.^8;
P=(sum(a2+b2))/M;

m20=(sum(a2-b2))/M;
m21=(sum(a2+b2))/M;

m40=(sum(a4+b4-6*(a2.*b2)))/M;
m41=(sum(a4-b4))/M;
m42=(sum(a4+b4+2*(a2.*b2)))/M;

M20=m20/P;
M21=m21/P;

M40=m40/P^2;
M41=m41/P^2;
M42=m42/P^2;

Cum20=M20;
Cum21=M21;

Cum40=(m40-3*m20^2)/P^2;
Cum41=(m41-3*m20*m21)/P^2;
Cum42=(m42-m20^2-2*m21^2)/P^2;
c42=Cum42;


