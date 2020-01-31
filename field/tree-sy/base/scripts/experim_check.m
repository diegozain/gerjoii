% diego domenzain
% fall 2018 @ BSU
% ..............................................................................
%
%   wave experiments
%
% ..............................................................................
% builds experiment parameters.
% 
% depends on structures: 
% 
%     parame_, finite_ and geome_
%
% structure gerjoii_ has to be defined already,
% so when joining with the dc it doesn't get re-written.
% ------------------------------------------------------------------------------
% build sources
% build receivers for each source
% build observations for each source
% ------------------------------------------------------------------------------
% all type of sources.
% lo wavelength [m]
parame_.w.lo = parame_.w.c/( sqrt( max(parame_.natu.epsilon_w(:)) ))/parame_.w.fo;
% round to nearest-bigger decimal (e.g. 0.561924 -> 0.6)
parame_.w.lo = ceil( parame_.w.lo/0.1 )*0.1;
% optional: number of sources
gerjoii_.w.ns = 20;%40;
% ------------------------------------------------------------------------------
% get recs_ on boundary of shape
[recs_,radius,cosi] = shape_curve(parame_.shape);
% get arc length of receiver spacing 
% for decimation of recs_.
% (arc_length = radius * angle_radians)
radius = radius*geome_.dx;
dangle = parame_.w.lo/4 / radius;
decimator = 0:dangle:(2*pi);
angles = linspace(0,2*pi,size(recs_,1));
ip_ = binning(angles,decimator);
recs_ = recs_(ip_,:);
angles = angles(ip_);
% recs_ is an (nr by 2) matrix with
% column INDEX coordinates [irx , irz]
recs_ = uint32(recs_);
% build all source positions in real and binned coordinates
is_ = 1:fix(size(recs_,1)/gerjoii_.w.ns):size(recs_,1);
sources = recs_(is_,:);
sources = sources(1:gerjoii_.w.ns,:);
sources_real = zeros(size(sources));
sources_real(:,1) = geome_.X(sources(:,1));
sources_real(:,2) = geome_.Y(sources(:,2));
gerjoii_.w.sources_real = sources_real;
sources = flip(sources,2);
gerjoii_.w.sources = sources;
% % build all source positions in real and binned coordinates
% gerjoii_ = w_sources(geome_,finite_,parame_,gerjoii_);
% ------------------------------------------------------------------------------
% build receivers for each source
ns = gerjoii_.w.ns;
receivers_real = cell(ns,1);
receivers = cell(ns,1);
nrecs = size(recs_,1);
for is=1:ns
  % get index of indicies of sources
  is__ = is_(is);
  % initialize index of indicies of recs as all recs_
  ir_ = 1:nrecs;
  % these have to be removed from ir_ (spaced lo/4)
  ir=mod([is__-3 is__-2 is__-1 is__ is__+1 is__+2 is__+3],nrecs);
  ir(ir==0)=nrecs;
  ir_(ir) = [];
  receivers{is} = recs_(ir_,:);
  receivers_real{is} = zeros(size(receivers{is}));
  receivers_real{is}(:,1) = geome_.X(receivers{is}(:,1));
  receivers_real{is}(:,2) = geome_.Y(receivers{is}(:,2));
end
gerjoii_.w.receivers_real = receivers_real;
gerjoii_.w.receivers = receivers;
% ------------------------------------------------------------------------------
is=5;
figure;
hold on
fancy_imagesc(parame_.shape,geome_.X,geome_.Y)
colorbar('off')
plot(geome_.X(gerjoii_.w.receivers{is}(:,1)),...
     geome_.Y(gerjoii_.w.receivers{is}(:,2)),'b.-','markersize',20)
plot(geome_.X(gerjoii_.w.sources(is,2)),...
    geome_.Y(gerjoii_.w.sources(is,1)),'w.-','markersize',40)
hold off
axis tight
set(gca,'Ydir','reverse')
ylabel('y (m)');
xlabel('x (m)');
title(['receivers for source #',num2str(is)]);
simple_figure();
% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
% ---------------------- save as with real data --------------------------------
% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
gerjoii_.w.MUTE = 'no_MUTE';
% s_r is a cell where,
%
% s_r{shot #, 1}(:,1) is sx
% s_r{shot #, 1}(:,2) is sz
% s_r{shot #, 2}(:,1) is rx
% s_r{shot #, 2}(:,2) is rz
s_r = cell(gerjoii_.w.ns,2);
s_r_ = cell(gerjoii_.w.ns,2);
for is=1:gerjoii_.w.ns
% real sources
s_r{is,1} = [gerjoii_.w.sources_real(is,1) , gerjoii_.w.sources_real(is,2)];
% real receivers
s_r{is,2} = [gerjoii_.w.receivers_real{is}(:,1),...
            gerjoii_.w.receivers_real{is}(:,2)];
% indexed sources
s_r_{is,1} = [gerjoii_.w.sources(is,1),gerjoii_.w.sources(is,2)];
% indexed receivers
s_r_{is,2} = [gerjoii_.w.receivers{is}(:,1) , gerjoii_.w.receivers{is}(:,2)];
end
name = strcat(data_path_w,'s_r','.mat');
save( name , 's_r' );
name = strcat(data_path_w,'s_r_','.mat');
save( name , 's_r_' );
% ..............................................................................
%
%   dc experiments
%
% ..............................................................................
% number of electrodes
n_electrodes = 7;
% electrode spacing. [ms]
dr = 1;
parame_.dc.dr = dr;
% wanna do double sided acquisition?
abmn_flip = 'yes';
% ..............................................................................
% generate shots
[abmn_dd,abmn_wen,abmn] = dc_gerjoii2iris(n_electrodes);
if strcmp(abmn_flip,'yes')
  abmn_ = dc_abmn_flip(abmn,n_electrodes);
  abmn = [abmn ; abmn_];
  abmn = unique(abmn,'rows');
end
% -----------------------------
% schlumberger ?
% -----------------------------
abmn_sch = dc_schlumberger(n_electrodes);
abmn = [abmn ; abmn_sch];
% 
[n_shots,~] = size(abmn);
% collect sources
src = abmn(:,1:2);
% collect receivers
rec = abmn(:,3:4);
% set electric current value for sources [A]
i_o = ones(n_shots,1);
% set observed data to zero 
d_o = zeros(n_shots,1);
% set standard deviation to zero
std_o = zeros(n_shots,1);
% bundle sources, current, receivers, observed data and standard deviation,
% s_i_r_d_std{ j }{ 1 }(1:2) gives source.
% s_i_r_d_std{ j }{ 1 }(3) gives current.
% s_i_r_d_std{ j }{ 2 }(:,1:2) gives receivers.
% s_i_r_d_std{ j }{ 2 }(:,3) gives observed data.
% s_i_r_d_std{ j }{ 2 }(:,4) gives observed std.
s_i_r_d_std = dc_iris2gerjoii( src,i_o,rec,d_o,std_o );
% set real coordinates of electrodes (x,z) [m]
% electrode spacing is dr
electr_real = [ ((dr*(0:n_electrodes-1)) + 2).' , zeros(n_electrodes,1) ];
% bundle variables in structure gerjoii_.dc.
gerjoii_.dc.electr_real = electr_real;
gerjoii_.dc.n_electrodes = n_electrodes;
gerjoii_.dc.n_exp = size( s_i_r_d_std , 2 );
% ------------------------------------------------------------------------------
% plot src-rec pairs
for i_e=1:gerjoii_.dc.n_exp
  s_all{i_e} = s_i_r_d_std{ i_e }{ 1 }(1:2);
  r_all{i_e} = s_i_r_d_std{ i_e }{ 2 }(:,1:2);
end
dc_plot_srcrec_all(gerjoii_,geome_,s_all,r_all);
% ------------------------------------------------------------------------------
