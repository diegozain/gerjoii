function d = butter_butter(d,dt,f_low,f_high,nbutter)
% diego domenzain
% fall 2018 @ BSU
% ..............................................................................
[~,nr] = size(d);
fny = 1/dt/2;
% high
%
[Ba,Bb] = butter(nbutter,f_low/fny,'high');
for i=1:nr
    d(:,i) = filtfilt(Ba,Bb,d(:,i));
end
% low
%
[Ba,Bb] = butter(nbutter,f_high/fny,'low');
for i=1:nr
    d(:,i) = filtfilt(Ba,Bb,d(:,i));
end
end
