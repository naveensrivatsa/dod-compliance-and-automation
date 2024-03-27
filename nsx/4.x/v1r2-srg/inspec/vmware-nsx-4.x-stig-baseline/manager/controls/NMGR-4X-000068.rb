control 'NMGR-4X-000068' do
  title 'The NSX Manager must record time stamps for audit records that can be mapped to Coordinated Universal Time (UTC).'
  desc  "
    If time stamps are not consistently applied and there is no common time reference, it is difficult to perform forensic analysis.

    Time stamps generated by the application include date and time. Time is commonly expressed in Coordinated Universal Time (UTC), a modern continuation of Greenwich Mean Time (GMT), or local time with an offset from UTC.
  "
  desc  'rationale', ''
  desc  'check', "
    From the NSX Manager web interface, go to System >> Configuration >> Fabric >> Profiles >> Node Profiles.

    Click \"All NSX Nodes\" and verify the time zone.

    or

    From an NSX Manager shell, run the following command:

    > get clock

    If system clock is not configured with the UTC time zone, this is a finding.

    Note: This check must be run from each NSX Manager as they are configured individually if done from the command line.
  "
  desc 'fix', "
    To configure a profile to apply a time zone to all NSX Manager nodes, do the following:

    From the NSX Manager web interface, go to System >> Configuration >> Fabric >> Profiles >> Node Profiles.

    Click \"All NSX Nodes\", and then click \"Edit\".

    In the time zone drop-down list, select \"UTC\", and then click \"Save\".

    or

    From an NSX Manager shell, run the following command:

    > set timezone UTC

    Note: This fix must be run from each NSX Manager as they are configured individually if done from the command line.
  "
  impact 0.5
  tag severity: 'medium'
  tag gtitle: 'SRG-APP-000374-NDM-000299'
  tag gid: 'V-NMGR-4X-000068'
  tag rid: 'SV-NMGR-4X-000068'
  tag stig_id: 'NMGR-4X-000068'
  tag cci: ['CCI-001890']
  tag nist: ['AU-8 b']

  result = http("https://#{input('nsxManager')}/api/v1/node",
                method: 'GET',
                headers: {
                  'Accept' => 'application/json',
                  'X-XSRF-TOKEN' => "#{input('sessionToken')}",
                  'Cookie' => "#{input('sessionCookieId')}"
                },
                ssl_verify: false)

  describe result do
    its('status') { should cmp 200 }
  end
  unless result.status != 200
    describe.one do
      describe json(content: result.body) do
        its('timezone') { should cmp 'UTC' }
      end
      describe json(content: result.body) do
        its('timezone') { should cmp 'Etc/UTC' }
      end
    end
  end
end
