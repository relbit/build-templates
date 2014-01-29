%include /kickstart/include/base.ks
%include /kickstart/include/mysql-client.ks
%include /kickstart/include/nscd.ks
%include /kickstart/include/root-bashrc.ks

%packages
galera
MariaDB-Galera-server
nc
%end

%post
chkconfig mysql on
chkconfig xinetd on

rm -Rf /var/lib/mysql/ib*

cat > /etc/my.cnf <<"EOF"
[client]
port		= 3306
socket		= /var/lib/mysql/mysql.sock

[mysqldump]
quick
max_allowed_packet = 16M

[mysql]
no-auto-rehash

[myisamchk]
key_buffer_size = 256M
sort_buffer_size = 256M
read_buffer = 2M
write_buffer = 2M

[mysqlhotcopy]
interactive-timeout

[mysqld]
bind		= 0.0.0.0
port		= 3306
socket		= /var/lib/mysql/mysql.sock
key_buffer_size = 128M
max_allowed_packet = 1M
table_open_cache = 1024
sort_buffer_size = 1M
read_buffer_size = 2M
read_rnd_buffer_size = 4M
myisam_sort_buffer_size = 48M
thread_cache_size = 80
query_cache_size = 64M
join_buffer_size = 2M
thread_concurrency = 8
max_connections = 1000
tmp_table_size = 32M
max_heap_table_size = 32M
thread_cache=32

table_cache = 2048
table_definition_cache = 4096

log-error=/var/log/mysqld_error.log
log-slow-queries=/var/log/mysqld_slow.log
skip-name-resolve

log-bin=mysql-bin

server-id	= 1

innodb_data_home_dir = /var/lib/mysql
datadir = /var/lib/mysql
innodb_data_file_path = ibdata1:2000M;ibdata2:10M:autoextend
innodb_log_group_home_dir = /var/lib/mysql

innodb_buffer_pool_size = 256M
innodb_additional_mem_pool_size = 20M

innodb_log_file_size = 100M
innodb_log_buffer_size = 8M
innodb_log_files_in_group = 3
innodb_lock_wait_timeout = 50
innodb_thread_concurrency=8

wsrep_provider=/usr/lib64/galera/libgalera_smm.so
wsrep_provider_options="gcache.size=4G; gcache.page_size=1G"
wsrep_cluster_name='relbit-int'
wsrep_sst_method=xtrabackup
wsrep_slave_threads=16

# CONTAINS ROOT PASSWORD TO MARIADB CLUSTER (ssh)
wsrep_sst_auth=root:

# THIS CONTAINS ADDRESS OF OTHER NODES
# THE FIRST ONE CONTAINS EMPTY URL
# e.g. : gcomm:// for empty
# e.g. : gcomm://ip1,ip2 for non empty cluster
wsrep_cluster_address=gcomm://

innodb_flush_log_at_trx_commit=2
innodb_autoinc_lock_mode=2

innodb_locks_unsafe_for_binlog=1
EOF

cat > /etc/xinet.d/mysqlchk <<"EOF"
service mysqlchk 
{
  flags = REUSE
  socket_type = stream
  port = 31900
  wait = no
  user = nobody
  server = /usr/local/bin/mysqlchk.sh 
  log_on_failure += USERID
  disable = no
  per_source = UNLIMITED 
}
EOF

cat > /usr/local/bin/mysqlchk.sh <<"EOF"
#!/bin/bash
#
# This script checks if a mysql server is healthy running on localhost. It will
# return:
#
# "HTTP/1.x 200 OK\r" (if mysql is running smoothly)
#
# - OR -
#
# "HTTP/1.1 503 Service Unavailable\r" (else)
#
# The purpose of this script is make haproxy capable of monitoring mysql properly
#
# Author: Unai Rodriguez
#
# It is recommended that a low-privileged-mysql user is created to be used by
# this script. Something like this:
#
# mysql> GRANT SELECT on mysql.* TO 'mysqlchkusr'@'localhost' \
#     -> IDENTIFIED BY '257retfg2uysg218' WITH GRANT OPTION; 
# mysql> FLUSH PRIVILEGES;
#
# Script modified by Alex Williams - August 4, 2009
#       - removed the need to write to a tmp file, instead store results in memory
#
# Script modified by Tomas Srnka - March 28, 2012
#       - updated to fit Relbit's needs, fixed typos in doc
#


MYSQL_HOST="localhost"
MYSQL_PORT="3306"
MYSQL_USERNAME="mysqlchkusr"
MYSQL_PASSWORD="257retfg2uysg218"

#
# We perform a simple query that should return a few results :-p
#

ERROR_MSG=`/usr/bin/mysql --host=$MYSQL_HOST --port=$MYSQL_PORT --user=$MYSQL_USERNAME --password=$MYSQL_PASSWORD -e "show databases;" 2>/dev/null`

#
# Check the output. If it is not empty then everything is fine and we return
# something. Else, we just do not return anything.
#
if [ "$ERROR_MSG" != "" ]
then
        # mysql is fine, return http 200
        /bin/echo -e "HTTP/1.1 200 OK\r\n"
        /bin/echo -e "Content-Type: Content-Type: text/plain\r\n"
        /bin/echo -e "\r\n"
        /bin/echo -e "MySQL is running.\r\n"
        /bin/echo -e "\r\n"
else
        # mysql is fine, return http 503
        /bin/echo -e "HTTP/1.1 503 Service Unavailable\r\n"
        /bin/echo -e "Content-Type: Content-Type: text/plain\r\n"
        /bin/echo -e "\r\n"
        /bin/echo -e "MySQL is *down*.\r\n"
        /bin/echo -e "\r\n"
fi

EOF
chmod +x /usr/local/bin/mysqlchk.sh

service mysql start

mysql_tzinfo_to_sql /usr/share/zoneinfo | sed 's/SET SESSION wsrep_replicate_myisam/SET GLOBAL wsrep_replicate_myisam/g' | mysql -u root mysql
echo 'default-time-zone=UTC' >> /etc/my.cnf

echo "GRANT SELECT ON mysql.* TO 'mysqlchkusr'@'localhost' IDENTIFIED BY '257retfg2uysg218' WITH GRANT OPTION; FLUSH PRIVILEGES;" | mysql -u root mysql
echo 'mysqlchk        31900/tcp' >> /etc/services

%end
