%packages
haproxy
%end

%post
chkconfig haproxy on
%end
