function dc_noiser_(parame_,gerjoii_)
  % diego domenzain
  % fall 2018 @ BSU
  % ----------------------------------------------------------------------------
  % give noise to data.
  % first run datavis_dc.m first to see all of the data
  % and choose # of clusters to perturb.
  % ----------------------------------------------------------------------------
  prcent = gerjoii_.dc.noise.prcent;
  n_vkluster = gerjoii_.dc.noise.n_vkluster;
  % load data
  data_path_ = parame_.dc.data_path_;
  load(strcat(data_path_,'s_i_r_d_std','.mat'));
  % s_i_r_d_std{ i_e }{ 1 }(1:2)   gives source.
  % s_i_r_d_std{ i_e }{ 1 }(3)     gives current.
  % s_i_r_d_std{ i_e }{ 2 }(:,1:2) gives receivers.
  % s_i_r_d_std{ i_e }{ 2 }(:,3)   gives observed data (=0 if synth experiment).
  % s_i_r_d_std{ i_e }{ 2 }(:,4)   gives observed std.
  n_exp = size(s_i_r_d_std,2);
  data = [];
  for i_e = 1:n_exp
    data = [data ; s_i_r_d_std{ i_e }{ 2 }(:,3)];
  end
  % data is clustered: NOT gaussian distribution
  idv=kmeans(data,n_vkluster);
  % data(idv==1),data(idv==2),data(idv==3)
  for ivk=1:n_vkluster
    d_ivk = data(idv==ivk);
    std_ = prcent*std(d_ivk(:));
    noise_amp = std_;
    noise = (2*rand(numel(d_ivk),1)-1) * noise_amp;
    d_ivk = d_ivk + noise;
    data(idv==ivk) = d_ivk;
  end
  % put back into s_i_r_d_std
  for i_e = 1:n_exp
    d = s_i_r_d_std{ i_e }{ 2 }(:,3);
    nd = numel(d);
    s_i_r_d_std{ i_e }{ 2 }(:,3) = data(1:nd);
    data(1:nd) = [];
  end
  % save
  name = strcat(data_path_,'s_i_r_d_std','.mat');
  save( name , 's_i_r_d_std' );
end
