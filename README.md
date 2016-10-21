# Zabbix Speedtest template

## Installation

- Copy `speedtest.sh` to `/etc/zabbix/bin`: `cp speedtest.sh /etc/zabbix/bin`
- Make it executable: `chmod +x /etc/zabbix/bin/speedtest.sh`
- Install the systemd service and timer:
`cp speedtest.service speedtest.timer /etc/systemd/system`
- Start and enable the timer: `systemctl enable --now speedtest.timer`
- Import the zabbix-agent config:
`cp speedtest.conf /etc/zabbix/zabbix_agentd.conf.d`
- Import the `zbx_export_templates.xml` on your Zabbix server
