control 'VCLD-80-000019' do
  title 'The vCenter VAMI service log files must only be accessible by privileged users.'
  desc  "
    Log data is essential in the investigation of events. If log data were to become compromised, then competent forensic analysis and discovery of the true source of potentially malicious system activity would be difficult, if not impossible, to achieve. In addition, access to log records provides information an attacker could potentially use to their advantage since each event record might contain communication ports, protocols, services, trust relationships, user names, etc.

    The web server must protect the log data from unauthorized read, write, copy, etc. This can be done by the web server if the web server is also doing the logging function. The web server may also use an external log system. In either case, the logs must be protected from access by non-privileged users.
  "
  desc  'rationale', ''
  desc  'check', "
    At the command prompt, run the following commands:

    # find /var/log/vmware/applmgmt/ /var/log/vmware/applmgmt-audit/ -xdev -type f -a '(' -perm -o+w -o -not -user root -o -not -group root ')' -exec ls -ld {} \\;
    # find /opt/vmware/var/log/lighttpd/ -xdev -type f -a '(' -perm -o+w -o -not -user lighttpd -o -not -group lighttpd ')' -exec ls -ld {} \\;

    If any files are returned, this is a finding.
  "
  desc 'fix', "
    At the command prompt, run the following commands for log files under /opt/vmware/var/log/lighttpd/:

    # chmod o-w <file>
    # chown lighttpd:lighttpd <file>

    At the command prompt, run the following commands for all other log files:

    # chmod o-w <file>
    # chown root:root <file>

    Note: Substitute <file> with the listed file.
  "
  impact 0.5
  tag severity: 'medium'
  tag gtitle: 'SRG-APP-000118-WSR-000068'
  tag satisfies: ['SRG-APP-000119-WSR-000069', 'SRG-APP-000120-WSR-000070']
  tag gid: 'V-VCLD-80-000019'
  tag rid: 'SV-VCLD-80-000019'
  tag stig_id: 'VCLD-80-000019'
  tag cci: ['CCI-000162', 'CCI-000163', 'CCI-000164']
  tag nist: ['AU-9']

  command('find /var/log/vmware/applmgmt/ -type f -xdev').stdout.split.each do |fname|
    describe file(fname) do
      it { should_not be_writable.by('others') }
      its('owner') { should eq 'root' }
      its('group') { should eq 'root' }
    end
  end
  command('find /var/log/vmware/applmgmt-audit/ -type f -xdev').stdout.split.each do |fname|
    describe file(fname) do
      it { should_not be_writable.by('others') }
      its('owner') { should eq 'root' }
      its('group') { should eq 'root' }
    end
  end
  command('find /opt/vmware/var/log/lighttpd/ -type f -xdev').stdout.split.each do |fname|
    describe file(fname) do
      it { should_not be_writable.by('others') }
      its('owner') { should eq 'lighttpd' }
      its('group') { should eq 'lighttpd' }
    end
  end
end
