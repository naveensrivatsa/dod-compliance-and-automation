control 'VCLD-80-000102' do
  title 'The vCenter VAMI service must enable Content Security Policy.'
  desc  'A Content Security Policy (CSP) requires careful tuning and precise definition of the policy. If enabled, CSP has significant impact on the way browsers render pages (e.g., inline JavaScript is disabled by default and must be explicitly allowed in the policy). CSP prevents a wide range of attacks, including cross-site scripting and other cross-site injections.'
  desc  'rationale', ''
  desc  'check', "
    At the command prompt, run the following command:

    # /opt/vmware/sbin/vami-lighttpd -p -f /opt/vmware/etc/lighttpd/lighttpd.conf 2>/dev/null|awk '/setenv\\.add-response-header/,/\\)/'|sed -e 's/^[ ]*//'|grep \"Content-Security-Policy\"

    Expected result:

    \"Content-Security-Policy\"   => \"default-src 'self'; img-src 'self' data: https://vcsa.vmware.com; font-src 'self' data:; object-src 'none'; style-src 'self' 'unsafe-inline'\",

    If the output does not match the expected result, this is a finding.

    Note: The command must be run from a bash shell and not from a shell generated by the \"appliance shell\". Use the \"chsh\" command to change the shell for the account to \"/bin/bash\". Refer to KB Article 2100508 for more details:

    https://kb.vmware.com/s/article/2100508
  "
  desc 'fix', "
    Navigate to and open:

    /etc/applmgmt/appliance/lighttpd.conf

    Locate the \"setenv.add-response-header\" parameter and add or update the following value:

    \"Content-Security-Policy\"   => \"default-src 'self'; img-src 'self' data: https://vcsa.vmware.com; font-src 'self' data:; object-src 'none'; style-src 'self' 'unsafe-inline'\",

    Note: The last line in the parameter does not need a trailing comma.

    Restart the service with the following command:

    # vmon-cli --restart applmgmt
  "
  impact 0.5
  tag severity: 'medium'
  tag gtitle: 'SRG-APP-000516-WSR-000174'
  tag gid: 'V-VCLD-80-000102'
  tag rid: 'SV-VCLD-80-000102'
  tag stig_id: 'VCLD-80-000102'
  tag cci: ['CCI-000366']
  tag nist: ['CM-6 b']

  describe command("#{input('lighttpdBin')} -p -f #{input('lighttpdConf')} 2>/dev/null|awk '/setenv\.add-response-header/,/\)/'|sed -e 's/^[ ]*//'|grep Content-Security-Policy") do
    its('stdout.strip') { should cmp '"Content-Security-Policy"   => "default-src \'self\'; img-src \'self\' data: https://vcsa.vmware.com; font-src \'self\' data:; object-src \'none\'; style-src \'self\' \'unsafe-inline\'",' }
  end
end
