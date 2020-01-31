function fancy_figure()
  % diego domenzain with dylan mikesell's help
  % spring 2018 @ TUDelft
  % ----------------------------------------------------------------------------
  h = gcf;
  ax = gca;
  % fontsize
  %
  propert = findall(h,'-property','FontSize');
  set(propert,'FontSize',20)
  %
  % LATEX stuff
  %
  propert = findall(h,'-property','Interpreter');
  set(propert,'Interpreter','Latex');
  % set(0,'DefaultTextFontName','NewCenturySchoolBook');
  %
  % axis stuff
  %
  ax.TickLength = [0 0];
  % ax.TitleFontSizeMultiplier = 1.5;
  % % save stuff
  % %
  % % print( variable, 'name', '-dfileextension', '-rresolution' )
  % %
  % % examples:
  % %
  % % print(gcf,'figure-example','-dpng','-r650')
  % % print(gcf,'figure-example','-dpdf')
end