# -*- encoding : utf-8 -*-
control "HZNV-8X-000146" do
  title "The Horizon Connection Server admin interface must display the Standard Mandatory DoD Notice and Consent Banner before granting access to the system."
  desc  "
    Application servers are required to display the Standard Mandatory DoD Notice and Consent Banner before granting access to the system, providing privacy and security notices consistent with applicable federal laws, Executive Orders, directives, policies, regulations, standards, and guidance that states that:
    
    (i) users are accessing a U.S. Government information system;
    (ii) system usage may be monitored, recorded, and subject to audit;
    (iii) unauthorized use of the system is prohibited and subject to criminal and civil penalties; and
    (iv) the use of the system indicates consent to monitoring and recording.
    
    System use notification messages can be implemented in the form of warning banners displayed when individuals log on to the information system.
    
    System use notification is intended only for information system access including an interactive logon interface with a human user, and is not required when an interactive interface does not exist.
    
    Use this banner for desktops, laptops, and other devices accommodating banners of 1300 characters. The banner shall be implemented as a click-through banner at logon (to the extent permitted by the operating system), meaning it prevents further activity on the information system unless and until the user executes a positive action to manifest agreement by clicking on a box indicating \"OK\".
    
    \"You are accessing a U.S. Government (USG) Information System (IS) that is provided for USG-authorized use only.
    By using this IS (which includes any device attached to this IS), you consent to the following conditions:
    -The USG routinely intercepts and monitors communications on this IS for purposes including, but not limited to, penetration testing, COMSEC monitoring, network operations and defense, personnel misconduct (PM), law enforcement (LE), and counterintelligence (CI) investigations.
    -At any time, the USG may inspect and seize data stored on this IS.
    -Communications using, or data stored on, this IS are not private, are subject to routine monitoring, interception, and search, and may be disclosed or used for any USG-authorized purpose.
    -This IS includes security measures (e.g., authentication and access controls) to protect USG interests--not for your personal benefit or privacy.
    -Notwithstanding the above, using this IS does not constitute consent to PM, LE or CI investigative searching or monitoring of the content of privileged communications, or work product, related to personal representation or services by attorneys, psychotherapists, or clergy, and their assistants. Such communications and work product are private and confidential. See User Agreement for details.\"
  "
  desc  "rationale", ""
  desc  "check", "
    Login to the Horizon Connection Server administrative interface as an administrator.
    
    Navigate to Settings >> Global Settings >> General Settings.
    
    Click the \"Edit\" button.
    
    Scroll down to the \"Display a Pre-Login Banner for Horizon Administrator Console\" checkbox.
    
    If \"Display a Pre-Login Banner for Horizon Administrator Console\" is not checked, this is a finding.
    
    If the \"Horizon Administrator Console Pre-Login Banner Message\" field does not contain the Standard Mandatory DoD Notice and Consent Banner text, this is a finding.
  "
  desc  "fix", "
    Login to the Horizon Connection Server administrative interface as an administrator.
    
    Navigate to Settings >> Global Settings >> General Settings.
    
    Click the \"Edit\" button.
    
    Scroll down to the \"Display a Pre-Login Banner for Horizon Administrator Console\" checkbox.
    
    Ensure the box next to \"Display a Pre-Login Banner for Horizon Administrator Console\" is checked.
    
    In the \"Horizon Administrator Console Pre-Login Banner Message\" field, supply the Standard Mandatory DoD Notice and Consent Banner text:
    
    \"You are accessing a U.S. Government (USG) Information System (IS) that is provided for USG-authorized use only.
    By using this IS (which includes any device attached to this IS), you consent to the following conditions:
    -The USG routinely intercepts and monitors communications on this IS for purposes including, but not limited to, penetration testing, COMSEC monitoring, network operations and defense, personnel misconduct (PM), law enforcement (LE), and counterintelligence (CI) investigations.
    -At any time, the USG may inspect and seize data stored on this IS.
    -Communications using, or data stored on, this IS are not private, are subject to routine monitoring, interception, and search, and may be disclosed or used for any USG-authorized purpose.
    -This IS includes security measures (e.g., authentication and access controls) to protect USG interests--not for your personal benefit or privacy.
    -Notwithstanding the above, using this IS does not constitute consent to PM, LE or CI investigative searching or monitoring of the content of privileged communications, or work product, related to personal representation or services by attorneys, psychotherapists, or clergy, and their assistants. Such communications and work product are private and confidential. See User Agreement for details.\"
    
    Click \"OK\".
  "
  impact 0.5
  tag severity: "medium"
  tag gtitle: "SRG-APP-000068-AS-000035"
  tag gid: "V-HZNV-8X-000146"
  tag rid: "SV-HZNV-8X-000146"
  tag stig_id: "HZNV-8X-000146"
  tag cci: ["CCI-000048"]
  tag nist: ["AC-8 a"]
  
  horizonhelper.setconnection
  
  result = horizonhelper.getpowershellrestwithtoken('/rest/config/v3/settings/general')
  
  # Removing Spaces to do the compare
  compareVal = input('warningBanner').gsub!(/\s/, '')
  
  gensettings = JSON.parse(result.stdout)
  
  describe 'Checking if warning banner is configured' do
    subject { gensettings['display_pre_login_admin_banner'] }
    it { should cmp true }
  end
  
  if !gensettings['pre_login_message'].nil?
    describe 'Checking warning banner text' do
      subject { gensettings['pre_login_admin_banner_message'].gsub!(/\s/, '') }
      it { should cmp compareVal }
    end
  else
    describe 'Checking warning banner text' do
      subject { gensettings['pre_login_admin_banner_message'] }
      it { should_not cmp nil }
    end
  end
end