module Common
  # `AttributeReference` is a decorator around node `attributes` which provides
  # additional functionality to lookup attributes by path in a similar manner
  # to how `dig` works in Ruby 2.3.
  #
  class AttributeReference < SimpleDelegator
    def initialize(value)
      reference = expand_reference(value)
      @value = lookup_reference(reference)
      super(@value)
    end

    private

    # Expand a reference string into an Array of elements to walk through. 
    #
    def expand_reference(reference)
      reference.is_a?(String) ? reference.split('.') : reference
    end

    # Lookup an attribute by an Array of elements
    #
    def lookup_reference(reference_path)
      element = Chef.run_context.node

      Array(reference_path).each do |item|
        element = element.fetch(item, nil)
        break if element.nil?
      end

      element
    end
  end

  # `ParentAttributeReference` is a decorator which inherits AttributeReference
  # so as to only return the parent of a given attribute path.
  #
  class ParentAttributeReference < AttributeReference
    # Expand a reference string into an Array of elements to walk through and
    # remove the right most (child) attribute to ensure we only return it's 
    # parent attribute.
    #
    def expand_reference(reference)
      reference = Array.new(super(reference))
      reference.pop
      reference
    end
  end
end

