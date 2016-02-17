require 'erubis'

module Common
  # `ObfuscatedString` is a decorator around the String object which provides
  # an additional `to_text` method to ensure the the output of this value is
  # never printed out to the screen during a chef stacktrace. 
  #
  class ObfuscatedString < SimpleDelegator
    # Custom initializer with preserves the initial value.
    # @param source [String]
    #
    def initialize(value)
      @value = value
      super(@value)
    end

    # Method used by when outputting the content of a resource for debugging
    # purposes or during stacktraces.
    #
    def to_text
      "**suppressed sensitive output**"
    end
  end

  # `SuppressedString` is a subclass of `ObfuscatedString` which provides the
  # additional `to_s`, `to_str` and `to_json` methods to ensure that the 
  # attribute is never sent to the Chef server during reporting. 
  #
  # Care should be taken when using this class because it will replace the
  # default string output with that from `to_text`.
  #
  class SuppressedString < ObfuscatedString
    # Method called when printing the String to screen,
    #
    def to_s
      to_text
    end

    # Method called when calling << or + or ==
    #
    def to_str
      @value
    end

    # Method called when generating a json representation of the object.
    #
    def to_json
      to_s.to_json
    end
  end

  # `Evaluated String` is a decorator around the String object which provides
  # a facility to treat the string as an ERB template with `node` in it's 
  # context.
  #
  # This is useful in situations where we might want to reference another
  # string internally.
  #
  # @example 
  # ```json
  # {
  #   "domain_name": "referenced.com",
  #   "fqdn_name": "provided.<%= node.domain_name %>"
  # }
  # ```
  #
  class EvaluatedString < SimpleDelegator
    # The `TemplateContext` provides data for the template handlers.
    #
    class TemplateContext < Erubis::Context
      # The `node` object so that the template can reference `node` attributes.
      #
      def node
        Chef.run_context.node
      end

      def render(template)
        begin
          eruby = Erubis::Eruby.new(template)
          eruby.evaluate(self)
        rescue Object => e
          raise TemplateError.new(e, template, self)
        end
      end
    end

    class TemplateError < RuntimeError
    end

    # Custom initializer with preserves the initial value.
    # @param template [String]
    #
    def initialize(template)
      @value = evaluate_template(tempalte)
      super(@value)
    end

    private

    def evaluate_template(template)
      TemplateContext.new.render(template)
    end
  end
end
