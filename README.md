# Firefox Browser - Docker Project #

The purpose of this project is to provide an image for web
browsing safely inside a container so as to add an additional sandbox.

# Build from Dockerfile #

```
docker build -t firefox .
docker run -d -p 55556:22 --restart=always --name=firefox firefox
```

## Start ##

* *~/.ssh/config entry for easy ssh*
```
Host docker-tor
  User      docker
  Port      55556
  HostName  127.0.0.1
  RemoteForward 64713 localhost:4713
  ForwardX11 yes
```
* ssh into container and run binary
```
ssh docker-ff_shared 'cd firefox; ./firefox'"
```
* use a script or tmux line to start a session in a daemonized fashion + pulseaudio for sound!
```
tmux new -s firefox_docker -d "sshpass -p 'docker' ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no docker-ff_shared 'pulseaudio --start && export PULSE_SERVER=tcp:localhost:64713 && cd firefox; ./firefox'"
```
