require 'intacct_ruby/functions/customers/create'

require 'functions/customers/function_examples'
require 'functions/function_spec_helper'
require 'functions/function_examples'
require 'functions/creation_function_examples'

describe IntacctRuby::Functions::CreateCustomer do
  function_xml = generate_function_xml(described_class, customer_attributes)

  it_behaves_like 'a function',
                  function_xml,
                  "create_customer_#{customer_attributes[:locationid]}"

  it_behaves_like 'a creation function',
                  function_xml,
                  :customerid,
                  customer_attributes[:customerid]

  it_behaves_like 'a customer function', function_xml
end
