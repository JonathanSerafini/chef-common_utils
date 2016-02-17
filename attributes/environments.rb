
# Name of the data_bag to search when loading additional node attributes
default[:common_utils][:environments][:data_bag] = "environments"

# Name of the data_bag items to attempt to load
default[:common_utils][:environments][:active] = [
  '<%= node.environment %>',
  '<%= node.policy_group %>',
  '<%= node.policy_name %>'
].compact.uniq

# Whether to apply environments at compile-time or converge-time
default[:common_utils][:environments][:compile_time] = true

# Whether we should raise an exception when a data_bag item is missing
default[:common_utils][:environments][:ignore_missing] = false

# Environments feature flag
default[:common][:features][:environments]  = true

