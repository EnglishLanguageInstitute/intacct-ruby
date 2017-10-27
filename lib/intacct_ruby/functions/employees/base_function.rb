require 'intacct_ruby/helpers/contacts_helper'
require 'intacct_ruby/helpers/date_helper'
require 'intacct_ruby/functions/base_function'

module IntacctRuby
  module Functions
    # contains code shared by all employee functions
    class EmployeeBaseFunction < BaseFunction
      include IntacctRuby::ContactsHelper
      include IntacctRuby::DateHelper

      private

      def employee_params
        xml = Builder::XmlMarkup.new

        xml.locationid   @attrs[:locationid]
        xml.supervisorid @attrs[:supervisorid]

        xml << start_date_params

        xml.status @attrs[:status]

        xml.personalinfo do
          xml << employee_contact_params
        end

        xml.target!
      end

      def employee_contact_params
        contact_params(@attrs, @attrs[:employeeid], 'Employee')
      end
    end
  end
end
