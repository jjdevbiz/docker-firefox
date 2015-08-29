# Firefox over ssh X11Forwarding

FROM	debian:stable

ENV FF 40.0.3
ENV EXTDIR /home/docker/.mozilla/extensions

# make sure the package repository is up to date
# and blindly upgrade all packages
RUN	apt-get update
RUN	apt-get upgrade -y

# install ssh and iceweasel
RUN	apt-get install -y openssh-server iceweasel

# install pulseaudio to forward sound server to local session using paprefs
RUN apt-get install -y pulseaudio

# various utils that aid in getting firefox installed
RUN apt-get install -y curl wget xz-utils bzip2 unzip

# Create user "docker" and set the password to "docker"
RUN useradd -m -d /home/docker docker
RUN echo "docker:docker" | chpasswd

# Prepare ssh config folder
RUN mkdir -p /home/docker/.ssh
RUN chown -R docker:docker /home/docker
RUN chown -R docker:docker /home/docker/.ssh

# grab the latest firefox, flash and privacytools.io encouraged plugins
WORKDIR /home/docker
RUN wget https://download-installer.cdn.mozilla.net/pub/firefox/releases/${FF}/linux-x86_64/en-US/firefox-${FF}.tar.bz2
# RUN wget https://fpdownload.adobe.com/get/flashplayer/pdc/${FLASHVER}/install_flash_player_11_linux.x86_64.tar.gz

# install addons globally
WORKDIR /home/docker
RUN wget https://addons.mozilla.org/firefox/downloads/latest/464050/addon-464050-latest.xpi
RUN wget https://addons.mozilla.org/firefox/downloads/file/319372/ublock_origin-0.9.8.2-an+sm+fx.xpi
RUN wget https://addons.mozilla.org/firefox/downloads/latest/473878/addon-473878-latest.xpi
RUN wget https://www.eff.org/files/https-everywhere-latest.xpi
RUN wget https://s.eff.org/files/privacy-badger-latest.xpi

# !! Removed flash from build, because its a POS that needs to be retired from use !!
# install flash
#RUN \
#tar xvf install_flash_player_11_linux.x86_64.tar.gz && \
#cp -av usr / && \
#mkdir -p /home/docker/.mozilla/plugins && \
#cp libflashplayer.so /home/docker/.mozilla/plugins

# get firefox setup
RUN tar xvf firefox-${FF}.tar.bz2;

# install addons globally
#WORKDIR /home/docker
#RUN mkdir -p ${EXTDIR}/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}
#RUN mkdir -p /home/docker/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}
# random agent spoofer
#RUN wget https://addons.mozilla.org/firefox/downloads/latest/473878/addon-473878-latest.xpi
#RUN mkdir -p ${EXTDIR}/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/jid1-AVgCeF1zoVzMjA@jetpack
#RUN unzip addon-473878-latest.xpi -d /home/docker/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/jid1-AVgCeF1zoVzMjA@jetpack
# disconnect
#RUN wget https://addons.mozilla.org/firefox/downloads/latest/464050/addon-464050-latest.xpi
#RUN mkdir ${EXTDIR}/2.0@disconnect.me
#RUN unzip addon-464050-latest.xpi -d /home/docker/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/2.0@disconnect.me
# ublock
#RUN wget https://addons.mozilla.org/firefox/downloads/file/319372/ublock_origin-0.9.8.2-an+sm+fx.xpi
#RUN mkdir ${EXTDIR}/uBlock0@raymondhill.net
#RUN unzip ublock_origin-0.9.8.2-an+sm+fx.xpi -d /home/docker/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/uBlock0@raymondhill.net
# httpd everywhere
#RUN wget https://www.eff.org/files/https-everywhere-latest.xpi
#RUN mkdir ${EXTDIR}/https-everywhere@eff.org
#RUN unzip https-everywhere-latest.xpi -d /home/docker/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/https-everywhere@eff.org
# privacy badger
#RUN wget https://s.eff.org/files/privacy-badger-latest.xpi
#RUN mkdir ${EXTDIR}/jid1-MnnxcxisBPnSXQ@jetpack
#unzip privacy-badger-latest.xpi -d /home/docker/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/jid1-MnnxcxisBPnSXQ@jetpack

# Create OpenSSH privilege separation directory, enable X11Forwarding
RUN mkdir -p /var/run/sshd
RUN echo X11Forwarding yes >> /etc/ssh/ssh_config

# Expose the SSH port
EXPOSE 22

# Start SSH
ENTRYPOINT ["/usr/sbin/sshd",  "-D"]
