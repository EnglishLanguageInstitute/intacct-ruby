require 'nokogiri'

require 'functions/function_spec_helper'
require 'functions/custom_fields_examples'

def item_attributes(overrides = {})
  {
    itemid: '4',
    name: 'Some Item',
    itemtype: 'Some Item Type',
    extended_description: 'Some Item Description',
    productlineid: 'Some ProductLine',
    standard_cost: 'Some Standard Cost',
    glgroup: 'Some GL Group',
    uomgrp: 'Some UOM Group',
    customfields: {
      custom_field_1: 'Custom Field 1 Value',
      custom_field_2: 'Custom Field 2 Value'
    }
  }.merge(overrides)
end

shared_examples 'a item function' do |function_xml|
  let(:xml_base) { function_base_path(function_name) }

  let(:function_name) { function_name_from(function_xml) }

  it 'contains expected item params' do
    # because itemid is sometimes in the header (for updates) and sometimes in
    # the body (for create actions)
    attributes_to_check = item_attributes.keys.reject { |s| [:itemid, :customfields].include?(s) }

    attributes_to_check.each do |parameter_key|
      parameter = function_xml.xpath("#{xml_base}/#{parameter_key}")
      expected_value = item_attributes[parameter_key]

      expect(parameter.text)
        .to eq(expected_value),
            "Value of #{parameter_key} did not match. " \
            "Expected \"#{expected_value}\", got \"#{parameter.text}\""
    end
  end
  it_behaves_like 'a custom fields function', function_xml, item_attributes
end

