require 'intacct_ruby/functions/base_function'

module IntacctRuby
  module Functions
    
    class AccountBaseFunction < BaseFunction
      ALL_PARAMS=[
        :accountno,
        :title,
        :category,
        :accounttype,
        :normalbalance,
        :closingtype,
        :closingaccountno,
        :alternativeaccount,
        :status,
        :requiredept,
        :requireloc,
        :requireproject,
        :requirecustomer,
        :requirevendor,
        :requireemployee,
        :requireitem,
        :requireclass,
        :requiretask,
        :requiregldim
      ]

      ACCOUNTTYPE_BALANCE_SHEET = "balancesheet"
      ACCOUNTTYPE_INCOME_STATEMENT = "incomestatement"
      
      NORMALBALANCE_DEBIT = "debit"
      NORMALBALANCE_CREDIT = "credit"
      
      CLOSINGTYPE_NON_CLOSING_ACCOUNT = "non-closing account"
      CLOSINGTYPE_CLOSING_ACCOUNT = "closing account"
      
      ALTERNATIVEACCOUNT_NONE = "None"
      ALTERNATIVEACCOUNT_PAYABLES_ACCOUNT = "Payables account"
      ALTERNATIVEACCOUNT_RECEIVABLES_ACCOUNT = "Receivables account"

      STATUS_ACTIVE = "active"
      STATUS_INACTIVE = "inactive"
      
      private

      def account_params
        xml = Builder::XmlMarkup.new

        ALL_PARAMS.each do |param_name|
          param_value = @attrs[param_name]
          xml.tag!(param_name) { xml << param_value } if param_value
        end

        xml << custom_field_params(@attrs[:customfields]) if @attrs[:customfields]

        xml.target!
      end
    end
  end
end
