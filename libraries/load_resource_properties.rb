
require 'chef/resource'

module Common
  module LoadResourceProperties
    # Update a resource's properties with a hash.
    #
    # When passing node attributes, they will first be converted to a Mash
    # object so as to ensure that we don't run into any issues with node
    # attribute Immutable types. 
    #
    # @params hash [Hash] the properties to set
    # @example
    #   node.default[:data] = { a:0, b:1 }
    #   my_resource "named" do
    #     load_properties(node[:data])
    #   end
    # @since 0.1.0
    def load_properties(hash)
      hash = Mash.new(hash.to_hash) if hash.respond_to?(:to_hash)
      hash.each do |key, value|
        if respond_to?(key.to_sym)
          send(key.to_sym, value)
        else
          Chef::Log.warn "#{self} received unknown property #{key}"
        end
      end unless hash.nil?
    end
  end
end

# Inject into the Chef Resource class
# 
Chef::Resource.send(:include, Common::LoadResourceProperties)

