require 'intacct_ruby/functions/accounts/base_function'

module IntacctRuby
  module Functions
    # creates a account instance in Intacct
    class UpdateAccount < AccountBaseFunction
      def initialize(attrs = {})
        super("update_account_#{attrs[:accountno]} (#{timestamp})", attrs)
      end

      def to_xml
        super do |xml|
          xml.update_account key: @attrs[:accountno] do
            xml << account_params
          end
        end
      end
    end
  end
end
