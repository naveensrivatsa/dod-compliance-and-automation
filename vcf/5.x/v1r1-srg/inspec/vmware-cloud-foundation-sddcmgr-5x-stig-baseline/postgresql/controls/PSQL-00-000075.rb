control 'PSQL-00-000075' do
  title 'The SDDC Manager PostgreSQL service must use UTC for log timestamps.'
  desc  "
    If time stamps are not consistently applied and there is no common time reference, it is difficult to perform forensic analysis.

    Time stamps generated by PostgreSQL must include date and time. Time is commonly expressed in Coordinated Universal Time (UTC), a modern continuation of Greenwich Mean Time (GMT), or local time with an offset from UTC.
  "
  desc  'rationale', ''
  desc  'check', "
    As a database administrator, perform the following at the command prompt:

    # psql -h localhost -U postgres -A -t -c \"SHOW log_timezone\"

    Expected result:

    UTC

    If the output does not match the expected result, this is a finding.
  "
  desc 'fix', "
    As a database administrator, perform the following at the command prompt:

    # psql -h localhost -U postgres -c \"ALTER SYSTEM SET log_timezone TO 'UTC';\"

    Reload the PostgreSQL service by running the following command:

    # systemctl reload postgres
  "
  impact 0.5
  tag severity: 'medium'
  tag gtitle: 'SRG-APP-000374-DB-000322'
  tag gid: 'V-PSQL-00-000075'
  tag rid: 'SV-PSQL-00-000075'
  tag stig_id: 'PSQL-00-000075'
  tag cci: ['CCI-001890']
  tag nist: ['AU-8 b']

  sql = postgres_session("#{input('postgres_user')}", "#{input('postgres_pass')}", "#{input('postgres_host')}")

  describe sql.query('SHOW log_timezone;', ["#{input('postgres_default_db')}"]) do
    its('output') { should cmp 'UTC' }
  end
end
