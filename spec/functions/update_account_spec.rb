require 'intacct_ruby/functions/update_account'

require 'functions/function_spec_helper'
require 'functions/function_examples'
require 'functions/account_function_examples'
require 'functions/update_function_examples'

describe IntacctRuby::Functions::UpdateAccount do
  function_xml = generate_function_xml(described_class, account_attributes)

  it_behaves_like 'a function',
                  function_xml,
                  "update_account_#{account_attributes[:accountno]}"

  it_behaves_like 'an update function',
                  function_xml,
                  :key,
                  account_attributes[:accountno]

  # even though it's not one, it "behaves_like" a creation function in that it
  # also carries account No inside of the function body. Why? Because Intacct.
  it_behaves_like 'a creation function',
                  function_xml,
                  :accountno,
                  account_attributes[:accountno]

  it_behaves_like 'a account function', function_xml
end
