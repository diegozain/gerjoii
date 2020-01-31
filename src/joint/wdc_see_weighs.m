function [q,Aw,Adc,Ew,Edc] = wdc_see_weighs(n_samples,Ewbounds,Edcbounds,pl)

if nargin==0
n_samples = 1e+1;
pl = 1;
Ewbounds = [-3,3];
Edcbounds = [-3,3];
fprintf(...
'\nsince you didnt input an # of samples, youre getting a pixelated image...')
fprintf('\nrun:\n    wdc_see_weighs( 1e+3 ) for finer image\n\n')
end
if nargin==1
pl = 1;
Ewbounds = [-3,3];
Edcbounds = [-3,3];
fprintf('\nyou could have also chosen bounds to compute on...\n')
end

Edc=logspace(Edcbounds(1),Edcbounds(2),n_samples);          
Ew=logspace(Ewbounds(1),Ewbounds(2),n_samples);
Ew=Ew.';
Edc=repmat(Edc,size(Ew,1),1);          
Ew=repmat(Ew,1,size(Ew,1));            
q=log10(Ew)./log10(Edc);
if pl==1
  figure;
  fancy_imagesc(q,log10(Edc(1,:)),log10(Ew(:,1)));
  caxis([-2,2])
  colormap(jet)
  ylabel('$\log_{10}( \Theta_{w,\,\sigma} )$')
  xlabel('$\log_{10}( \Theta_{dc} )$')
  title('$\log_{10}( \Theta_w )/\log_{10}( \Theta_{dc} )$')
  fancy_figure()
end

Edc=logspace(Edcbounds(1),Edcbounds(2),n_samples);          
Ew=logspace(Ewbounds(1),Ewbounds(2),n_samples);
Adc=zeros(numel(Ew),numel(Edc));
Aw=zeros(numel(Ew),numel(Edc));
for iw=1:numel(Ew)
  for idc=1:numel(Edc)
    a = wdc_steps(Ew(iw),Edc(idc));
    Aw(iw,idc) = a(1);
    Adc(iw,idc) = a(2);
  end
end
if pl==1
  figure;
  subplot(1,2,1)
  fancy_imagesc(Aw,log10(Edc),log10(Ew))
  hold on
  plot(log10(0.1),log10(100),'w.','markersize',40)
  hold off
  colormap(bone)
  caxis([0 1])
  colorbar('off')
  text(0,0,'$\nearrow$','color','black')
  ylabel('$\log_{10}( h\; \Theta_{w,\,\sigma} )$')
  xlabel('$\log_{10}( \Theta_{dc} )$')
  title('$a_w$')
  fancy_figure()
  subplot(1,2,2)
  fancy_imagesc(Adc,log10(Edc),log10(Ew))
  hold on
  plot(log10(0.1),log10(100),'k.','markersize',40)
  hold off
  colormap(bone)
  text(-0.5,0.5,'$\swarrow$','color','black')
  % ylabel('$\log_{10}( \Theta_w )$')
  xlabel('$\log_{10}( \Theta_{dc} )$')
  set(gca,'ytick',[])
  title('$a_{dc}$')
  h1 = get(subplot(1,2,1),'Position');
  h2 = get(subplot(1,2,2),'Position');
  % [left bottom width height]
  % horizontal
  caxis([0 1])
  colorbar('southoutside','TickLength',0,...
          'Position',[h1(1), h1(2), h1(3)+h2(3)+0.1107,0.05]);
  fancy_figure()

  figure;
  subplot(2,1,1)
  fancy_imagesc(Aw,log10(Edc),log10(Ew))
  colormap(bone)
  caxis([0 1])
  colorbar('off')
  ylabel('$\log_{10}( h\; \Theta_w )$')
  % xlabel('$\log_{10}( \Theta_{dc} )$')
  set(gca,'xtick',[])
  title('$a_w$')
  fancy_figure()
  subplot(2,1,2)
  fancy_imagesc(Adc,log10(Edc),log10(Ew))
  colormap(bone)
  caxis([0 1])
  colorbar('off')
  ylabel('$\log_{10}( h\; \Theta_{w,\,\sigma} )$')
  xlabel('$\log_{10}( \Theta_{dc} )$')
  title('$a_{dc}$')
  h1 = get(subplot(2,1,1),'Position');
  h2 = get(subplot(2,1,2),'Position');
  % [left bottom width height]
  % vertical
  colorbar('eastoutside','TickLength',0,'Ticks',[0,0.5,1],...
           'Position',[h2(3)*0.87  h2(2)*1.05  0.05  h2(3)*1.019]);
  fancy_figure()
end
end