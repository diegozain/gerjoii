function crs_ = cross_(p1, p2, p3)
% diego domenzain
% spring 2019 @ BSU
% ..............................................................................
% Three points are a counter-clockwise turn if cross_ > 0, clockwise if
% cross_ < 0, and collinear if cross_ = 0 because cross_ is a determinant that
% gives twice the signed  area of the triangle formed by p1, p2 and p3.
  crs_ = (p2(1)-p1(1))*(p3(2)-p1(2)) - (p2(2)-p1(2))*(p3(1)-p1(1));
end