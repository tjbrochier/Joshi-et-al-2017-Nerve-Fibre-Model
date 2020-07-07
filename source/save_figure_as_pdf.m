function save_figure_as_pdf()


%% Save as pdf
set(gcf,'PaperType','a5')
set(gcf,'PaperOrientation','landscape')
set(gcf,'PaperUnits','Normalized')
set(gcf,'PaperPosition',[-0.04 0 1.10 1])
saveas(gcf, 'figure.pdf')