close all
clear
% diego domenzain
% spring 2018
% ------------------------------------------------------------------------------
% build txt file for sources and receivers that iris will use in the field.
% 
% hopefully a field with sheep, nice weather, good food and cute girls.
%
% OUTPUT: file abmn-survey.txt in this directory that has to be put into the 
%         Syscal through ElectrePro and a usb cable.
% ------------------------------------------------------------------------------
% number of electrodes to use
n_electrodes = 36;
% electrode spacing
dr=1;
% for two sided 'yes'
abmn_flip = 'no';
% ------------------------------------------------------------------------------
% beneath here is just code. no need to look if you dont feel curious today.
% ------------------------------------------------------------------------------
% ----------
%     wenner
% ----------
% abmn_wen is a cell where,
% 
% abmn_wen{ a_spacing }( n_lvl , : )
% 
% is the [a b m n] vector for shot with cte (a_spacing,n_lvl)
%
% ----------
% dipole-dipole
% ----------
% abmn_dd is a cell where,
% 
% abmn_dd{ a_spacing }{ n_lvl }
% 
% is the [a b m n] matrix for all shots with cte (a_spacing,n_lvl)
%
% ----------
%       abmn
% ----------
% abmn is a matrix,
% 
% abmn(:,1:2) is [a b] for all shots
% abmn(:,3:4) is [m n] for all shots
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
% -----------------------------
% re-arrange abmn for fast field sequence
% -----------------------------
abmn = dc_iris2abmn(abmn);
[n_shots,~] = size(abmn);
abmn = [ (1:n_shots).' , abmn];
% -----------------------------
% for header info
% -----------------------------
abmn_num = (1:n_electrodes).';
abmn_coordx = dr*(0:n_electrodes-1).';
abmn_coordy = zeros(n_electrodes,1);
abmn_coordz = zeros(n_electrodes,1);
abmn_header = [abmn_num abmn_coordx abmn_coordy abmn_coordz];
% ------------------------------------------------------------------------------
% matrix abmn is almost ready for iris.
% it still needs the real coordinates of electrodes and 
% some delimiter lines. For example:
%
% # X Y Z 
% 1 0.0 0.0 0.0
% 2 1.0 0.0 0.0
% ...
% # A B M N
% - abmn.txt goes here -
%
% NOTE:
% for some stupid reason windows does not recognize line-breaks.
% have to write bash script to fix this.
% dlmwrite('abmn.txt',abmn,'delimiter','\t','newline', 'pc');
% dlmwrite('abmn-header.txt',abmn_header,'delimiter','\t','newline', 'pc');
% -----
% change \n to \r\n for reading with Microsoft.
fid = fopen('abmn-header.txt','w');
fprintf(fid,'%s %s %s %s\r\n','#','X','Y','Z');
fprintf(fid,'%2i %2.2f %2.2f %2.2f\r\n',abmn_header.');
fclose(fid);
fid = fopen('abmn.txt','w');
fprintf(fid,'%s %s %s %s %s\r\n','#','A','B','M','N');
fprintf(fid,'%4i %4i %4i %4i %4i\r\n',abmn.');
fclose(fid);
!rm abmn-survey.txt
!touch abmn-survey.txt
!cat abmn-header.txt >> abmn-survey.txt
!cat abmn.txt >> abmn-survey.txt
fprintf('\n\n I have created abmn sequences for use with Syscal for you.\n')
fprintf(' You can find them in the current directory as:\n')
fprintf('\n           abmn-survey.txt\n\n')
fprintf('           with %i electrodes\n',n_electrodes)
fprintf('           with %dm electrode spacing\n\n',dr)
% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
% for plotting (you can comment this)
% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
%%{
% delete # of shot
abmn(:,1)=[];
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
electr_real = [ abmn_coordx+2 , zeros(n_electrodes,1) ];
% set structures needed for plotting
gerjoii_.dc.electr_real = electr_real;
gerjoii_.dc.n_electrodes = n_electrodes;
gerjoii_.dc.n_exp = size( s_i_r_d_std , 2 );
% end points of survey or full discretization of survey
geome_.X = [0 (electr_real(end,1)+2)];
% plot src-rec pairs
for i_e=1:gerjoii_.dc.n_exp
  s_all{i_e} = s_i_r_d_std{ i_e }{ 1 }(1:2);
  r_all{i_e} = s_i_r_d_std{ i_e }{ 2 }(:,1:2);
end
dc_plot_srcrec_all(gerjoii_,geome_,s_all,r_all);
clear electr_real n_electrodes src i_o rec d_o std_o s_all r_all;
%}