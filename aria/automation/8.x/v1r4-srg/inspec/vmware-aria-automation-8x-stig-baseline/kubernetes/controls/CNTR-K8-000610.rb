control 'CNTR-K8-000610' do
  title 'The Kubernetes API Server must have an audit log path set.'
  desc 'When Kubernetes is started, components and user services are started for auditing startup events, and events for components and services, it is important that auditing begin on startup. Within Kubernetes, audit data for all components is generated by the API server. To enable auditing to begin, an audit policy must be defined for the events and the information to be stored with each event. It is also necessary to give a secure location where the audit logs are to be stored. If an audit log path is not specified, all audit data is sent to studio.'
  desc 'check', "Change to the /etc/kubernetes/manifests directory on the Kubernetes Control Plane. Run the command:
grep -i audit-log-path *

If the audit-log-path is not set, this is a finding."
  desc 'fix', "Edit the Kubernetes API Server manifest and set \"--audit-log-path\" to a secure location for the audit logs to be written.

Note: If the API server is running as a Pod, then the manifest will also need to be updated to mount the host system filesystem where the audit log file is to be written."
  impact 0.5
  tag severity: 'medium'
  tag gtitle: 'SRG-APP-000092-CTR-000165'
  tag gid: 'V-242402'
  tag rid: 'SV-242402r863978_rule'
  tag stig_id: 'CNTR-K8-000610'
  tag fix_id: 'F-45635r863805_fix'
  tag cci: ['CCI-001464']
  tag nist: ['AU-14 (1)']

  unless kube_apiserver.exist?
    impact 0.0
    desc 'caveat', 'Kubernetes API Server process is not running on the target.'
  end

  describe kube_apiserver do
    its('audit-log-path') { should_not be_nil }
  end
end
