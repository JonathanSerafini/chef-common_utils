
# Iterate through the list of active namespaces to merge namespace attrs
# This provides support for the namespace attribute namespace pattern.
#
node[:common_utils][:namespaces][:active].each do |namespace|
  common_namespace namespace do
    only_if { node[:common][:features][:namespaces] }
    action :apply
  end
end

