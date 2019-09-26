
%% Author: Muhammed Shifas PV, shifaspv@csd.oc.gr
% Implimentation of the paper: Faller, Christof, and Christophe Tournery. "Robust acoustic echo control using a simple echo path model." 
%2006 IEEE International Conference on Acoustics Speech and Signal Processing Proceedings. Vol. 5. IEEE, 2006.
%%
close all;
clear all;
clc;
delete('clean.wav','enhanced.wav')
%% impuls response generation

fs=8000;
mic=[2 1.5 .5];
n=8;
r1=0.6;
rm=[5 4 3];
src=[5 2 1];% audiowrite('clean.wav',v,fs)

h=rir(fs, mic, n, r1, rm, src);
L=length(h)
%input
[x, Fs] = audioread('S_01_01.wav'); %Far-end signal
[v, Fs] = audioread('S_01_02.wav'); %Near-end signal
v=[zeros(8000,1);v(8000:end)];
EchoSignal=filter(h,1,x); %Echo signal
P_near=bandpower(v);
P_echo=bandpower(EchoSignal);
while (P_echo>=0.448*P_near)
    x=0.99*x;
    EchoSignal=filter(h,1,x);
    P_echo=bandpower(EchoSignal);
end
M=length(v);
N=length(EchoSignal);
v=[zeros(N-M,1);v];
disp('echo in the microphone')
sound(EchoSignal)
pause(2)
disp('near end speeech')
sound(v)
pause(2)
disp('combined input')
y=EchoSignal+v; %(Microphone Signal)
sound(y)

% DELAY ESTIMATION
delay=finddelay(x,y);
x1=[zeros(ceil(delay),1);x];
DTbegin=1;


px=10^-30;
pzd=10^-30;
pd=10^-30;
pz=10^-30;
pze=10^-30;
pe=10^-30;
ps=10^-30;

alpha=0.1;
T1=0.8;  %for DTD
T2=0.6;
%% AES based on soft decision
t=10e-3;       %frame length
ni=floor(Fs*t);
% nf=floor(length(y)/ns);
ov=2;
ns=ov*ni;
c=0.998;
r=0.998;
flag=0;
beta1=4.8;
X1=enframe(x1,hamming(ns),ni);
Y1=enframe(y,hamming(ns),ni);
V1=enframe(v,hamming(ns),ni);
[a,b]=size(Y1);
for i=1:a
Xd=fft(X1(i,:)',ns);
Y=fft(Y1(i,:)',ns);
V=fft(V1(i,:)',ns);
   if flag==0
    if i==1
       C=(1-c)*abs(Y.*conj(Xd))+1e-10;
       R=(1-r)*abs(Xd.*conj(Xd))+1e-10; 
    else 
  
       C=c*C+(1-c)*abs(Y.*conj(Xd));
       R=r*R+(1-r)*abs(Xd.*conj(Xd));
    
    end
   H1=C./R;
   end
Y_hat=(H1).*abs(Xd);
G=((max((abs(Y).^2-beta1*Y_hat.^2),0)./(abs(Y).^2)).^0.5); 
S=G.*(Y);
% abs_Y_hat(:,i)=Y_hat;
% abs_Y(:,i)=abs(Y);
SV=G.*(V);
%% DTD

pzd=(1-alpha)*pzd+alpha*abs(Y'*(Y_hat));
pd=(1-alpha)*pd+alpha*(abs(Y_hat'*Y_hat));
pz=(1-alpha)*pz+alpha*(abs(Y'*Y));
pze=(1-alpha)*pze+alpha*abs(Y'*(S));
pe=(1-alpha)*pe+alpha*(abs(S'*S));
l=i;
rzd=pzd/(sqrt(pz*pd));
rze=pze/(sqrt(pz*pe));
m1(l)=(rzd);
m2(l)=(rze);

if (l>DTbegin)
if abs(m1(l))<T1
        if abs(m2(l))>T2
        
            flag=1;
            f1(l)=1;
           
        else
        
        flag=0;
        f1(l)=0;
        end
else
        flag=0;
        f1(l)=0;
end

end
recon(i,:)=ifft(S,ns);
reconv(i,:)=ifft(SV,ns);
end
%% overlapadd
[c,d]=size(recon);
[y2,p]=overlapadd(recon,hamming(ns),ni)
[v2,p]=overlapadd(reconv,hamming(ns),ni)
y3=y2;
 pause(3)
 
 disp('enhanced')
sound(real(y3))
subplot(211)
spectrogram(y,hamming(ns),ni,ns,fs,'yaxis')
title ('microphone input (echo+near end speech) ')
subplot(212)
spectrogram(real(y3),hamming(ns),ni,ns,fs,'yaxis')
title('echo cancelled signal (Frequency domain: Feller et.al)')
%  load feller_modulation
% subplot(212)
% %  spectrogram(real(ss1),hamming(ns),ni,ns,fs,'yaxis')
% title('echo cancelled signal (proposed MDAES method)')
% % ERLE and plots
m=length(y3);
n=length(y);
ul=min(m,n);
for i=1:ul
powerY(i) = abs(y(i))^2; %Power of Microphone 
powerE(i)=abs(y3(i))^2; %power of Error 
end
L=2000;
for i=5:N-2*L 
%Echo Return Loss Enhancement
ERLE1(i)=10*log10(mean(powerY(i:i+L))/mean(powerE(i:i+L)));
end
save('feller')

