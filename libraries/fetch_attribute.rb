
module Common
  module FetchAttribute
    def fetch_attribute(*elements, parent: nil, ignore_missing: false)
      elements = elements.first.split('.') if elements.count == 1
      parent = Chef.run_context.node if parent.nil?

      elements.each do |element|
        begin
          if parent.nil? 
            raise ArgumentError.new "Attribute not found: #{elements}"
          end
          parent = parent.fetch(element, nil)
        rescue StandardError
          if ignore_missing then return nil
          else raise
          end
        end
      end

      parent
    end
  end
end
