function simple_figure()
  % diego domenzain
  % spring 2019 @ BSU
  % ----------------------------------------------------------------------------
  h = gcf;
  ax = gca;
  box on;
  % --
  % fontsize
  propert = findall(h,'-property','FontSize');
  set(propert,'FontSize',18)
  % --
  % % LATEX stuff
  % propert = findall(h,'-property','Interpreter');
  % set(propert,'Interpreter','Latex');
  % % ax.Title.Interpreter = 'latex';
  % --
  % axis stuff
  ax.TickLength = [0 0];
  % ax.TitleFontSizeMultiplier = 1.5;
  % % --
  % % save stuff
  % % print( variable, 'name', '-dfileextension', '-rresolution' )
  % % examples:
  % % print(gcf,'figure-example','-dpng','-r1000')
  % % print(gcf,'figure-example','-dpdf')
  % % 
  % % fig = gcf;fig.PaperPositionMode = 'auto';
  % % print(gcf,'name','-dpng','-r1000')
end