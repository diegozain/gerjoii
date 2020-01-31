function unicodeValue = fancy_char(unicodeValue)
% unicodeValue is string of hex value
% example:
% unicodeValue = fancy_char(unicodeValue);
% now it is ready for use:
% text( x, y,...
% unicodeValue,...       
% 'FontSize',12,...
% 'HorizontalAlignment', 'Center',... 
% 'VerticalAlignment', 'Middle' );
% --
%Native format (bit/byte arrangement)
unicodeValue = char( hex2dec( unicodeValue ));
%Convert to Unicode 16 format
unicodeValue = native2unicode( unicodeValue, 'UTF-16' );
end