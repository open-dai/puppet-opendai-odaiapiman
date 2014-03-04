# wso2am_version.rb:
#

require 'facter'

if  FileTest.exists?("/bin/rpm")
	Facter.add("wso2am_version") do
		setcode do
			%x{/bin/rpm -qa --queryformat "%{VERSION}" wso2am}
		end
	end
end