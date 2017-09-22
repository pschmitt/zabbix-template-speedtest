# Zabbix Speedtest template

## Installation (Generic x86_64)

- Copy the speedtest binary (`bin/speedtest-linux-amd64`) and `speedtest.sh` to `/etc/zabbix/bin`
- Make them both executable: `chmod +x /etc/zabbix/bin/speedtest /etc/zabbix/bin/speedtest.sh`
- Install the systemd service and timer: `cp speedtest.service speedtest.timer /etc/systemd/system`
- Start and enable the timer: `systemctl enable --now speedtest.timer`
- Import the zabbix-agent config: `cp speedtest.conf /etc/zabbix/zabbix_agentd.conf.d`
- Restart zabbix-agent: `sudo systemctl restart zabbix-agent`
- Import `template_speedtest.xml` on your Zabbix server

## Installation (OpenWRT)

- Copy the speedtest binary (`bin/speedtest-linux-arm-static`) and `speedtest.sh` to `/etc/zabbix_agentd.conf.d/bin`
- Make them both executable: `chmod +x /etc/zabbix_agentd.conf.d/bin/speedtest /etc/zabbix_agentd.conf.d/bin/speedtest.sh`
- Import the zabbix-agent config: `cp speedtest.conf /etc/zabbix_agentd.conf.d`
- Restart zabbix-agent: `/etc/init.d/zabbix-agentd restart`
- Install the cron job: `crontab -e` -> Add the content of `speedtest.crontab`
- Import `template_speedtest.xml` on your Zabbix server
