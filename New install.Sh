
#!/bin/bash

clear
echo '---Bootstrap Script for JC Server---'
sleep 3s
echo ''
echo ''
echo ''
echo 'Occaisonal user input will be required - mostly your password as no sudoloop.'
sleep 3s
echo '|'
sleep 0.1s
echo '\'
sleep 0.1s
echo ' |'
sleep 0.1s
echo ' \'
sleep 0.1s
echo '  |'
sleep 0.1s
echo '  \'
sleep 0.1s
echo '   |'
sleep 0.1s
echo '   \'
sleep 0.1s
echo '    |'
sleep 0.1s
echo '    V'
sleep 0.6s
read -n 1 -s -r -p '    Press any key to continue...' &&
clear

dx_update() {
	clear
	echo '-------------------------------------------'
        echo 'SYNCING REPOSITORIES AND UPDATING SYSTEM...' &&
        sleep 2s;

        sudo apt-get update
        sudo apt full-upgrade -y
        sudo apt dist-upgrade -y
        bincnt=$(ls -1 /usr/bin | wc -l)
        echo ' '
        echo ' '
        echo 'PLEASE WAIT...'
}

dx_locale() {
	clear
	echo '--------------------------'
	echo 'SETTING LOCALE AND VCONSOLE'
	sleep 2s;

	#sudo echo 'LANG="en_US.UTF-8"
	#LC_MESSAGES="C"
	#LC_ALL="en_US.UTF-8"' >> /etc/environment

	#echo 'LANG="en_US.UTF-8"'
	#LC_MESSAGES="C"
	#LC_ALL="en_US.UTF-8"' | sudo tee -a /etc/environment

	#echo "After reboot, use 'locale' to check"
	sudo cp -r /etc/ssh/sshd_config /etc/ssh/sshd_config.bak_original
}


dx_pkg() {
	clear
	echo '----------------------------'
	echo 'INSTALLING REQUIRED PACKAGES'
	sleep 2s
	sudo apt-get install toilet -y
	sudo apt-get install fail2ban unattended-upgrades ufw python3 python3-pip -y &&
	sudo apt-get install ufw tmux git curl zsh ncdu -y &&
	sudo apt-get install libvirt-daemon libvirt-daemon-config-network libvirt-daemon-driver-vbox -y &&
	sudo apt-get install -y qemu-kvm libvirt-daemon-system
        sudo wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
        sudo apt install ./google-chrome-stable_current_amd64.deb
        sudo systemctl enable --now libvirtd
        sudo apt-get install cockpit-ws cockpit-tests cockpit-system cockpit-storaged cockpit-pcp cockpit-packagekit cockpit-networkmanager cockpit-machines cockpit-bridge cockpit-389-ds cockpit -y &&
        clear
	echo 'INSTALLING DOCKER'
	curl -fsSL https://get.docker.com -o get-docker.sh
	sudo sh get-docker.sh &&
	echo 'DONE';
	sleep 2s &&
	clear
	sleep 1s;
	echo 'INSTALLING GRAPHICAL DESKTOP ENVIRONMENT...' &&
	sleep 2s &&
	sudo apt-get install tasksel -y &&
	sudo apt-get install autoconf-archive wget -y
	sudo tasksel install kde-desktop &&
	echo 'DONE';
	sleep 2s &&
	sudo systemctl set-default graphical.target &&
	clear
}

dx_ufw() {
	clear
	echo '-----------------------------;
	echo '
	sudo ufw allow OpenSSH
	sudo ufw allow http
	sudo ufw allow https
	sudo ufw default allow outgoing

}

dx_opr() {
	sudo useradd -m opr;
        sudo apt install -y qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils ovmf
        sudo adduser john libvirt
        sudo adduser john kvm
        sudo mkdir -vp /var/lib/libvirt/images/hassos-vm && cd /var/lib/libvirt/images/hassos-vm
        sudo wget https://github.com/home-assistant/operating-system/releases/download/6.6/haos_ova
        sudo virsh pool-create-as --name hassos --type dir --target /var/lib/libvirt/images/hassos-vm

	sudo usermod -aG sudo opr;
	sudo mkdir /home/opr/.ssh &&
	sudo chmod 700 /home/opr/.ssh &&
        sudo mkdir -vp /var/lib/libvirt/images/hassos-vm && cd /var/lib/libvirt/images/hassos-vm

	if [ ! -f /home/opr/.ssh/authorized_keys ];
	then
		touch /home/opr/.ssh/authorized_keys;
	fi

	sudo chmod -R 700 /home/opr/.ssh
	sudo chmod 644 /home/opr/.ssh/authorized_keys
	sudo chown -R opr:opr /home/opr;
	clear &&
	sleep 2s;

	echo 'Enter a new password for System Operator account (opr)...'
	sleep 1s &&
	echo ' '
	sudo passwd opr &&
	echo 'REISTERED'
	clear &&
	sleep 2s;

	echo 'Enter new root password (root)...'
	sleep 1s &&
	echo ' '
	sudo passwd root &&
	echo 'REGISTERED'
}

dx_services() {
	touch ./.stmp

	echo fail2ban >> ./.stmp
	echo docker >> ./.stmp
	echo 'cockpit.socket' >> ./.stmp

	while read -r sline; do
		sudo systemctl enable "$sline" &&
		sudo systemctl start "$sline" &&
		sudo systemctl status "$sline";
		echo 'SERVICE ENABLED: ' "$sline"
		clear;
	done < ./.stmp

	clear;
	sudo ufw enable &&
	sudo ufw status;
	sleep 1s &&
	clear;
	sudo service ssh restart &&
	echo "SSH Service Restarted..."

}

dx_netdata() {
	echo 'SCRIPT IS FINISHED...'
	echo 'WILL ATTEMPT TO INSTALL NETDATA MONITORING WHICH IS SUPER DOPE YOU WILL DIG IT'
	sleep 3s
	echo 'SO DOING THAT NOW...BUT IF IT FAILS WHATEVER EVERYTHING IS DONE SO...'
	sleep 1s
	echo 'Ya Know...'
	sleep 2s
	echo 'Know what I am sayyin...'
	sleep 1s
	echo 'K.'
	sleep 1s
	echo 'yeah.'
	sleep 1s
	clear
        echo 'INSTALLING NETDATA - A LIGHTWEIGHT GRAPHICAL MONITORING TOOL WITH WEB UI DASHBOARD'
        sleep 3s &&
        bash <(curl -Ss https://my-netdata.io/kickstart.sh)
}

dx_update &&
dx_locale &&
dx_pkg &&
dx_ufw &&
dx_opr &&
dx_services &&
sudo dx_netdata;
clear &&
sleep 3s
toilet 'fuck you johnny'

> ``
