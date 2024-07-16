control 'VCLD-80-000001' do
  title 'The vCenter VAMI service must limit the number of allowed simultaneous session requests.'
  desc 'Denial of service (DoS) is one threat against web servers. Many DoS attacks attempt to consume web server resources in such a way that no more resources are available to satisfy legitimate requests. Mitigation against these threats is to take steps to limit the number of resources that can be consumed in certain ways.

  VAMI provides the "maxConnections" attribute of the <Connector Elements> to limit the number of concurrent Transmission Control Protocol (TCP) connections. This comes preconfigured with a tested, supported value that must be verified and maintained.'
  desc 'check', 'At the command prompt, run the following command:

# /opt/vmware/cap_lighttpd/sbin/lighttpd -p -f /var/lib/vmware/cap-lighttpd/lighttpd.conf 2>/dev/null |grep "server.max-connections"

Example result:

server.max-connections = 1024

If "server.max-connections" is not configured to 1024 or less, this is a finding.

Note: The command must be run from a bash shell and not from a shell generated by the "appliance shell". Use the "chsh" command to change the shell for the account to "/bin/bash". Refer to KB Article 2100508 for more details:

https://kb.vmware.com/s/article/2100508'
  desc 'fix', 'Navigate to and open:

/var/lib/vmware/cap-lighttpd/lighttpd.conf

Add or reconfigure the following value:

server.max-connections = 1024

Restart the service with the following command:

# systemctl restart cap-lighttpd'
  impact 0.5
  tag check_id: 'C-62877r1003683_chk'
  tag severity: 'medium'
  tag gid: 'V-259137'
  tag rid: 'SV-259137r1003685_rule'
  tag stig_id: 'VCLD-80-000001'
  tag gtitle: 'SRG-APP-000001-WSR-000001'
  tag fix_id: 'F-62786r1003684_fix'
  tag cci: ['CCI-000054']
  tag nist: ['AC-10']

  runtime = command("#{input('lighttpdBin')} -p -f #{input('lighttpdConf')}").stdout

  describe parse_config(runtime).params['server.max-connections'] do
    it { should cmp <= 1024 }
  end
end
