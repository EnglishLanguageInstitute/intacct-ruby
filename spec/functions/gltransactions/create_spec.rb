require 'intacct_ruby/functions/gltransactions/create'

require 'functions/function_spec_helper'
require 'functions/function_examples'
require 'functions/gltransactions/function_examples'

describe IntacctRuby::Functions::CreateGLTransaction do
  function_attributes = generate_transaction_attributes(:gl)

  function_xml = generate_function_xml(
    described_class,
    function_attributes
  )

  it_behaves_like 'a function',
                  function_xml,
                  'create_gltransaction ' \
                  "(#{function_attributes[:description]}"

  it_behaves_like 'a gltransaction function',
                  'create_gltransaction',
                  :gl,
                  function_attributes,
                  function_xml
end
