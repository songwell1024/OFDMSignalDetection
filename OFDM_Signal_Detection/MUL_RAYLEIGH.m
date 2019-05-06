function [xout]=MUL_RAYLEIGH(x,itau,dlvl,itn,n1,nsamp,tstp,fd,flat)
%****************** variables *************************
% x  input Ich baseband data     
% yout   output Qch baseband data
% itau   : Delay time for each multipath fading
% dlvl   : Attenuation level for each multipath fading
% itn    : Fading counter for each multipath fading
% n1     : Number of summation for direct and delayed waves 
% nsamp   : Total number od symbols
% tstp   : Mininum time resolution
% fd   : Maxmum doppler frequency
% flat     flat fading or not 
% (1->flat (only amplitude is fluctuated),0->nomal(phase and amplitude are fluctutated)   
%******************************************************
n0 = 25;      % n0     : Number of waves in order to generate each multipath fading
xout = zeros(1,nsamp);
total_attn = sum(10 .^(  dlvl ./ 20.0));

for k = 1 : n1 
    
	atts = 10.^ (dlvl(k)/20.0);

	if dlvl(k) >= 40.0 
	       atts = 0.0;
	end

	[xtmp] = delay ( x, nsamp , itau(k));
	[xtmp3] = siglfade (xtmp,nsamp,tstp,fd,n0,itn(k),flat);% single fade
	
  xout = xout + atts .* xtmp3 ./ sqrt(total_attn);

end
% ************************end of file***********************************
function [xout] = delay(x,nsamp,idel )
% Gives delay to input signal
%****************** variables *************************
% x      input Ich data     
% xout   output Qch data
% nsamp   Number of samples to be simulated 
% idel   Number of samples to be delayed
%******************************************************

xout=zeros(1,nsamp);
if idel ~= 0 
  xout(1:idel) = zeros(1,idel);
end

xout(idel+1:nsamp) = x(1:nsamp-idel);

% ************************end of file***********************************

function [xout]=siglfade(x,nsamp,tstp,fd,no,counter,flat)
% Generate Rayleigh fading
% %****************** variables *************************
% x  : input Ich data     
% xout   : output Qch data
% nsamp  : Number of samples to be simulated       
% tstp   : Minimum time resolution                    
% fd     : maximum doppler frequency               
% no     : number of waves in order to generate fading   
% counter  : fading counter                          
% flat     : flat fading or not 
% (1->flat (only amplitude is fluctuated),0->nomal(phase and amplitude are fluctutated)    
%******************************************************

if fd ~= 0.0  
    ac0 = sqrt(1.0 ./ (2.0.*(no + 1)));   % power normalized constant(ich)
    as0 = sqrt(1.0 ./ (2.0.*no));         % power normalized constant(qch)
    ic0 = counter;                        % fading counter
 
    pai = 3.14159265;   
    wm = 2.0.*pai.*fd;
    n = 4.*no + 2;
    ts = tstp;
    wmts = wm.*ts;
    paino = pai./no;                        

    xc=zeros(1,nsamp);
    xs=zeros(1,nsamp);
    ic=[1:nsamp]+ic0;

  for nn = 1: no
	  cwn = cos( cos(2.0.*pai.*nn./n).*ic.*wmts );
	  xc = xc + cos(paino.*nn).*cwn;
	  xs = xs + sin(paino.*nn).*cwn;
  end

  cwmt = sqrt(2.0).*cos(ic.*wmts);
  xc = (2.0.*xc + cwmt).*ac0;
  xs = 2.0.*xs.*as0;

  ramp=sqrt(xc.^2+xs.^2);   

  if flat ==1
    xout = sqrt(xc.^2+xs.^2).*x;    % output signal
  else
    xout = x .*(xc+1i*xs);
  end

else  
  xout = x;
end

% ************************end of file***********************************
