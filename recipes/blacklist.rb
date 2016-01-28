
Chef.event_handler do
  on :converge_complete do
    # Ensure that the node object is present
    node = Chef.run_context.node

    # Iterate through the blacklist and delete attributes
    node[:common][:blacklist].each do |key, value|
      elements = String(key).split('.')
      elements.pop

      node.rm(*elements)
    end
  end
end

