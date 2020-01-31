function wvlet_ = w_natur(geome_,parame_,finite_,gerjoii_,is)

radargram = struct;
data_path_ = parame_.data_path_;
% choose source
load(strcat(data_path_,'s_r_','.mat'));
pis = parame_.w.pis;
pjs = parame_.w.pjs;
air = parame_.w.air;
% src + air + pml (on last pixel of air layer)
s_r_{is,1}(:,2) = pjs + s_r_{is,1}(:,2); % ix
s_r_{is,1}(:,1) = pis+air + s_r_{is,1}(:,1); % iz
% recs + air + pml (on last pixel of air layer)
s_r_{is,2}(:,1) = pjs + s_r_{is,2}(:,1); % ix
s_r_{is,2}(:,2) = pis+air + s_r_{is,2}(:,2); % iz
% record to gerjoii_
gerjoii_.w.s = s_r_{is,1}; % flip(s_r_{is,1},2);
gerjoii_.w.r = s_r_{is,2};
clear s_r_;
% build M for those receivers
gerjoii_ = w_M(gerjoii_,parame_.w.ny,parame_.w.nx);
% initialize observed data as zeros (because we are modeling nature now)
parame_.natu.w.d_2d = zeros( geome_.w.nt , gerjoii_.w.nr );
% build standard deviation of data (just identities for now)
std_2d = ones( geome_.w.nt*gerjoii_.w.nr , 1);
% build wavelet
wvlet_ = w_wavelet(geome_.w.T*1e-9,parame_.w.ampli,parame_.w.tau);
gerjoii_.w.wvlet_ = wvlet_;
% ----- fwd models ------
[~,gerjoii_] = w_fwd(geome_,parame_,finite_,gerjoii_);
% ------ radargram ------
radargram.d = gerjoii_.w.d_2d;  % [s] x [m]
radargram.t = geome_.w.T*1e-9;  % [s]
radargram.dt = geome_.w.dt;     % [s]
radargram.fo = parame_.w.fo;    % [Hz]
radargram.dx = geome_.dx;       % [m]
% sources and receivers in real coordinates
r = gerjoii_.w.receivers_real{is}(:,:);
s = gerjoii_.w.sources_real(is,:);
radargram.r = r;
radargram.s = s;
radargram.dr = abs(r(1,1)-r(2,1)); % [m]
radargram.dsr = sqrt( ( s(1)-r(1,1) )^2 + ( s(2)-r(1,2) )^2 ); % [m]
% wavelet
radargram.wvlet_ = wvlet_;
% std_
radargram.std_ = std_2d;
% save
name = strcat(data_path_,'line',num2str( is ),'.mat');
save( name , 'radargram' );

end