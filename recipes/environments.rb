
# Iterate through the list of active environments to pull in environment items.
# This provides support for the environment data bag item pattern.
# 
node[:common_utils][:environments][:active].each do |environment|
  common_environment environment do
    only_if { node[:common][:features][:environments] }
    action :apply
  end
end

