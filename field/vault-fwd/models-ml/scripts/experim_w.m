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
gerjoii_.w.ns = 1;
% if you want more types, input more string types: 
% 'xLINEAR_TIGHT' , 'xLINEAR_SOME', 'xLINEAR_SRCS_RECS'
gerjoii_.w.src_TYPE = {'xLINEAR_SRCS_RECS'};
% build first source from left to right x-axis in (real [x,z] coordinates)
gerjoii_.w.source_xz = [4 0];
% build all source positions in real and binned coordinates
gerjoii_ = w_sources(geome_,finite_,parame_,gerjoii_);
% ------------------------------------------------------------------------------
% build receivers for each source
% 'xLINEAR_TIGHT' , 'xLINEAR_ALL'
gerjoii_.w.rec_TYPE = {'xLINEAR_TIGHT_'};
gerjoii_ = w_receivers(geome_,parame_,gerjoii_);
% ------------------------------------------------------------------------------
% see sources and receivers in a cool plot.
% when running code in a server thru a terminal, displaying graphics can cause 
% the code to slow down, so let's not do the plotting.
% ------------------------------------------------------------------------------
% figure;
% hold on
% for i_source = 1:gerjoii_.w.ns
% plot(geome_.X(1),geome_.Y(1)+i_source,' ')
% plot(geome_.X(end),geome_.Y(1)+i_source,' ')
% plot(gerjoii_.w.receivers_real{i_source}(:,1),...
%     gerjoii_.w.receivers_real{i_source}(:,2)+i_source,...
%     'k.','Markersize',20)
% plot(gerjoii_.w.sources_real(i_source,1),...
%     gerjoii_.w.sources_real(i_source,2)+i_source,...
%     'r.','Markersize',35)
% end
% hold off
% axis tight
% set(gca,'Ydir','reverse')
% ylabel('shot \#');
% xlabel('$x\,[m]$');
% title('sources and receivers');
% fancy_figure();
% % ----------------------------------------------------------------------------
% % ---------- extra receiver(s) --------------
% % ----------------------------------------------------------------------------
% % put extra receiver(s) at depth for every shot
% r_extra_real_x = [10]; % [2; 4; 6];% [m]
% r_extra_real_z = [3.3]; % [3.5; 3.5; 3.5];% [m]
% r_extra_real = [r_extra_real_x , r_extra_real_z]; % (x,z) [m]
% r_extra_x = binning(geome_.X,r_extra_real(:,1));
% r_extra_z = binning(geome_.Y,r_extra_real(:,2));
% r_extra = [r_extra_x,r_extra_z];
% for is=1:gerjoii_.w.ns
%   gerjoii_.w.receivers_real{is} = [gerjoii_.w.receivers_real{is};r_extra_real ];
%   gerjoii_.w.receivers{is} = [gerjoii_.w.receivers{is} ; r_extra ];
% end
% fprintf('\nputting %i extra receiver(s) at depth for every shot\n',size(r_extra,1))
% % ------ extra source & her receivers -----------
% % source
% s_extra_real_x = [10]; % [2; 4; 6];% [m]
% s_extra_real_z = [3.3]; % [3.5; 3.5; 3.5];% [m]
% s_extra_real = [s_extra_real_x , s_extra_real_z]; % (x,z) [m]
% s_extra_x = binning(geome_.X,s_extra_real(:,1));
% s_extra_z = binning(geome_.Y,s_extra_real(:,2));
% s_extra = [s_extra_z,s_extra_x];
% % add to existing sources
% gerjoii_.w.sources_real = [gerjoii_.w.sources_real ; s_extra_real ];
% gerjoii_.w.sources = [gerjoii_.w.sources ; s_extra ];
% gerjoii_.w.ns = size(gerjoii_.w.sources,1);
% % receivers
% source_xz = gerjoii_.w.source_xz;
% lo4 = parame_.w.lo/4;
% r_extra_real_x = (source_xz(1):lo4:(parame_.bb-source_xz(1))).';% [m]
% r_extra_real_z = zeros(numel(r_extra_real_x),1);% [m]
% r_extra_real = [r_extra_real_x , r_extra_real_z]; % (x,z) [m]
% r_extra_x = binning(geome_.X,r_extra_real(:,1));
% r_extra_z = binning(geome_.Y,r_extra_real(:,2));
% r_extra = [r_extra_x,r_extra_z];
% % add to existing receivers
% for is_=1:size(s_extra,1)
%   gerjoii_.w.receivers_real{end+1} = r_extra_real;
%   gerjoii_.w.receivers{end+1} = r_extra;
% end
% fprintf('\nputting %i extra source(s) at depth and her receivers on the surface\n',...
% size(s_extra,1))
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
% ------------------------------------------------------------------------------
