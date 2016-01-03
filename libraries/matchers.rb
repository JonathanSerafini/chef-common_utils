if defined?(ChefSpec)
  def apply_common_environment(name)
    ChefSpec::Matchers::ResourceMatcher.new(:common_environment, :apply, name)
  end
  
  def apply_common_namespace(name)
    ChefSpec::Matchers::ResourceMatcher.new(:common_namespace, :apply, name)
  end
end
