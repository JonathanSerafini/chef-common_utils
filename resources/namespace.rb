
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
end

action :apply do
  converge_by "applying attributes for #{namespace}" do
    apply_hash(node.fetch("#{prefix}#{namespace}", {}))
  end
end

# Apply an attribute hash to the node attributes
# 
# @param hash [Hash] hash containing attributes
# @since 0.1.0
def apply_hash(hash)
  case precedence
  when "environment"
    node.attributes.env_default = hash
  when "role"
    node.attributes.role_default = hash
  else raise AttributeError.new "Invalid scope defined: #{scope}"
  end
end

