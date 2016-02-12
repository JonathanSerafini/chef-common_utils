
# A common_namespace resource will be used to overlay attributes found within
# a specific node attribute.
#
# @since 0.1.0
# @example
# ```json
# {
#   "_production": {
#     "value": "production"
#   },
#   "_development": {
#     "value": "development
#   },
#   "value": "unset"
# }
# ```
#

resource_name :common_namespace

# The namespace name to lookup and apply
property :namespace,
  kind_of: String,
  name_attribute: true

# The destination name to lookup and apply
property :destination,
  kind_of: String,
  default: nil

# The level of precendence to apply attributes at
property :precedence,
  kind_of: String,
  default: "environment"

property :prefix,
  kind_of: [String, NilClass],
  default: lazy { node[:common][:namespaces][:prefix] }

property :compile_time,
  kind_of: [TrueClass, FalseClass],
  default: lazy { node[:common][:namespaces][:compile_time] }

def after_created
  self.run_action(:apply) if compile_time
  self.action :nothing
end

action :apply do
  namespace_name = namespace
  namespace_name = fetch_attribute(namespace)
  raise ArgumentError.new "Node attribute not found" if namespace_name.nil?

  converge_by "applying attributes for #{namespace_name}" do
    apply_hash(fetch_attribute("#{prefix}#{namespace_name}", {}))
  end
end

# Include node attribute helper methods
#
include Common::FetchAttribute

# Lookup the namespace attribute value
#
# @since 0.1.2
# @returns [Node::Attribute] the node attribute containing the namespace
def fetch_namespace
  fetch_attribute("#{prefix}#{namespace_name}")
end

# Lookup the destination attribute value
#
# @since 0.1.2
# @returns [Node::Attribute] the node attribute containing the destination
def fetch_destination
  destination.nil? ? node : fetch_attribute(destination)
end

# Apply an attribute hash to the node attributes
# 
# @param hash [Hash] hash containing attributes
# @since 0.1.0
def apply_hash(hash)
  destination = fetch_destination

  case precedence
  when "environment"
    destination.attributes.env_default = hash
  when "role"
    destination.attributes.role_default = hash
  else raise ArgumentError.new "Invalid scope defined: #{scope}"
  end
end

