function [thresh_dB, sigma] = get_threshold(I_stim, Fs)

Fs = 1e6; % Sampling frequency 
NoiseAlpha =0.8; 

[Level,Probability,Latency,Jitter]=Library.FindThreshold(I_stim,Fs,NoiseAlpha,0.0001e-6,@Model_SinglePulse,1000);

[mu,sigma,xtemp,ytemp]=Library.FitNeuronDynamicRange(Level',Probability);

thresh_dB = 20*log10(mu/1e-6);

figure
subplot(3,1,1)
plot(20*log10(Level/1e-6),Probability,'ko','MarkerFaceColor','Green'); 
hold on
plot(20*log10(xtemp/1e-6),ytemp,'g-')
set(gca,'xlim',[50 70])
title('Firing efficiency (FE) curve')
ylabel('p(firing)')

subplot(3,1,2)
plot(20*log10(Level/1e-6),Latency,'go-','MarkerFaceColor','Green','MarkerEdgeColor','k'); 
set(gca,'xlim',[50 70])
title('Spike latency')
ylabel('seconds')

subplot(3,1,3)
plot(20*log10(Level/1e-6),Jitter,'go-','MarkerFaceColor','Green','MarkerEdgeColor','k')
set(gca,'xlim',[50 70])
title('Spike jitter')
ylabel('seconds')
xlabel('Stimulus level (Amps)')