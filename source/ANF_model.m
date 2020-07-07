



function ANF_model(Istim,Fs)
%% Two point neuron model function %%
% The point neurons are defined as a ordinary differential equation solved
% with a forward Eular method. The model includes exponential spiking
% initiation mechanisms as descibed in the exponential integrate-and-fire
% model.
%
%
% Suyash N. Joshi
% suyash@suyash-joshi.com
% Copenhagen, Denmark

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                              %% Parameters %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Common %%%%%
El = -0.0800;
Vt = -0.0700;
Vr = -0.0840;
vPeak = 0.024;
AbsRef = 5.0000e-04;
a1 = 0.0026;
a2 = 0.005;
b = 90e-06;
InhibitAlpha =  0.75;

%%%%% Peripheran node %%%%%
p_Cm = 856.96e-09;
p_gL = 0.0011;
p_Dt = 0.010;
p_tauw1 =400e-06;
p_tauw2 = 4500e-06;
p_RS = 0.062;
p_Threshold = 543e-6;
p_Sigma = p_RS*p_Threshold;

%%%%% Central node %%%%%
c_Cm = 1772.4e-09;
c_gL = 0.0027;
c_Dt = 0.0030;
c_tauw1 = 250e-06;
c_tauw2 = 3000e-06;
c_RS = 0.075;
c_Threshold = 731e-6;
c_Sigma = c_RS*c_Threshold;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                      %% Preprocess the stimulus %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%% Resample the stimulus if Fs is not 1e6 %%%%%%%
stim_dur = length(Istim)/Fs;
dt = 1/Fs;
if isrow(Istim)
    Istim=Istim';
end
if ~isequal(Fs,1e6)
    user_stim = Istim;
    user_Fs = Fs;
    Istim = resample(Istim,[0:(1/1e6):stim_dur-(1/1e6)],Fs);
    Fs = 1e6; dt = 1/Fs;
end
nt = length(Istim);

% Peripheral node
p_I = Istim * -1 ;
p_I(p_I<0) = InhibitAlpha * p_I(p_I<0);
p_t = 0:dt:length(p_I)/Fs;
p_v = zeros(1,length(p_t)); p_v(:) = El;  % membrane potential vector

% Central node
c_I = Istim;
c_I(c_I<0) = InhibitAlpha * c_I(c_I<0);
c_t = 0:dt:length(c_I)/Fs;
c_v = zeros(1,length(c_t)); c_v(:) = El;  % membrane potential vector


SpTimes = [];
p_sptimes=[];
c_sptimes=[];
p_Noise = p_Sigma*p_Noise;
c_Noise = c_Sigma*c_Noise;

end

function gnoise=oneonfnoise(n,NoiseAlpha,varargin)

% gnoise=oneonfnoise(n,NoiseAlpha);
% creates n samples of 1/f^NoiseAlpha Gaussian noise .
% The noise is scaled accordingly to produce coect dynamic range of the
% neuron, for any given alpha (tested between 0 - 2).

if mod(n,2)==0
    f = [1:n/2]';
    p = 2*pi*rand(n/2,1);
    yc = f.^(-NoiseAlpha/2).*exp(i.*p.*f);
    s = [0+0i; yc; conj(yc(end-1:-1:1))];
else
    f = [1:(n-1)/2]';
    p = 2*pi*rand((n-1)/2,1);
    yc = f.^(-NoiseAlpha/2).*exp(i.*p.*f);
    s = [0+0i; yc; conj(flipud(yc))];
end
x = ifft(s);
gnoise = real(x);
gnoise = gnoise/std(gnoise);

switch nargin
    case 2
        % Scale the noise for this particular neuron model
        a =       5.073; %  (4.705, 5.442)
        b =       -2.61; %  (-2.91, -2.31)
        c =      0.3265; %  (-0.03942, 0.6925)
        d =    -0.00834; %  (-0.6009, 0.5842)
        sigma = a*exp(b*NoiseAlpha) + c*exp(d*NoiseAlpha);
        gnoise = gnoise*sigma;
    case 3
        gnoise = gnoise;
return