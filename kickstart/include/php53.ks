%packages
php53-devel
php53-common
php53-pecl-APC
php53-pecl-memcache
php53-pecl-mongo
php53-pecl-suhosin
php53-pecl-turbo_realpath
php53-extra-ioncube
%end

%post
mkdir -p /etc/php.d

cat > /etc/php.ini <<"EOF"
[PHP]
engine = On
short_open_tag = On
asp_tags = Off
precision = 14
y2k_compliance = On
output_buffering = 4096
zlib.output_compression = Off
implicit_flush = Off
unserialize_callback_func = 
serialize_precision = 100
allow_call_time_pass_reference = Off
safe_mode = Off
safe_mode_gid = Off
safe_mode_include_dir = 
safe_mode_exec_dir = 
safe_mode_allowed_env_vars = PHP_
safe_mode_protected_env_vars = LD_LIBRARY_PATH
disable_functions = 
disable_classes = 
expose_php = On
max_execution_time = 600
max_input_time = 600
memory_limit = 256M
error_reporting = E_ALL & ~E_DEPRECATED
display_errors = Off
display_startup_errors = Off
log_errors = On
log_errors_max_len = 1024
ignore_repeated_errors = Off
ignore_repeated_source = Off
report_memleaks = On
track_errors = Off
html_errors = Off
variables_order = "GPCS"
request_order = "GP"
register_globals = Off
register_long_arrays = Off
register_argc_argv = Off
auto_globals_jit = On
post_max_size = 2048M
magic_quotes_gpc = Off
magic_quotes_runtime = Off
magic_quotes_sybase = Off
auto_prepend_file = 
auto_append_file = 
default_mimetype = "text/html"
doc_root = 
user_dir = 
enable_dl = Off
file_uploads = On
upload_max_filesize = 1024M
allow_url_fopen = On
allow_url_include = Off
default_socket_timeout = 60
date.timezone = Europe/Prague
[Date]
[filter]
[iconv]
[intl]
[sqlite]
[sqlite3]
[Pcre]
[Pdo]
[Phar]
[Syslog]
define_syslog_variables = Off
[mail function]
SMTP = localhost
smtp_port = 25
sendmail_path = /usr/sbin/sendmail -t -i -f admin@relay.prg0.relbitapp.com
mail.add_x_header = On
[SQL]
sql.safe_mode = Off
[ODBC]
odbc.allow_persistent = On
odbc.check_persistent = On
odbc.max_persistent = -1
odbc.max_links = -1
odbc.defaultlrl = 4096
odbc.defaultbinmode = 1
[MySQL]
mysql.allow_persistent = On
mysql.max_persistent = -1
mysql.max_links = -1
mysql.default_port = 
mysql.default_socket = 
mysql.default_host = 
mysql.default_user = 
mysql.default_password = 
mysql.connect_timeout = 60
mysql.trace_mode = Off
[MySQLi]
mysqli.max_links = -1
mysqli.default_port = 3306
mysqli.default_socket = 
mysqli.default_host = 
mysqli.default_user = 
mysqli.default_pw = 
mysqli.reconnect = Off
[PostgresSQL]
pgsql.allow_persistent = On
pgsql.auto_reset_persistent = Off
pgsql.max_persistent = -1
pgsql.max_links = -1
pgsql.ignore_notice = 0
pgsql.log_notice = 0
[Sybase-CT]
sybct.allow_persistent = On
sybct.max_persistent = -1
sybct.max_links = -1
sybct.min_server_severity = 10
sybct.min_client_severity = 10
[bcmath]
bcmath.scale = 0
[browscap]
[Session]
session.use_cookies = 1
session.use_only_cookies = 1
session.name = PHPSESSID
session.auto_start = 0
session.cookie_lifetime = 0
session.cookie_path = /
session.cookie_domain = 
session.cookie_httponly = 
session.serialize_handler = php
session.gc_probability = 1
session.gc_divisor = 1000
session.gc_maxlifetime = 1440
session.bug_compat_42 = Off
session.bug_compat_warn = Off
session.referer_check = 
session.entropy_length = 0
session.entropy_file = 
session.cache_limiter = nocache
session.cache_expire = 180
session.use_trans_sid = 0
session.hash_function = 0
session.hash_bits_per_character = 5
url_rewriter.tags = "a=href,area=href,frame=src,input=src,form=fakeentry"
[MSSQL]
mssql.allow_persistent = On
mssql.max_persistent = -1
mssql.max_links = -1
mssql.min_error_severity = 10
mssql.min_message_severity = 10
mssql.compatability_mode = Off
mssql.secure_connection = Off
[Assertion]
[COM]
[mbstring]
[gd]
[exif]
[Tidy]
tidy.clean_output = Off
[soap]
soap.wsdl_cache_enabled = 1
soap.wsdl_cache_dir = "/tmp"
soap.wsdl_cache_ttl = 86400
[sysvshm]
EOF

cat > /etc/php.d/apc.ini <<"EOF"
extension = apc.so
apc.enabled=1
apc.shm_segments=1
apc.shm_size=128M
apc.num_files_hint=1024
apc.user_entries_hint=4096
apc.ttl=0
apc.use_request_time=1
apc.user_ttl=360
apc.gc_ttl=360
apc.cache_by_default=1
apc.filters
apc.file_update_protection=2
apc.enable_cli=0
apc.max_file_size=1M
apc.stat=1
apc.stat_ctime=0
apc.canonicalize=0
apc.write_lock=1
apc.report_autofilter=0
apc.rfc1867=1
apc.rfc1867_prefix =upload_
apc.rfc1867_name=APC_UPLOAD_PROGRESS
apc.rfc1867_freq=0
apc.rfc1867_ttl=3600
apc.include_once_override=0
apc.lazy_classes=0
apc.lazy_functions=0
apc.coredump_unmap=0
apc.file_md5=0
apc.preload_path
EOF

cat > /etc/php.d/suhosin.ini <<"EOF"
extension = suhosin.so
[suhosin]
suhosin.executor.include.whitelist = phar
suhosin.mail.protect = 1
suhosin.post.max_vars = 10000
suhosin.request.max_vars = 10000
suhosin.get.max_value_length = 10000
EOF

[ -f /etc/httpd/conf.d/php.conf ] && echo "# intentionally empty" > /etc/httpd/conf.d/php.conf

%end
