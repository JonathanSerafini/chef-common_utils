
Chef.event_handler do
  on :converge_complete do
    # Ensure that the node object is present
    node = Chef.run_context.node

    # Iterate through the blacklist and delete attributes
    node[:common_utils][:blacklist].each do |key, value|
      key_path = Common::EvaluatedString.new(key)
      key_name = key_path.split('.').last

      parent = Common::ParentAttributeReference.new(key)
      next unless parent

      parent[key_name] = Common::SuppressedString.new(parent[key_name])
    end
  end
end

