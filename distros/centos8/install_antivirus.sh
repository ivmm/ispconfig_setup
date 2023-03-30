#---------------------------------------------------------------------
# Function: InstallAntiVirus
#    Install Amavisd, Spamassassin, ClamAV
#---------------------------------------------------------------------
InstallAntiVirus() {
  echo -n "Installing Antivirus utilities (Amavisd-new, ClamAV), Spam filtering (SpamAssassin) and Greylisting (Postgrey)... "
  yum_install amavisd-new spamassassin clamav-server clamav-data clamav-update clamav-filesystem clamav clamav-scanner-systemd clamav-devel clamav-lib clamav-server-systemd unzip bzip2 perl-DBD-mysql postgrey re2c
  sed -i "s/Example/#Example/" /etc/freshclam.conf
  sa-update
  echo -e "[${green}DONE${NC}]\n"
  echo -n "Updating Freshclam Antivirus Database. Please Wait... "
  freshclam 
  sed -i 's/^POSTGREY_TYPE=.*/POSTGREY_TYPE="--inet=10023"/' /etc/sysconfig/postgrey
  
  tee /usr/lib/systemd/system/freshclam.service > /dev/null <<EOF
[Unit]
Description=ClamAV Scanner
After=network.target

[Service]
Type=forking
ExecStart=/usr/bin/freshclam -d -c 1
Restart=on-failure
PrivateTmp=true

[Install]
WantedBy=multi-user.target
EOF

  systemctl enable amavisd.service
  systemctl start amavisd.service
  systemctl start clamd@amavisd.service
  systemctl enable postgrey.service
  systemctl start postgrey.service
  systemctl enable freshclam.service
  systemctl start freshclam.service
  echo -e "[${green}DONE${NC}]\n"
}
