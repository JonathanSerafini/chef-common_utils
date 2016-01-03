
# Name of the data_bag items to attempt to load
default[:common][:namespaces][:active] = [
  node.environment,
  node[:policy_group],
  node[:policy_name]
].compact.uniq

# The optional namespace prefix
default[:common][:namespaces][:prefix] = "_"

# Whether to apply namespaces at compile-time or converge-time
default[:common][:namespaces][:compile_time] = true

# namespaces feature flag
default[:common][:features][:namespaces]  = true

