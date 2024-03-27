control 'VCST-80-000141' do
  title 'The vCenter STS service example applications must be removed.'
  desc  'Tomcat provides example applications, documentation, and other directories in the default installation that do not serve a production use. These files must be deleted.'
  desc  'rationale', ''
  desc  'check', "
    At the command prompt, run the following command:

    # ls -l /var/opt/apache-tomcat/webapps/examples

    If the examples folder exists or contains any content, this is a finding.
  "
  desc 'fix', "
    At the command prompt, run the following command:

    # rm -rf /var/opt/apache-tomcat/webapps/examples
  "
  impact 0.5
  tag severity: 'medium'
  tag gtitle: 'SRG-APP-000141-AS-000095'
  tag gid: 'V-VCST-80-000141'
  tag rid: 'SV-VCST-80-000141'
  tag stig_id: 'VCST-80-000141'
  tag cci: ['CCI-000381']
  tag nist: ['CM-7 a']

  # Make sure the examples directory does not exist
  describe directory("#{input('tcCore')}/webapps/examples").exist? do
    it { should cmp 'false' }
  end
end
