control 'PHTN-40-000012' do
  title 'The Photon operating system must monitor remote access logins.'
  desc 'Remote access services, such as those providing remote access to network devices and information systems, which lack automated monitoring capabilities, increase risk and make remote user access management difficult at best. Remote access is access to DOD nonpublic information systems by an authorized user (or an information system) communicating through an external, nonorganization-controlled network. Remote access methods include, for example, dial-up, broadband, and wireless. Automated monitoring of remote access sessions allows organizations to detect cyberattacks and also ensure ongoing compliance with remote access policies by auditing connection activities of remote access capabilities, such as Remote Desktop Protocol (RDP), on a variety of information system components (e.g., servers, workstations, notebook computers, smartphones, and tablets).'
  desc 'check', 'If another package is used to offload logs, such as syslog-ng, and is properly configured, this is not applicable.

At the command line, run the following command to verify rsyslog is configured to log authentication requests:

# grep -E "(^auth.*|^authpriv.*|^daemon.*)" /etc/rsyslog.conf

Example result:

auth.*;authpriv.*;daemon.* /var/log/audit/sshinfo.log

If "auth.*", "authpriv.*", and "daemon.*" are not configured to be logged, this is a finding.'
  desc 'fix', 'Navigate to and open:

/etc/rsyslog.conf

Add or update the following line:

auth.*;authpriv.*;daemon.* /var/log/audit/sshinfo.log

Note: The path can be substituted for another suitable log destination dedicated to authentication logs.

At the command line, run the following command:

# systemctl restart rsyslog.service'
  impact 0.5
  tag check_id: 'C-62545r933474_chk'
  tag severity: 'medium'
  tag gid: 'V-258805'
  tag rid: 'SV-258805r958406_rule'
  tag stig_id: 'PHTN-40-000012'
  tag gtitle: 'SRG-OS-000032-GPOS-00013'
  tag fix_id: 'F-62454r933475_fix'
  tag cci: ['CCI-000067']
  tag nist: ['AC-17 (1)']

  describe command('grep -E "(^auth.*|^authpriv.*|^daemon.*)" /etc/rsyslog.conf') do
    its('stdout.strip') { should match /auth\.\*;authpriv\.\*;daemon\.\*[\s]*#{input('authprivlog')}/ }
  end
end
