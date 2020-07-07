function plot_iso_loudness_curves(n_spikes_matrix, ipg_vector_us, levels_dB_uA, spikes_to_plot, one_spike_per_pulse)


contourf(n_spikes_matrix', spikes_to_plot)
hold on
c = contour(n_spikes_matrix', [one_spike_per_pulse one_spike_per_pulse], 'k-', 'linewidth', 2);
clabel(c)
set(gca, 'xtick', 1:length(ipg_vector_us))
set(gca, 'xticklabel', num2cell(ipg_vector_us))
set(gca, 'ytick', 1:length(levels_dB_uA))
set(gca, 'yticklabel', num2cell(levels_dB_uA))
cb = colorbar;
cb.Ticks = spikes_to_plot;