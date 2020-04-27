Example:

```yaml
  openvpn:
    image: jatochnietdan/docker-vpn
    volumes:
      - ../config.ovpn:/home/config.ovpn
    ports: 
      - 1339:1080
      - "1400:22"
    cap_add:
      - NET_ADMIN
    dns:
      - 8.8.8.8
      - 8.8.4.4
    devices:
      - /dev/net/tun:/dev/net/tun
```

Then you can tunnel through SSH using `root:test` user on port `1400` and there's a SOCKS5 proxy available at port `1339` with no login
through which you can set one of your browsers to route (I use Firefox).