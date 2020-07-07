%% Parameters

fs = 1e6; % don't change!
phase_dur_us = 25;
levels_dB_uA = 40:0.5:70;
n_averages = 10;
stim_dur_s = 0.4;
rate_pps = 80;
ipg_vector_us = [8 40];
levels_A = 1e-6*10.^(levels_dB_uA/20);


%% Create single pulses

BA = zeros(length(ipg_vector_us), 2*phase_dur_us+ipg_vector_us(end)+2);
BC = zeros(length(ipg_vector_us), 2*phase_dur_us+ipg_vector_us(end)+2);
for idx_ipg = length(ipg_vector_us):-1:1
    BA(idx_ipg, :) = [0, 1*ones(1,phase_dur_us), ...
        zeros(1, ipg_vector_us(idx_ipg)), -1*ones(1,phase_dur_us), zeros(1, ipg_vector_us(end)-ipg_vector_us(idx_ipg)), 0];
    BC(idx_ipg, :) = -1*BA(idx_ipg, :);
end

%% Create pulse trains

for idx_ipg = length(ipg_vector_us):-1:1
    BA_pulse_train(idx_ipg, :) = ...
        Experiment.stim_PulseTrain(BA(idx_ipg, :),rate_pps,100,0,stim_dur_s,fs);
    BC_pulse_train(idx_ipg, :) = ...
        Experiment.stim_PulseTrain(BC(idx_ipg, :),rate_pps,100,0,stim_dur_s,fs);    
end

%If you want to investigate polarity effect with quadraphasic pulses,
%uncomment these lines, and uncommonet lines 52 and 53

%BA_quad = [zeros(length(BA)+8,1)' BA_pulse_train];
%BC_quad = [BC_pulse_train zeros(length(BC)+8,1)'];
%quadCAAC = BC_quad + BA_quad;
%quadACCA = -1.*quadCAAC;



%% Get the number of spikes at a given level

n_spikes_matrix_BA = zeros(length(ipg_vector_us), length(levels_dB_uA));
n_spikes_matrix_BC = zeros(length(ipg_vector_us), length(levels_dB_uA));

for idx_ipg = 1:length(ipg_vector_us)

     tmp_BA = BA_pulse_train(idx_ipg,:);
     tmp_BC = BC_pulse_train(idx_ipg,:); 
    
    %tmp_BA = quadCAAC(idx_ipg,:);
    %tmp_BC = quadACCA(idx_ipg,:);

    tmp_n_spikes_matrix_BA = zeros(1, length(levels_dB_uA));
    tmp_n_spikes_matrix_BC = zeros(1, length(levels_dB_uA));    
    parfor idx = 1:length(levels_dB_uA)

        tmp_n_spikes_matrix_BA(idx) = ...
            get_nspikes(levels_A(idx)*tmp_BA, n_averages);
        tmp_n_spikes_matrix_BC(idx) = ...
            get_nspikes(levels_A(idx)*tmp_BC, n_averages);        
    end
    n_spikes_matrix_BA(idx_ipg, :) = tmp_n_spikes_matrix_BA;
    n_spikes_matrix_BC(idx_ipg, :) = tmp_n_spikes_matrix_BC;    
    fprintf('new ipg done!\n')
end

%keyboard

%%

figure
plot(levels_dB_uA, n_spikes_matrix_BA)
legend(num2str(ipg_vector_us'))

%% Create norm distribution of thresholds


    r1 = normrnd(0,1,[1,500]);
    r2 = normrnd(0,1,[1,1000]);

clear n_spikes_population_1 n_spikes_population_2
n_levels = length(levels_dB_uA);
for idx_ipg = length(ipg_vector_us):-1:1
    for idx_neuron = length(r1):-1:1
        shift = r1(idx_neuron);
        shift_samples = round(r1(idx_neuron)/unique(diff(levels_dB_uA)));
        if shift_samples > 0
            n_spikes_population_1(idx_ipg, :, idx_neuron) = ...
                [n_spikes_matrix_BC(idx_ipg, shift_samples+1:end) ...
                ones(1, shift_samples)*n_spikes_matrix_BC(idx_ipg, end)];
        elseif shift_samples <= 0
            n_spikes_population_1(idx_ipg, :, idx_neuron) = ...
                [ones(1, abs(shift_samples))*n_spikes_matrix_BC(idx_ipg, 1) ...
                n_spikes_matrix_BC(idx_ipg, 1:(n_levels-abs(shift_samples)))];
        end
    end
    for idx_neuron = length(r2):-1:1
        shift = r2(idx_neuron);
        shift_samples = round(r2(idx_neuron)/unique(diff(levels_dB_uA)));
        if shift_samples > 0
            n_spikes_population_2(idx_ipg, :, idx_neuron) = ...
                [n_spikes_matrix_BC(idx_ipg, shift_samples+1:end) ...
                ones(1, shift_samples)*n_spikes_matrix_BC(idx_ipg, end)];
        elseif shift_samples <= 0
            n_spikes_population_2(idx_ipg, :, idx_neuron) = ...
                [ones(1, abs(shift_samples))*n_spikes_matrix_BC(idx_ipg, 1) ...
                n_spikes_matrix_BC(idx_ipg, 1:(n_levels-abs(shift_samples)))];
        end
    end
end
   
sum_pop_1 = sum(n_spikes_population_1, 3);
sum_pop_2 = sum(n_spikes_population_2, 3);

%%

figure
hold on
plot(levels_dB_uA, sum_pop_1/max(max(sum_pop_1)))
plot(levels_dB_uA, sum_pop_2/max(max(sum_pop_2)), '--')

figure
hold on
plot(levels_dB_uA, sum_pop_1)
plot(levels_dB_uA, sum_pop_2, '--')

figure
hold on
histogram(r1)
histogram(r2)

%%
figure
plot(levels_dB_uA, ecap_spikes_r1)
hold on
plot(levels_dB_uA, ecap_spikes_r2)
legend('r1-0', 'r1-50', 'r1-100', 'r2-0', 'r2-50', 'r2-100')

%%

for idx = 1:length(levels_dB_uA)
    figure
    hold on
    plot(ipg_vector_us, ecap_spikes_r1(:, idx)/1000, 'o-')
    plot(ipg_vector_us, ecap_spikes_r2(:, idx)/1000, 'x-')
    title([num2str(levels(idx)) 'dB'])
    ylim([0 40])
end