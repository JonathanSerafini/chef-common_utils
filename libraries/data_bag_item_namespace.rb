
require 'chef/data_bag_item'
require 'chef/mixin/deep_merge'

module Common
  module DataBagItemNamespace
    # Return the data_bag_item's raw_data with the namespaced components merged
    # back onto the root level
    #
    # @params attrs [Array<String>] the namespaces to overlay
    # @return [Mash]
    # @example
    #   > data = data_bag_item(bag, item)
    #   {
    #     "_namespace": {
    #       "b": 1
    #     },
    #     "a": 0,
    #     "b": 0
    #   }
    #   > data.common_namespaced("namespace")
    #   {
    #     "a": 0,
    #     "b": 1
    #   }
    # @since 0.1.0
    def common_namespaced(*namespaces)
      if Array(namespaces).empty?
        namespaces = Chef.run_context.node[:common][:namespaces][:active]
      end
      namespaces  = namespaces.map(&:to_s)
      prefix      = Chef.run_context.node[:common][:namespaces][:prefix]

      data = @raw_data.reject{|key,_| key[0] == prefix}
      namespaces.each do |namespace|
        attr_hash = @raw_data.fetch("#{prefix}#{namespace}", {})
        data = Chef::Mixin::DeepMerge.merge(data, attr_hash)
      end

      data
    end
  end
end

# Inject into the Chef DataBagItem class
#
Chef::DataBagItem.send(:include, Common::DataBagItemNamespace)

