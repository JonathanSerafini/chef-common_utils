
module Common
  module FetchAttribute
    def fetch_attribute(string)
      value = node

      string.split('.').each do |part|
        value = (value || node).fetch(part, nil)
        break unless value.is_a?(Hash)
      end

      value
    end
  end
end
