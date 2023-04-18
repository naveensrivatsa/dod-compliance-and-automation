control 'VCPF-80-000005' do
  title 'The vCenter Perfcharts service cookies must have secure flag set.'
  desc  "
    The secure flag is an option that can be set by the application server when sending a new cookie to the user within an HTTP Response. The purpose of the secure flag is to prevent cookies from being observed by unauthorized parties due to the transmission of a cookie in clear text.

    By setting the secure flag, the browser will prevent the transmission of a cookie over an unencrypted channel.
  "
  desc  'rationale', ''
  desc  'check', "
    At the command prompt, run the following command:

    # xmllint --format /usr/lib/vmware-perfcharts/tc-instance/webapps/statsreport/WEB-INF/web.xml | sed 's/xmlns=\".*\"//g' | xmllint --xpath '/web-app/session-config/cookie-config/secure' -

    Expected result:

    <secure>true</secure>

    If the output of the command does not match the expected result, this is a finding.
  "
  desc 'fix', "
    Navigate to and open:

    /usr/lib/vmware-perfcharts/tc-instance/webapps/statsreport/WEB-INF/web.xml

    Navigate to the <session-config> node and configure the <secure> setting as follows:

    <session-config>
      <session-timeout>6</session-timeout>
      <cookie-config>
          <http-only>true</http-only>
          <secure>true</secure>
      </cookie-config>
    </session-config>

    Restart the service with the following command:

    # vmon-cli --restart perfcharts
  "
  impact 0.5
  tag severity: 'medium'
  tag gtitle: 'SRG-APP-000033-AS-000024'
  tag gid: 'V-VCPF-80-000005'
  tag rid: 'SV-VCPF-80-000005'
  tag stig_id: 'VCPF-80-000005'
  tag cci: ['CCI-000213']
  tag nist: ['AC-3']

  # Open web.xml
  xmlconf = xml(input('webXmlPath'))

  # find the cookie-config/secure value
  describe xmlconf['//session-config/cookie-config/secure'] do
    it { should eq ['true'] }
  end
end
