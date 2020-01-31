function finite_ = dc_kfourier_all(finite_,gerjoii_)
%
% compute ky-fourier coefficients for 2.5d for all sources in survey.
% 
% "ia" is index for a_spacing (a=src_a(ia)) of shot.
%       "ia" should be an integer between 1 and numel( src_a ).
% "in" is index for n_spacing (n=an_spacings{ia}(in)) position of shot.
%       "in" should be an integer between 1 and src_n(ia).
%
% "ky_wky" is a cell where for source (ia,in),
%         ky_wky{ia}{in} = (n_ky x 2) matrix with ky and wky as columns. 

src_a = gerjoii_.dc.src_a;
src_n = gerjoii_.dc.src_n;

fprintf('\n ...computing k-fourier coefficients\n');

ky_wky = cell( numel(src_a) , 1 );
for ia=1:numel( src_a )
  ky_wky_ia = cell( src_n(ia) ,1);
  for in=1:src_n(ia)
    % build source
    gerjoii_ = dc_sosi(gerjoii_,finite_,ia,in);
    % do ky-wky inversion
    finite_ = dc_kfourier(finite_,gerjoii_);
    % store in a nice fucking cell
    ky_wky_ia{in} = finite_.dc.ky_wky_s;
  end
  ky_wky{ia} = ky_wky_ia;
end

finite_.dc.ky_wky = ky_wky;

end