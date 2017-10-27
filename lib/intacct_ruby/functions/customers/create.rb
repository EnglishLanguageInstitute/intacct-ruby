require 'intacct_ruby/helpers/contacts_helper'
require 'intacct_ruby/functions/customers/base_function'

module IntacctRuby
  module Functions
    # function that creates customer instance
    class CreateCustomer < CustomerBaseFunction
      def initialize(attrs = {})
        super "create_customer_#{attrs[:customerid]}", attrs
      end

      def to_xml
        super do |xml|
          xml.create_customer do
            xml.customerid @attrs[:customerid]

            xml << customer_params
          end
        end
      end
    end
  end
end
