function [parame_,gerjoii_] = w_load_disk(parame_,gerjoii_,is)
  % diego domenzain.
  % colorado school of mines, summer 2020.
  % ............................................................................
  % loads field data from hard disk sotred file.
  % 'is' indexes source #
  % 
  % moreover, this one is built for models with a big domain that results in 
  % a huge wave-cube.
  % ............................................................................
  data_path_ = parame_.w.data_path_;
  load(strcat(data_path_,'line',num2str(is),'.mat'));
  load(strcat(data_path_,'s_r_','.mat'));
  % ............................................................................
  % load everything
  d_o  = radargram.d;
  std_ = radargram.std_;
  dr   = radargram.dr;
  % Jy = radargram.Jy;
  if isfield(radargram,'v_mute')
    gerjoii_.w.v_mute = radargram.v_mute;
    gerjoii_.w.t_mute = radargram.t_mute;
    gerjoii_.w.r_real = radargram.r;
  end
  % ............................................................................
  pis= parame_.w.pis;
  pjs= parame_.w.pjs;
  air= parame_.w.air;
  ny = parame_.w.ny;
  nx = parame_.w.nx;
  wvlets_ = parame_.w.wvlets_;
  ix = gerjoii_.domain(is).ix;
  % ............................................................................
  % change s_r_ to match indicies of tiny domain
  % src
  s_r_{is,1}(:,2) =  s_r_{is,1}(:,2) - ix+1; % ix
  % recs 
  s_r_{is,2}(:,1) =  s_r_{is,2}(:,1) - ix+1; % ix
  % ............................................................................
  % src + air + pml (on last pixel of air layer)
  s_r_{is,1}(:,2) = pjs + s_r_{is,1}(:,2); % ix
  s_r_{is,1}(:,1) = pis + air + s_r_{is,1}(:,1); % iz
  % recs + air + pml (on last pixel of air layer)
  s_r_{is,2}(:,1) = pjs + s_r_{is,2}(:,1); % ix
  s_r_{is,2}(:,2) = pis + air + s_r_{is,2}(:,2); % iz
  % ............................................................................
  % record to gerjoii_
  gerjoii_.w.s = s_r_{is,1}; % flip(s_r_{is,1},2);
  gerjoii_.w.r = s_r_{is,2};
  gerjoii_.w.dr = dr;
  % ............................................................................
  % build Mw
  gerjoii_ = w_M(gerjoii_,ny,nx);
  % ............................................................................
  % assign observed data and std
  parame_.natu.w.d_2d = d_o;
  parame_.natu.w.N = std_;
  % ............................................................................
  % assign source wavelet
  gerjoii_.w.wvlet_ = wvlets_(:,is);
  % % ..........................................................................
  % % receiver at src
  % gerjoii_.w.Jy = Jy;
  % ............................................................................
  % clear used radargram. "use and destroooooyyy"
  clear radargram s_r_;
end