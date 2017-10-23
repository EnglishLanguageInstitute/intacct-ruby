require 'intacct_ruby/functions/account_base_function'

module IntacctRuby
  module Functions
    # creates a account instance in Intacct
    class CreateAccount < AccountBaseFunction
      def initialize(attrs = {})
        super("create_account_#{attrs[:accountno]}", attrs)
      end

      def to_xml
        super do |xml|
          xml.create_account do
            xml << account_params
          end
        end
      end
    end
  end
end
