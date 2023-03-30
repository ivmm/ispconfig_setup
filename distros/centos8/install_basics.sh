#---------------------------------------------------------------------
# Function: InstallBasics
#    Install basic packages
#---------------------------------------------------------------------
InstallBasics() {
  echo -n "Updating yum package database and upgrading currently installed packages... "
  yum config-manager --set-enabled powertools
  hide_output yum -y update 
  echo -e "[${green}DONE${NC}]\n"

  echo -n "Installing basic packages... "
  yum_install nano wget net-tools NetworkManager-tui selinux-policy deltarpm epel-release which
  rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY*
  echo -e "[${green}DONE${NC}]\n"
  
  echo -n "Enable Remi's RPM repository... "
  yum_install https://rpms.remirepo.net/enterprise/remi-release-8.rpm
  dnf module reset php
  dnf module disable php
  echo -e "[${green}DONE${NC}]\n"

  echo -n "Enable LLStack ISPConfig repository... "
  sudo curl -o /etc/yum.repos.d/llstack-ISPconfig-Setup-centos-stream-8.repo https://copr.fedorainfracloud.org/coprs/llstack/ISPconfig-Setup/repo/centos-stream-8/llstack-ISPconfig-Setup-centos-stream-8.repo
  yum config-manager --enable llstack-ISPconfig-Setup-centos-stream-8
  echo -e "[${green}DONE${NC}]\n"

  echo -n "Disabling Firewall... "
  systemctl stop firewalld.service
  systemctl disable firewalld.service
  echo -e "[${green}DONE${NC}]\n"
  
  echo -n "Disabling SELinux... "
  sed -i "s/SELINUX=enforcing/SELINUX=disabled/" /etc/selinux/config
  echo -e "[${green}DONE${NC}]\n"
  
  echo -n "Installing Development Tools... "
  hide_output yum -y groupinstall 'Development Tools'  
  echo -e "[${green}DONE${NC}]\n"
}

