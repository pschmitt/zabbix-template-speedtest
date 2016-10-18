# Zabbix Speedtest template

## Installation

- Copy `speedtest.sh` to `/usr/bin`: `cp speedtest.sh /usr/bin`
- Make it executable: `chmod +x /usr/bin/speedtest.sh`
- Install the systemd service and timer:
`cp speedtest.service speedtest.timer /etc/systemd/system`
- Enable the timer: `systemctl enable --now speedtest.timer`
- Import the zabbix-agent config:
`cp speedtest.conf /etc/zabbix/zabbix_agentd.conf.d`
- Import the `zbx_export_templates.xml` on your Zabbix server
