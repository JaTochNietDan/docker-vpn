# Docker OpenVPN container
Allows you to connect a Docker container to a VPN for the purposes of tunneling connections of your choice through it.

## Setup

### Docker-Compose
```yaml
openvpnus:
  image: dperson/openvpn-client
  container_name: openvpnus
  cap_add:
    - NET_ADMIN
  devices:
    - /dev/net/tun:/dev/net/tun
  volumes:
    - ../us.ovpn:/vpn/vpn.conf
  dns:
    - 8.8.8.8
    - 8.8.4.4
  ports: 
    - 1340:1080
    - "1401:22"
    - "3129:3128"
    - "2346:2346"
vpnus:
  image: jatochnietdan/docker-vpn
  container_name: vpnus
  volumes:
    - ../us.ovpn:/home/config.ovpn
    - ~/.kube:/root/.kube
    - ../script.sh:/home/script.sh
  cap_add:
    - NET_ADMIN
  devices:
    - /dev/net/tun:/dev/net/tun
  network_mode: container:openvpnus
  depends_on:
    - openvpnus
```

Then you can tunnel through SSH using `root:test` user on port `1400` and there's a SOCKS5 proxy available at port `1339` with no login
through which you can set one of your browsers to route (I use Firefox).
