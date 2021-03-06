%include /kickstart/include/base.ks
%include /kickstart/include/nscd.ks
%include /kickstart/include/root-bashrc.ks

%packages
varnish
memcached
%end

%post

chkconfig memcached on
chkconfig varnish on

cat > /etc/sysconfig/memcached <<"EOF"
PORT="11211"
USER="memcached"
MAXCONN="10240"
CACHESIZE="64"
OPTIONS=""
EOF

cat > /etc/sysconfig/varnish <<"EOF"
NFILES=131072
MEMLOCK=82000
RELOAD_VCL=1
VARNISH_VCL_CONF=/etc/varnish/default.vcl
VARNISH_LISTEN_PORT=80
VARNISH_ADMIN_LISTEN_ADDRESS=127.0.0.1
VARNISH_ADMIN_LISTEN_PORT=6082
VARNISH_SECRET_FILE=/etc/varnish/secret
VARNISH_MIN_THREADS=10
VARNISH_MAX_THREADS=1000
VARNISH_THREAD_TIMEOUT=120

VARNISH_STORAGE_FILE=/var/lib/varnish/varnish_storage.bin
VARNISH_STORAGE_SIZE=256M

#VARNISH_STORAGE="file,${VARNISH_STORAGE_FILE},${VARNISH_STORAGE_SIZE}"
VARNISH_STORAGE="malloc,${VARNISH_STORAGE_SIZE}"
VARNISH_TTL=120
DAEMON_OPTS="-a ${VARNISH_LISTEN_ADDRESS}:${VARNISH_LISTEN_PORT} \
             -f ${VARNISH_VCL_CONF} \
             -T ${VARNISH_ADMIN_LISTEN_ADDRESS}:${VARNISH_ADMIN_LISTEN_PORT} \
             -t ${VARNISH_TTL} \
             -w ${VARNISH_MIN_THREADS},${VARNISH_MAX_THREADS},${VARNISH_THREAD_TIMEOUT} \
             -u varnish -g varnish \
             -S ${VARNISH_SECRET_FILE} \
             -s ${VARNISH_STORAGE}"
EOF

%end
