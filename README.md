# Zabbix Speedtest template

## Installation (Generic x86_64)

- Install [speedtest-cli](https://www.speedtest.net/apps/cli)
- Copy `speedtest.sh` to `/etc/zabbix/bin`
- Make it executable: `chmod +x /etc/zabbix/bin/speedtest.sh`
- Install the systemd service and timer: `cp speedtest.service speedtest.timer /etc/systemd/system`
- Start and enable the timer: `systemctl enable --now speedtest.timer`
- Import the zabbix-agent config: `cp speedtest.conf /etc/zabbix/zabbix_agentd.conf.d`
- Restart zabbix-agent: `sudo systemctl restart zabbix-agent`
- Import `template_speedtest.xml` on your Zabbix server

## Installation (OpenWRT)

- Install [speedtest-cli](https://www.speedtest.net/apps/cli) by placing the binary in your `$PATH`
- Copy `speedtest.sh` to `/etc/zabbix_agentd.conf.d/bin`
- Make it executable: `chmod +x /etc/zabbix_agentd.conf.d/bin/speedtest.sh`
- Import the zabbix-agent config: `cp speedtest.openwrt.conf /etc/zabbix_agentd.conf.d`
- Restart zabbix-agent: `/etc/init.d/zabbix-agentd restart`
- Install the cron job: `crontab -e` -> Add the content of `speedtest.crontab`
- Import `template_speedtest.xml` on your Zabbix server

## Installation (Docker)

###  Speedtest in a container

Check out pschmitt/speedtest:cron on [Docker Hub](https://hub.docker.com/repository/docker/pschmitt/speedtest/general) ([GitHub](https://github.com/pschmitt/docker-ookla-speedtest-cli))

### Zabbix-agent 

- You must mount `speedtest.sh` inside your zabbix-agent container
- It also needs to have access to speedtest data volume

Below is an example `docker-compose.yaml`.

**NOTE:** pschmitt/zabbix-agent2 contains jq which is required by `speedtest.sh`.

```yaml
---
version: "3.7"
services:
  speedtest:
    image: pschmitt/speedtest:cron
    volumes:
      - "./data/speedtest:/data"
    environment:
      - INTERVAL=300

  zabbix-agent:
    image: pschmitt/zabbix-agent2:latest
    restart: unless-stopped
    hostname: ${HOSTNAME}
    privileged: true
    network_mode: host
    pid: host
    volumes:
      - "./config/bin:/etc/zabbix/bin:ro"
      - "./config/zabbix_agentd.d:/etc/zabbix/zabbix_agentd.d:ro"
      - "./data/speedtest:/data/speedtest:ro"
    environment:
      - ZBX_HOSTNAMEITEM=system.hostname
      - ZBX_SERVER_HOST=zabbix.example.com
```

# vim: set ft=markdown et ts=2 sw=2 :
