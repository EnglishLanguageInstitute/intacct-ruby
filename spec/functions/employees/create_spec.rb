require 'intacct_ruby/functions/employees/create'

require 'functions/employees/function_examples'
require 'functions/function_spec_helper'
require 'functions/function_examples'
require 'functions/creation_function_examples'

describe IntacctRuby::Functions::CreateEmployee do
  function_xml = generate_function_xml(described_class, employee_attributes)

  it_behaves_like 'a function',
                  function_xml,
                  "create_employee_#{employee_attributes[:employeeid]}"

  it_behaves_like 'a creation function',
                  function_xml,
                  :employeeid,
                  employee_attributes[:employeeid]

  it_behaves_like 'an employee function', function_xml
end
