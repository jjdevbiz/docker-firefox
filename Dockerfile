# Firefox over VNC
#
# VERSION               0.1
# DOCKER-VERSION        0.2

FROM	debian:latest
# make sure the package repository is up to date

RUN	apt-get update

# Install vnc, xvfb in order to create a 'fake' display and firefox
RUN	apt-get install -y openssh-server iceweasel

#RUN wget https://download-installer.cdn.mozilla.net/pub/firefox/releases/38.0.1/linux-x86_64/en-US/firefox-38.0.1.tar.bz2

# Create user "docker" and set the password to "docker"
RUN useradd -m -d /home/docker docker
RUN echo "docker:docker" | chpasswd

# Create OpenSSH privilege separation directory, enable X11Forwarding
RUN mkdir -p /var/run/sshd
RUN echo X11Forwarding yes >> /etc/ssh/ssh_config

# Prepare ssh config folder so we can upload SSH public key later
RUN mkdir /home/docker/.ssh
RUN chown -R docker:docker /home/docker
RUN chown -R docker:docker /home/docker/.ssh

# Set locale (fix locale warnings)
# RUN localedef -v -c -i en_US -f UTF-8 en_US.UTF-8 || true

# Expose the SSH port
EXPOSE 22

# Start SSH
ENTRYPOINT ["/usr/sbin/sshd",  "-D"]
