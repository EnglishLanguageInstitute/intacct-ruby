require 'nokogiri'

# function_name refers to the name that identifies the function to intacct,
# usually a snake-case variant of the class name.
shared_examples 'a custom fields function' do |function_xml, attributes|
  let(:base_path) { function_base_path(function_name) }
  let(:function_name) { function_name_from(function_xml) }
  let(:custom_fields_path) { "#{base_path}/customfields/customfield" }

  it 'contains expected customfield params' do
    function_xml.xpath(custom_fields_path).each do |field|
      field_key = field.xpath('customfieldname').text
      field_value = field.xpath('customfieldvalue').text

      expected_value = attributes[:customfields][field_key.to_sym]

      expect(field_value)
        .to eq(expected_value),
            "Value mismatch on #{field_key}. Expected " \
            "\"#{expected_value}\", got \"#{field_value}\""
    end
  end
end
