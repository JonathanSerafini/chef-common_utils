
# Include node attribute helper methods
#
include Common::FetchAttribute

# Iterate through the list of active namespaces to merge namespace attrs
# This provides support for the namespace attribute namespace pattern.
#
node[:common][:namespaces][:active].each do |namespace|
  namespace = fetch_attribute(namespace) if namespace[0] == '@'

  common_namespace namespace do
    only_if { node[:common][:features][:namespaces] }
    action :apply
  end
end

