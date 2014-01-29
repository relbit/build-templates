%include /kickstart/include/base.ks
%include /kickstart/include/nscd.ks
%include /kickstart/include/root-bashrc.ks

%packages
memcached
nc
-rubygem-json-*
%end

%post
chkconfig memcached on

cat > /etc/sysconfig/memcached <<"EOF"
PORT="11211"
USER="memcached"
MAXCONN="10240"
CACHESIZE="512"
OPTIONS=""
EOF
%end
