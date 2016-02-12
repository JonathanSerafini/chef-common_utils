module Common
  class AttributeReference
    def initialize(path)
      @path = path.gsub(/@/,'')
    end

    def fetch(default: nil, ignore_missing: false)
      value = search(*@path.split('.'), Chef.run_context.node), ignore_missing
      value ||= default

      if not ignore_missing and value.nil?
        raise ArgumentError.new "Attribute not found: #{@path}"
      end
    end

    private

    def search(*elements, parent)
      elements.each do |element|
        break if parent.nil?
        parent = parent.fetch(element, nil)
      end

      parent
    end
  end

  module FetchAttribute
    def fetch_attribute(path, parent: nil, ignore_missing: false)
      AttributeReference.new(path).fetch(nil, ignore_missing: ignore_missing)
    end
  end
end
