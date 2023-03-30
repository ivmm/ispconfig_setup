#---------------------------------------------------------------------
# Function: InstallWebServer
#    Install and configure Apache2, php + modules
#---------------------------------------------------------------------
InstallWebServer() {

  if [ "$CFG_WEBSERVER" == "apache" ]; then
	CFG_NGINX=n
	CFG_APACHE=y
    echo -n "Installing Web server (Apache)... "
    yum_install httpd
	echo -e "[${green}DONE${NC}]\n"
	echo -n "Installing PHP and modules... "
	yum_install mod_ssl mod_suphp php php-mysql php-mbstring
	yum_install php74-php-devel php74-php-cli php74-php-bcmath php74-php-gd php74-php-json php74-php-mbstring php74-php-mcrypt php74-php-mysqlnd php74-php-opcache php74-php-pdo php74-php-pecl-crypto php74-php-pecl-mcrypt php74-php-pecl-zip php74-php-recode php74-php-snmp php74-php-soap php74-php-xml
	echo -n "Installing needed programs for PHP and Apache... "
	yum_install curl curl-devel perl-libwww-perl ImageMagick libxml2 libxml2-devel mod_fcgid php-cli httpd-devel php-fpm wget
	echo -e "[${green}DONE${NC}]\n"
	sed -i "s/error_reporting = E_ALL \& ~E_DEPRECATED \& ~E_STRICT/error_reporting = E_ALL \& ~E_NOTICE \& ~E_DEPRECATED/" /etc/php.ini
	sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=1/" /etc/php.ini
	TIME_ZONE=$(echo "$TIME_ZONE" | sed -n 's/ (.*)$//p')
	sed -i "s/;date.timezone =/date.timezone=\"${TIME_ZONE//\//\\/}\"/" /etc/php.ini
	echo "LoadModule suphp_module /usr/lib64/httpd/modules/mod_suphp.so" > /etc/httpd/conf.d/suphp.conf
	echo "[global]" > /etc/suphp.conf
	echo ";Path to logfile" >> /etc/suphp.conf 
	echo "logfile=/var/log/httpd/suphp.log" >> /etc/suphp.conf
	echo ";Loglevel" >> /etc/suphp.conf
	echo "loglevel=info" >> /etc/suphp.conf
	echo ";User Apache is running as" >> /etc/suphp.conf
	echo "webserver_user=apache" >> /etc/suphp.conf
	echo ";Path all scripts have to be in" >> /etc/suphp.conf
	echo "docroot=/" >> /etc/suphp.conf
	echo ";Path to chroot() to before executing script" >> /etc/suphp.conf
	echo ";chroot=/mychroot" >> /etc/suphp.conf
	echo "; Security options" >> /etc/suphp.conf
	echo "allow_file_group_writeable=true" >> /etc/suphp.conf
	echo "allow_file_others_writeable=false" >> /etc/suphp.conf
	echo "allow_directory_group_writeable=true" >> /etc/suphp.conf
	echo "allow_directory_others_writeable=false" >> /etc/suphp.conf
	echo ";Check wheter script is within DOCUMENT_ROOT" >> /etc/suphp.conf
	echo "check_vhost_docroot=true" >> /etc/suphp.conf
	echo ";Send minor error messages to browser" >> /etc/suphp.conf
	echo "errors_to_browser=false" >> /etc/suphp.conf
	echo ";PATH environment variable" >> /etc/suphp.conf
	echo "env_path=/bin:/usr/bin" >> /etc/suphp.conf
	echo ";Umask to set, specify in octal notation" >> /etc/suphp.conf
	echo "umask=0077" >> /etc/suphp.conf
	echo "; Minimum UID" >> /etc/suphp.conf
	echo "min_uid=100" >> /etc/suphp.conf
	echo "; Minimum GID" >> /etc/suphp.conf
	echo "min_gid=100" >> /etc/suphp.conf
	echo "" >> /etc/suphp.conf
	echo "[handlers]" >> /etc/suphp.conf
	echo ";Handler for php-scripts" >> /etc/suphp.conf
	echo "x-httpd-suphp=\"php:/usr/bin/php-cgi\"" >> /etc/suphp.conf
	echo ";Handler for CGI-scripts" >> /etc/suphp.conf
	echo "x-suphp-cgi=\"execute:"'!'"self\"" >> /etc/suphp.conf
	
	sed -i '0,/<FilesMatch \\.php$>/ s/<FilesMatch \\.php$>/<Directory \/usr\/share>\n<FilesMatch \\.php$>/' /etc/httpd/conf.d/php.conf
	sed -i '0,/<\/FilesMatch>/ s/<\/FilesMatch>/<\/FilesMatch>\n<\/Directory>/' /etc/httpd/conf.d/php.conf
	
	systemctl start php-fpm.service
    systemctl enable php-fpm.service
    systemctl enable httpd.service
	
	echo "Installing phpMyAdmin... "
	yum -y install phpmyadmin
	echo -e "[${green}DONE${NC}]\n"
    sed -i "s/Require ip 127.0.0.1/#Require ip 127.0.0.1/" /etc/httpd/conf.d/phpMyAdmin.conf
    sed -i '0,/Require ip ::1/ s/Require ip ::1/#Require ip ::1\n       Require all granted/' /etc/httpd/conf.d/phpMyAdmin.conf
	sed -i "s/'cookie'/'http'/" /etc/phpMyAdmin/config.inc.php
	systemctl enable  httpd.service
    systemctl restart  httpd.service
	# echo -e "${green}done! ${NC}\n"
  elif [ "$CFG_WEBSERVER" == "nginx" ]; then
    echo -n "Installing Web server (nginx)... "
	echo -e "\n${red}Sorry but nginx is not yet supported.${NC}" >&2
	echo -e "For more information, see this issue: https://github.com/servisys/ispconfig_setup/issues/67\n"
	read DUMMY
  fi

  # echo -e "${green}done! ${NC}\n"

  echo -n "Installing Let's Encrypt (Certbot)... "
  yum_install certbot

  echo -e "[${green}DONE${NC}]\n"
}
