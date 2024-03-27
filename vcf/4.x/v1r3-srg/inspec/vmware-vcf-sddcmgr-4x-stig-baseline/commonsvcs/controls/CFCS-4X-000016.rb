control 'CFCS-4X-000016' do
  title 'The SDDC Manager Common Services service must not enable debug information to be displayed.'
  desc  'Information needed by an attacker to begin looking for possible vulnerabilities in a web server includes any information about the web server and plug-ins or modules being used. When debugging or trace information is enabled in a production web server, information about the web server, such as web server type, version, patches installed, plug-ins and modules installed, type of code being used by the hosted application, and any backends being used for data storage may be displayed. Since this information may be placed in logs and general messages during normal operation of the web server, an attacker does not need to cause an error condition to gain this information.'
  desc  'rationale', ''
  desc  'check', "
    At the command prompt, run the following command:

    # grep server.servlet.jsp.init-parameters.debug /opt/vmware/vcf/commonsvcs/conf/application-prod.properties

    Expected result:

    server.servlet.jsp.init-parameters.debug=0

    If the output does not match the expected result or is commented out, this is a finding.
  "
  desc 'fix', "
    Navigate to and open:

    /opt/vmware/vcf/commonsvcs/conf/application-prod.properties

    Add or edit the following line to match below:

    server.servlet.jsp.init-parameters.debug=0

    Restart the service for the setting to take effect.

    # systemctl restart commonsvcs.service
  "
  impact 0.5
  tag severity: 'medium'
  tag gtitle: 'SRG-APP-000266-WSR-000160'
  tag gid: nil
  tag rid: nil
  tag stig_id: 'CFCS-4X-000016'
  tag cci: ['CCI-001312']
  tag nist: ['SI-11 a']

  describe parse_config_file(input('applicationProdPropertiesPath')) do
    its(['server.servlet.jsp.init-parameters.debug']) { should cmp '0' }
  end
end
