# Zabbix Speedtest template

## Installation (Generic x86_64)

- Install [speedtest-cli](https://www.speedtest.net/apps/cli)
- Make them both executable: `chmod +x /etc/zabbix/bin/speedtest /etc/zabbix/bin/speedtest.sh`
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
