Example:

```yaml
  openvpn:
    image: jatochnietdan/docker-vpn
    volumes:
      - ../config.ovpn:/home/config.ovpn
    ports: 
      - 1339:1080
    cap_add:
      - NET_ADMIN
    dns:
      - 8.8.8.8
      - 8.8.4.4
    devices:
      - /dev/net/tun:/dev/net/tun
```