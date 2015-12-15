# Firefox over ssh X11Forwarding

FROM debian:stable

ENV FF 43.0
ENV EXTDIR /home/docker/.mozilla/extensions

# Set default locale for the environment
ENV LC_ALL C.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

# make sure the package repository is up to date
# and blindly upgrade all packages
RUN apt-get update
RUN apt-get upgrade -y -qq

# install ssh and iceweasel
RUN apt-get install -y openssh-server iceweasel

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

# grab the latest firefox
WORKDIR /home/docker
RUN wget https://download-installer.cdn.mozilla.net/pub/firefox/releases/${FF}/linux-x86_64/en-US/firefox-${FF}.tar.bz2
RUN wget http://releases.mozilla.org/pub/firefox/releases/${FF}/SHA512SUMS
RUN wget http://releases.mozilla.org/pub/firefox/releases/${FF}/SHA512SUMS.asc
RUN sha256sum -c SHA512SUMS 2>/dev/null | grep firefox-${FF}.tar.bz2

# misc addons
# WORKDIR /home/docker
# RUN wget https://addons.mozilla.org/firefox/downloads/latest/464050/addon-464050-latest.xpi
# RUN wget https://addons.mozilla.org/firefox/downloads/file/319372/ublock_origin-0.9.8.2-an+sm+fx.xpi
# RUN wget https://addons.mozilla.org/firefox/downloads/latest/473878/addon-473878-latest.xpi
# RUN wget https://www.eff.org/files/https-everywhere-latest.xpi
# RUN wget https://s.eff.org/files/privacy-badger-latest.xpi

# get firefox setup
RUN tar xvf firefox-${FF}.tar.bz2;

# Create OpenSSH privilege separation directory, enable X11Forwarding
RUN mkdir -p /var/run/sshd
RUN echo X11Forwarding yes >> /etc/ssh/ssh_config

# Expose the SSH port
EXPOSE 22

# Start SSH
ENTRYPOINT ["/usr/sbin/sshd",  "-D"]
