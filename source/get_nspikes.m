function n_spikes_average =...
    get_nspikes(input_stimulus, n_average)

%%%%%%%%%%%% Model params %%%%%%%%%%%%
Fs = 1e6;
NoiseAlpha = 0.8;

n_spikes = zeros(n_average, 1);

for idx = 1:n_average
    % make memebrane noise waveforms
    p_noise = Library.oneonfnoise(length(input_stimulus),NoiseAlpha);
    c_noise = Library.oneonfnoise(length(input_stimulus),NoiseAlpha);
    
    % Run the model
    [n_spikes(idx),~,p_sptimes,c_sptimes, ~, ~] = ...
        Model_PulseTrain(input_stimulus,p_noise,c_noise,Fs);
    n_spikes_c(idx) = numel(c_sptimes);
    n_spikes_p(idx) = numel(p_sptimes);
end

n_spikes_average = mean(n_spikes);
n_spikes_c_average = mean(n_spikes_c);
n_spikes_p_average = mean(n_spikes_p);