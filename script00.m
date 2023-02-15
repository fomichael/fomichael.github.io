

clear; clc
addpath(genpath('./Wavelab850'));
load('./Intra_N2');

signal = N2_REGION(1).Epoq20(1,:);
fs = N2_REGION(1).fs;

% Padding: %%%%%%%%%%%%%
signal = Zpadd(signal);%
Nt = length(signal);   %
temps = (0:Nt-1)/fs;   %
%%%%%%%%%%%%%%%%%%%%%%%%


a = cwt(signal,fs);

figure('position',[10 200 800 200]); plot(temps,signal);
xlim([temps(1) temps(end)])

 
% Parametres de la transformee:
wavelet.time = temps;
wavelet.vanish_moments = 2;
wavelet.Njtot = fix(log2(Nt));
wavelet.Noff = min(wavelet.Njtot-1,3);
wavelet.scales_j = 1:wavelet.Njtot-wavelet.Noff;
wavelet.pc_power = 100;
wavelet.filtre = MakeONFilter('Daubechies',wavelet.vanish_moments+2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
WData = fwt_po(signal,wavelet.Noff,wavelet.filtre); %
[~,~,WW] = display_time_scale_boxes(WData,wavelet); %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% 1) Reconstruction: (sans erreur)
signal_rec = iwt_po(WData,wavelet.Noff,wavelet.filtre);
figure('position',[10 200 800 420]); 
subplot(2,1,1); plot(temps,signal);
    xlim([temps(1) temps(end)])
subplot(2,1,2); plot(temps,signal_rec,'-k');
    xlim([temps(1) temps(end)])


% 2) Reconstruction: (avec erreur)
signal_rec = iwt_po(WW,wavelet.Noff,wavelet.filtre);
figure('position',[10 200 800 420]); 
subplot(2,1,1); plot(temps,signal);
    xlim([temps(1) temps(end)])
subplot(2,1,2); plot(temps,signal_rec,'-k');
    xlim([temps(1) temps(end)])    
    

% 3) Reconstruction: (residu)
signal_rec = iwt_po(WData-WW,wavelet.Noff,wavelet.filtre);
figure('position',[10 200 800 420]); 
subplot(2,1,1); plot(temps,signal);
    xlim([temps(1) temps(end)])
subplot(2,1,2); plot(temps,signal_rec,'-k');
    xlim([temps(1) temps(end)])   
    
    