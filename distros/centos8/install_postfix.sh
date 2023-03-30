#---------------------------------------------------------------------
# Function: Install Postfix
#    Install and configure postfix
#---------------------------------------------------------------------
InstallPostfix() {
  echo -n "Disabling Sendmail... "
  systemctl stop sendmail.service
  systemctl disable sendmail.service
  echo -e "[${green}DONE${NC}]\n"
  echo -n "Installing SMTP Mail server (Postfix)... "
  yum_install postfix postfix-mysql ntp getmail
  mv /etc/postfix/master.cf /etc/postfix/master.cf_bak
  mv ./config/master.cf /etc/postfix/master.cf
  #Fix for mailman virtualtable - need also without mailman
  mkdir /etc/mailman/
  touch /etc/mailman/virtual-mailman
  postmap /etc/mailman/virtual-mailman
  echo -e "[${green}DONE${NC}]\n"
}
