
# Name of the data_bag to search when loading additional node attributes
default[:common][:environments][:data_bag] = "environments"

# Name of the data_bag items to attempt to load
default[:common][:environments][:active] = [
  '@environment',
  '@policy_group',
  '@policy_name'
].compact.uniq

# Whether to apply environments at compile-time or converge-time
default[:common][:environments][:compile_time] = true

# Whether we should raise an exception when a data_bag item is missing
default[:common][:environments][:ignore_missing] = true

# Environments feature flag
default[:common][:features][:environments]  = true

