require 'intacct_ruby/functions/create_account'

require 'functions/account_function_examples'
require 'functions/function_spec_helper'
require 'functions/function_examples'
require 'functions/creation_function_examples'

describe IntacctRuby::Functions::CreateAccount do
  function_xml = generate_function_xml(described_class, account_attributes)

  it_behaves_like 'a function',
                  function_xml,
                  "create_account_#{account_attributes[:accountno]}"

  it_behaves_like 'a creation function',
                  function_xml,
                  :accountno,
                  account_attributes[:accountno]

  it_behaves_like 'a account function', function_xml  
end
