%packages
nscd
%end

%post
chkconfig nscd on
%end
