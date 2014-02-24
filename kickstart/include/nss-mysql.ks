%packages
haproxy
pam_mysql
libnss-mysql
%end

%post
cat > /etc/nsswitch.conf <<"EOF"
passwd:     files mysql
shadow:     files mysql
group:      files mysql

#hosts:     db files nisplus nis dns
hosts:      files dns

bootparams: nisplus [NOTFOUND=return] files

ethers:     files
netmasks:   files
networks:   files
protocols:  files
rpc:        files
services:   files

netgroup:   nisplus

publickey:  nisplus

automount:  files nisplus
aliases:    files nisplus
EOF
chmod 644 /etc/nsswitch.conf
#******************************************

cat > /etc/init.d/haproxy-mysql-nss <<"EOF"
#!/bin/sh 
#
# haproxy-mysql-nss
#
# chkconfig:   - 85 15
# description:  HAProxy is a free, very fast and reliable solution \
#               offering high availability, load balancing, and \
#               proxying for TCP and  HTTP-based applications. \
#               This is a special instance of HAProxy dedicated \
#               for MySQL HA for Relbit's NSS database
# processname: haproxy-mysql-nss
# config:      /etc/haproxy/mysql-nss.cfg
# pidfile:     /var/run/haproxy-mysql-nss.pid

# Source function library.
. /etc/rc.d/init.d/functions

# Source networking configuration.
. /etc/sysconfig/network

# Check that networking is up.
[ "$NETWORKING" = "no" ] && exit 0

exec="/usr/sbin/haproxy-mysql-nss"
prog="haproxy"
instance="mysql-nss"

[ -e /etc/sysconfig/$prog-$instance ] && . /etc/sysconfig/$prog-$instance

lockfile=/var/lock/subsys/haproxy-mysql-nss

check() {
    $exec -c -V -f /etc/$prog/$instance.cfg
}

start() {
    $exec -c -q -f /etc/$prog/$instance.cfg
    if [ $? -ne 0 ]; then
        echo "Errors in configuration file, check with $prog check."
        return 1
    fi
 
    echo -n $"Starting $prog-$instance: "
    # start it up here, usually something like "daemon $exec"
    daemon $exec -D -f /etc/$prog/$instance.cfg -p /var/run/$prog-$instance.pid
    retval=$?
    echo
    [ $retval -eq 0 ] && touch $lockfile
    return $retval
}

stop() {
    echo -n $"Stopping $prog-$instance: "
    # stop it here, often "killproc $prog"
    killproc -p /var/run/$prog-$instance.pid
    retval=$?
    echo
    [ $retval -eq 0 ] && rm -f $lockfile
    return $retval
}

restart() {
    $exec -c -q -f /etc/$prog/$instance.cfg
    if [ $? -ne 0 ]; then
        echo "Errors in configuration file, check with $prog-$instance check."
        return 1
    fi
    stop
    start
}

reload() {
    $exec -c -q -f /etc/$prog/$instance.cfg
    if [ $? -ne 0 ]; then
        echo "Errors in configuration file, check with $prog-$instance check."
        return 1
    fi
    echo -n $"Reloading $prog-$instance: "
    $exec -D -f /etc/$prog/$instance.cfg -p /var/run/$prog-$instance.pid -sf $(cat /var/run/$prog-$instance.pid)
    retval=$?
    echo
    return $retval
}

force_reload() {
    restart
}

fdr_status() {
    status $prog
}

case "$1" in
    start|stop|restart|reload)
        $1
        ;;
    force-reload)
        force_reload
        ;;
    check)
        check
        ;;
    status)
        fdr_status
        ;;
    condrestart|try-restart)
  	[ ! -f $lockfile ] || restart
	;;
    *)
        echo $"Usage: $0 {start|stop|status|restart|try-restart|reload|force-reload}"
        exit 2
esac
EOF
chmod 755 /etc/init.d/haproxy-mysql-nss
#******************************************

ln -sf /usr/sbin/haproxy /usr/sbin/haproxy-mysql-nss
chkconfig haproxy-mysql-nss on

%end
