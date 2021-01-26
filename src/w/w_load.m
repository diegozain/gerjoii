function [parame_,gerjoii_] = w_load(parame_,gerjoii_,is)
  % diego domenzain.
  % boise state university, 2018.
  % ............................................................................
  % loads field data from hard disk sotred file.
  % 'is' indexes source #
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
  pis = parame_.w.pis;
  pjs = parame_.w.pjs;
  air = parame_.w.air;
  ny = parame_.w.ny;
  nx = parame_.w.nx;
  wvlets_ = parame_.w.wvlets_;
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
  % ............................................................................
  % use only part of the data for the source estimation
  if isfield(radargram,'irx_keepx_')
    gerjoii_.w.irx_keepx_ = radargram.irx_keepx_;
    gerjoii_.w.irx_keepx__= radargram.irx_keepx__;
  end
  % % ..........................................................................
  % % receiver at src
  % gerjoii_.w.Jy = Jy;
  % ............................................................................
  % clear used radargram. "use and destroooooyyy"
  clear radargram s_r_;
end