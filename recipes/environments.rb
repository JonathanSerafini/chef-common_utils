
# Include node attribute helper methods
#
include Common::FetchAttribute

# Iterate through the list of active environments to pull in environment items.
# This provides support for the environment data bag item pattern.
# 
node[:common][:environments][:active].each do |environment|
  environment = fetch_attribute(environment) if environment[0] == '@'

  common_environment environment do
    only_if { node[:common][:features][:environments] }
    action :apply
  end
end

