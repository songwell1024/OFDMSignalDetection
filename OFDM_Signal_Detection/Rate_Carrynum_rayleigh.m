function  [Carry_num_rate ]= Rate_Carrynum_rayleigh(yc, snr,N ,para,itau,power,fmax,fs,itn)
%求子载波数目的估计的准确性
%子载波数目理论值128
carrynum_ideal = para;
meantimes = 100;
Carry_num_rate=zeros(1,length(snr));
for j=1:length(snr)
    for i=1:meantimes
        [carry_num(j,i)] = carrier_number_rayleigh(yc,N,snr(j),0,itau,power,fmax,fs,itn);
        if(carry_num(j,i)==carrynum_ideal)
           Carry_num_rate(j)=Carry_num_rate(j)+1;
        end
    end
end
Carry_num_rate=Carry_num_rate/meantimes;


