function plot_like_equal_level(single_values, anodic_cathodic_data, ...
    cathodic_anodic_data, level_dB_uA, ratio_anodic_cathodic_dB, color_this_level, hFig, save_bool)

xAxis = 1:18;
num_norm = 10;

figure(hFig)
hold on

% Plot anodic cathodic conditions
hAnodic = plot(xAxis(5:11), anodic_cathodic_data, '-', 'color', color_this_level, 'linewidth', 2);
hold on

% Plot cathodic anodic conditions
hCathodic = plot(xAxis(12:18), cathodic_anodic_data, '-', 'color', color_this_level, 'linewidth', 2);
hold on

% Plot single conditions
hSingle_PSC = plot(xAxis(1:4), single_values, '-', 'color', color_this_level, 'linewidth', 2);
hold on

switch level_dB_uA
    case 40
        h40 = plot(xAxis, [single_values anodic_cathodic_data cathodic_anodic_data], '<', 'color', ...
            color_this_level, 'markerfacecolor', color_this_level, 'tag', 'h40');
    case 50
        h50 = plot(xAxis, [single_values anodic_cathodic_data cathodic_anodic_data], 's', 'color', ...
            color_this_level, 'markerfacecolor', color_this_level, 'tag', 'h50');   
    case 60
        h60 = plot(xAxis, [single_values anodic_cathodic_data cathodic_anodic_data], 'o', 'color', ...
            color_this_level, 'markerfacecolor', color_this_level);
    case 70
        h70 =plot(xAxis, [single_values anodic_cathodic_data cathodic_anodic_data], '>', 'color', ...
            color_this_level, 'markerfacecolor', color_this_level);
end

if save_bool
    disp('saving')
else
    return
end

set(gca, 'linewidth', 2, 'box', 'off')
xlim([0 19])
ylim([0 num_norm+2])
set(gca, 'xtick', 1:18, 'ytick', [1 5.5 10])
set(gca, 'xticklabel', {'PSC','rPSC','PSA','rPSA','0', '50', '100', '200', '400', '800', '1600', ...
    '0', '50', '100', '200', '400', '800', '1600'})
set(gca, 'yticklabel', {'1','40','80'})
set(gca, 'fontsize', 12)
xlabel('                                    IPG (\mus)                                              IPG (\mus)      ', 'fontsize', 16)
ylabel('Number of spikes', 'fontsize', 16)
title('rPS-PS modelling, 40 to 70 dB uA', 'fontsize', 16)


hLine1 = line([4.5 4.5], [1 10]);
hLine2 = line([11.5 11.5], [1 10]);

set([hLine1, hLine2], 'linestyle', '--', 'color', [.6 .6 .6], 'linewidth', 2)


%% Plot pulses

phase_duration_s = 0.05;

[t_values_pseudomonophasic_anodic, y_values_pseudomonophasic_anodic] = ...
    getOnePulse(phase_duration_s, 8, 1);
[t_values_reversed_pseudomonophasic_cathodic,...
    y_values_reversed_pseudomonophasic_cathodic] = ...
    getOnePulse(phase_duration_s, -8, 1);
drawArrow = @(x,y,varargin) quiver( x(1),y(1),x(2)-x(1),y(2)-y(1),0, varargin{:} );

t_values_whole_pulse = [-13*phase_duration_s, ...
    t_values_reversed_pseudomonophasic_cathodic-3*phase_duration_s, ...
    t_values_pseudomonophasic_anodic, ...
    10*phase_duration_s];
y_values_equal_loudness_AC = [0, ...
    -0.6*y_values_reversed_pseudomonophasic_cathodic, ...
    -y_values_pseudomonophasic_anodic, ...
    0];
y_values_equal_loudness_CA = [0, ...
    y_values_reversed_pseudomonophasic_cathodic, ...
    0.6*y_values_pseudomonophasic_anodic, ...
    0];

hold on
plot([0.3 1.2], ...
    [10.5 10.5], ...
    'k-')
hold on
plot(t_values_pseudomonophasic_anodic+0.5, -0.6*y_values_pseudomonophasic_anodic+10.5, 'k-', 'linewidth', 2)
hold on
plot([1.4 2.1], ...
    [10.5 10.5], ...
    'k-')
hold on
plot(t_values_reversed_pseudomonophasic_cathodic+2, 0.6*y_values_reversed_pseudomonophasic_cathodic+10.5, 'k-', 'linewidth', 2)
hold on
plot([2.4 3.1], ...
    [10.5 10.5], ...
    'k-')
hold on
plot(t_values_pseudomonophasic_anodic+2.5, 0.6*y_values_pseudomonophasic_anodic+10.5, 'r-', 'linewidth', 2)
hold on
plot([3.3 4.2], ...
    [10.5 10.5], ...
    'k-')
hold on
plot(t_values_reversed_pseudomonophasic_cathodic+4, -0.6*y_values_reversed_pseudomonophasic_cathodic+10.5, 'r-', 'linewidth', 2)


hold on
plot([4.4 11.2], ...
    [10.5 10.5], ...
    'k-')
hold on
plot(t_values_reversed_pseudomonophasic_cathodic+5, -0.6*y_values_reversed_pseudomonophasic_cathodic+10.5, 'r-', 'linewidth', 2)
hold on
plot(t_values_pseudomonophasic_anodic+6.5, -0.6*y_values_pseudomonophasic_anodic+10.5, 'k-', 'linewidth', 2)
hold on
drawArrow([5 6]+0.2, [11 11],'linewidth',1,'color','k', 'MaxHeadSize', 0.4)
drawArrow([6 5]+0.2, [11 11],'linewidth',1,'color','k', 'MaxHeadSize', 0.4)

hold on
plot([11.4 18.2], ...
    [10.5 10.5], ...
    'k-')
hold on
plot(t_values_reversed_pseudomonophasic_cathodic+12, 0.6*y_values_reversed_pseudomonophasic_cathodic+10.5, 'k-', 'linewidth', 2)
hold on
plot(t_values_pseudomonophasic_anodic+13.5, 0.6*y_values_pseudomonophasic_anodic+10.5, 'r-', 'linewidth', 2)
hold on
drawArrow([12 13]+0.2, [11 11],'linewidth',1,'color','k', 'MaxHeadSize', 0.4)
drawArrow([13 12]+0.2, [11 11],'linewidth',1,'color','k', 'MaxHeadSize', 0.4)

%% Add support text

text(5.5, 11.2, 'IPG')
text(12.5, 11.2, 'IPG')


%% Save as pdf several versions
set(gcf,'PaperOrientation','landscape')
set(gcf,'PaperUnits','centimeters')
set(gcf,'PaperSize', [32 16])
set(gcf,'PaperPosition',[-2 0 36 16])
saveas(gcf, sprintf('figures%srPS_PS_all_levels_figure.pdf', filesep))
