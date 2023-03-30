#---------------------------------------------------------------------
# Function: InstallJailkit
#    Install Jailkit
#---------------------------------------------------------------------

InstallJailkit() {
  # If the jailkit RPM is NOT installed, build from source
  if [ "$(rpm -q --quiet jailkit)" ]; then
    echo -n "Installing Jailkit... "
    yum_install https://abs.openanolis.cn/download/ispconfig-packages/jailkit/2.23-1.an8/x86_64/Packages/jailkit-2.23-1.an8.x86_64.rpm
    echo -e "[${green}DONE${NC}]\n"
  fi
}

