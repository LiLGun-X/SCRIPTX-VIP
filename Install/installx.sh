#!/bin/bash



rm -f install.sh
scrip="https://raw.githubusercontent.com/tokssa/SAVAT/master"
clear
cd /usr/bin
wget -q -O cr "https://raw.githubusercontent.com/tokssa/SAVAT/master/cr"
chmod +x /usr/bin/cr
if [[ $(id -g) != "0" ]] ; then
    echo ""
    echo "Script : สั่งรูทคำสั่ง [ sudo -i ] ก่อนรันสคริปนี้  "
    echo ""
    exit
fi
zenon=$2

if [[  ! -e /dev/net/tun ]] ; then
    echo "Script : TUN/TAP device is not available."
fi
cd
if [[ -e /etc/debian_version ]]; then
VERSION_ID=$(cat /etc/os-release | grep "VERSION_ID")
fi
if [[ -e /etc/yum ]]; then
VERSION_ID=$(cat /etc/os-release | grep "VERSION_ID")
fi
IP=$(wget -qO- ipv4.icanhazip.com);
if [[ $zenon == "" ]]
then
clear
cr
cd
clear

# install python
apt-get install ruby
yum install ruby
dnf install ruby
wget https://github.com/busyloop/lolcat/archive/master.zip
unzip master.zip
cd lolcat-master/bin
gem install lolcat
apt -y install figlet
apt -y install dos2unix

              
          
echo -e "\033[1;31m════════════════════════════════════════════════════\033[0m"
tput setaf 7 ; tput setab 4 ; tput bold ; printf '%40s%s%-12s\n' ">>>>> โปรดชำระเงินก่อนใช้สคริปท์อัตโนมัติ <<<<<" ; tput sgr0
echo -e "\033[1;31m════════════════════════════════════════════════════\033[0m"
echo ""
echo -e "\033[1;31m• \033[1;33m     สคริปท์นี้ราคา 200 บาท\033[0m" 
echo -e "\033[1;31m• \033[1;33m     จัดทำสคริปโดย LiL_Gunx\033[0m" 
echo -e "\033[1;31m• \033[1;33m     <<<( ใส่รหัสผ่านเพื่อติดตั้ง)>>>\033[0m" 
echo -e "\033[1;31m════════════════════════════════════════════════════\033[0m"
	echo ""
read -p "โปรดใส่รหัสสำหรับติดตั้ง:" passwds
wget -q -O /usr/bin/pass https://raw.githubusercontent.com/LiLGun-X/SCRIPTX-VIP/main/Install/pass.txt
if ! grep -w -q $passwds /usr/bin/pass; then
clear
echo ""
echo ""
echo " เสียใจด้วย รหัสผิด ถ้าไม่มีรหัสติดต่อแอดมินฯ"
echo ""
echo " FB : savat54savat"
echo ""
echo ""
rm /usr/bin/pass
exit

fi

echo ""
echo "----------------------------------------------" | lolcat
echo "|||||||||| PLEASE SELECT MUNU NUMBER |||||||||"
echo "----------------------------------------------" | lolcat
echo "      # หมายเหตุ ถ้าจะติดตั้ง L2TP ให้ติดตั้ง OpenVPN ก่อน   "
echo ""
echo "     [ 1 ] OpenVPN Debian7-8-9 & Ubuntu14.4-16.4"
echo "     [ 2 ] L2TP ได้ทุก OS     "
echo "----------------------------------------------"| lolcat
read -p "     ━━ Namber : " opcao
else
opcao=$zenon
fi
case $opcao in
 1 | 01 )
clear
cd
cr
echo "        ╭━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╮ 
        ┣ แน่ใจคุณต้องการรันระบบ OpenVPN    
        ┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╯   "
    read -p "        ╰━━ ( Y/n ) : " -e -i y Confirn
    if [[ "$Confirn" = "y" || "$Confirn" = "Y" ]]; then
wget -q -O install "https://raw.githubusercontent.com/LiLGun-X/SCRIPTX-VIP/main/Install/installl.sh"
bash install
exit
elif [[ "$Confirn" = "n" || "$Confirn" = "N" ]]; then
clear
clear
wget -O install "https://raw.githubusercontent.com/tokssa/SAVAT/master/install"
bash install
fi
;;
2 | 02)
clear
cd
cr
echo "        ╭━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╮ 
        ┣ แน่ใจคุณต้องการรันระบบ L2TP    
        ┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╯    "
    read -p "        ╰━━ ( Y/n ) : " -e -i y Confirn
    if [[ "$Confirn" = "y" || "$Confirn" = "Y" ]]; then
wget -q -O l2tp "https://raw.githubusercontent.com/tokssa/SAVAT/master/l2tp"
chmod +x l2tp
./l2tp
exit
elif [[ "$Confirn" = "n" || "$Confirn" = "N" ]]; then
clear
clear
wget -O install "https://raw.githubusercontent.com/tokssa/SAVAT/master/install"
bash install
fi
;;
$opcao )
clear
cd
cr
echo "    ━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "    VPNHISPEED THANK YOU "
echo "    ━━━━━━━━━━━━━━━━━━━━━━━━━"
exit 0
;;
esac
