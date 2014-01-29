%packages
nfs-utils
%end

%post
chkconfig rpcbind on
chkconfig nfs on
%end
