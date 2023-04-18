control 'VCEM-80-000155' do
  title 'The vCenter ESX Agent Manager service host-manager webapp must be removed.'
  desc  'Tomcat provides host management functionality through either a default host-manager webapp or through local editing of the configuration files. The host-manager webapp files must be deleted, and administration must be performed through the local editing of the configuration files.'
  desc  'rationale', ''
  desc  'check', "
    At the command prompt, run the following command:

    # ls -l /var/opt/apache-tomcat/webapps/host-manager

    If the manager folder exists or contains any content, this is a finding.
  "
  desc 'fix', "
    At the command prompt, run the following command:

    # rm -rf /var/opt/apache-tomcat/webapps/host-manager
  "
  impact 0.5
  tag severity: 'medium'
  tag gtitle: 'SRG-APP-000141-AS-000095'
  tag gid: 'V-VCEM-80-000155'
  tag rid: 'SV-VCEM-80-000155'
  tag stig_id: 'VCEM-80-000155'
  tag cci: ['CCI-000381']
  tag nist: ['CM-7 a']

  # Make sure the host-manager directory does not exist
  describe directory("#{input('tcCore')}/webapps/host-manager").exist? do
    it { should cmp 'false' }
  end
end
