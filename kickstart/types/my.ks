%include /kickstart/include/base.ks
%include /kickstart/include/mysql-client.ks
%include /kickstart/include/nscd.ks
%include /kickstart/include/root-bashrc.ks

%packages
MariaDB-Galera-server
%end

%post
chkconfig mysql on
chkconfig xinetd on

rm -Rf /var/lib/mysql/ibdata1

cat > /etc/my.cnf <<"EOF"
[client]
port		= 3306
socket		= /var/lib/mysql/mysql.sock

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
innodb_data_file_path = ibdata1:2000M;ibdata2:10M:autoextend
innodb_log_group_home_dir = /var/lib/mysql

innodb_buffer_pool_size = 256M
innodb_additional_mem_pool_size = 20M

innodb_log_file_size = 100M
innodb_log_buffer_size = 8M
innodb_log_files_in_group = 3
innodb_lock_wait_timeout = 50
innodb_thread_concurrency=8
innodb_locks_unsafe_for_binlog=1

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
EOF
%end
