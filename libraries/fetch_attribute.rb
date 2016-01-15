
module Common
  module FetchAttribute
    def fetch_attribute(string)
      value = node

      string.split('.').each do |part|
        new_value = value.fetch(part, nil)
        new_value = value.send(part) if new_value.nil? and 
                                        value.respond_to?(part)
        value = new_value
        break unless value.is_a?(Hash)
      end

      value
    end
  end
end
