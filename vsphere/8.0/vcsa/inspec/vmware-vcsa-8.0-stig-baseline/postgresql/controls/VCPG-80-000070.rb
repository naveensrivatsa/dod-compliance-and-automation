control 'VCPG-80-000070' do
  title 'The vCenter PostgreSQL service must have log collection enabled.'
  desc  "
    Without the ability to centrally manage the content captured in the audit records, identification, troubleshooting, and correlation of suspicious behavior would be difficult and could lead to a delayed or incomplete analysis of an ongoing attack.

    The content captured in audit records must be managed from a central location (necessitating automation). Centralized management of audit records and logs provides for efficiency in maintenance and management of records, as well as the backup and archiving of those records.
  "
  desc  'rationale', ''
  desc  'check', "
    At the command prompt, run the following command:

    # /opt/vmware/vpostgres/current/bin/psql -U postgres -A -t -c \"SHOW logging_collector;\"

    Expected result:

    on

    If the output does not match the expected result, this is a finding.
  "
  desc 'fix', "
    A script is included with vCenter to generate a PostgreSQL STIG configuration.

    At the command prompt, run the following commands:

    # chmod +x /opt/vmware/vpostgres/current/bin/vmw_vpg_config/vmw_vpg_config.py
    # /opt/vmware/vpostgres/current/bin/vmw_vpg_config/vmw_vpg_config.py --action stig_enable --pg-data-dir /storage/db/vpostgres
    # chmod -x /opt/vmware/vpostgres/current/bin/vmw_vpg_config/vmw_vpg_config.py

    Restart the PostgreSQL service by running the following command:

    # vmon-cli --restart vmware-vpostgres
  "
  impact 0.5
  tag severity: 'medium'
  tag gtitle: 'SRG-APP-000356-DB-000314'
  tag satisfies: ['SRG-APP-000381-DB-000361']
  tag gid: 'V-VCPG-80-000070'
  tag rid: 'SV-VCPG-80-000070'
  tag stig_id: 'VCPG-80-000070'
  tag cci: ['CCI-001814', 'CCI-001844']
  tag nist: ['AU-3 (2)', 'CM-5 (1)']

  sql = postgres_session("#{input('postgres_user')}", "#{input('postgres_pass')}", "#{input('postgres_host')}")

  describe sql.query('SHOW logging_collector;', ["#{input('postgres_default_db')}"]) do
    its('output') { should cmp 'on' }
  end
end
