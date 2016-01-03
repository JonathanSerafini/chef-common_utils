
# A common_environment resource will be used to provide the environment databag
# pattern which is used with PolicyGroups to replicate the concept of a global
# configuration space.
#
# @since 0.1.0
# @example
# ```json
# {
#   "id": "name",
#   "default_attributes": {},
#   "override_attributes": {}
# }
# ```
#

resource_name :common_environment

# The environment name to search for and apply
property :environment,
  kind_of: String,
  name_attribute: true

# The level of precendence to apply attributes at
property :precedence,
  kind_of: String,
  equal_to: ["environment","role"],
  default: "environment"

# The data_bag to fetch the environment from
property :data_bag,
  kind_of: String,
  default: lazy { node[:common][:environments][:data_bag] }

# Whether to apply the resource at compile time
property :compile_time,
  kind_of: [TrueClass, FalseClass],
  default: lazy { node[:common][:environments][:compile_time] }

# Whether we to raise an exception when the is missing
property :ignore_missing,
  kind_of: [TrueClass, FalseClass],
  default: lazy { node[:common][:environments][:ignore_missing] }

def after_created
  self.run_action(:apply) if compile_time
end

action :apply do
  converge_by "applying attributes for #{environment}" do
    item_data = fetch_item(data_bag, environment)
    apply_hash(item_data)
  end
end

# Fetch a databag item to include into the node attributes
#
# @param data_bag [String]
# @param item [String]
# @return [Hash]
# @since 0.1.0
def fetch_item(data_bag, item)
  data = Chef::DSL::DataQuery.data_bag_item(data_bag, item)
  data = data.to_hash.reject do |key|
    %w(chef_type data_bag id).include?(key)
  end
  data
rescue StandardError => e
  Chef::Log.warn "#{self} could not find the environment named #{name}"
  if ignore_missing then {}
  else raise
  end
end

# Apply an attribute hash to the node attributes
# 
# @param hash [Hash] hash containing attributes
# @since 0.1.0
def apply_hash(hash)
  case precedence
  when "environment"
    node.attributes.env_default = hash.fetch("default_attributes", {})
    node.attributes.env_override = hash.fetch("override_attributes", {})
  when "role"
    node.attributes.role_default = hash.fetch("default_attributes", {})
    node.attributes.role_override = hash.fetch("override_attributes", {})
  else raise AttributeError.new "Invalid scope defined: #{scope}"
  end
end

