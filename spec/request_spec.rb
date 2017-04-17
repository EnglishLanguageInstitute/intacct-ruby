require 'spec_helper'
require 'mocha/api'
require 'nokogiri'

require 'intacct_ruby/request'
require 'intacct_ruby/response'
require 'intacct_ruby/exceptions/insufficient_credentials_exception'

include IntacctRuby

# For all ENVs in this format:
# xml_key represents the key associated with each ENV in the request produced
AUTHENTICATION_PARAMS = {
  senderid: 'senderid_value',
  sender_password: 'sender_password_value',
  userid: 'userid_value',
  companyid: 'companyid_value',
  user_password: 'user_password_value'
}.freeze

def generate_request_xml(request_param_overrides = {})
  @request_xml ||= begin
    Nokogiri::XML Request.new(
      *function_stubs,
      AUTHENTICATION_PARAMS.merge(request_param_overrides)
    ).to_xml
  end
end

def control_block_xml
  @control_block_xml ||= @request_xml.xpath('/request/control')
end

def operation_block_xml
  @operation_block_xml ||= @request_xml.xpath('/request/operation')
end

def get_value_from(xml, node_name)
  xml.xpath(node_name).text
end

def function_stubs
  @function_stubs ||= %i(function_a function_b).map do |function|
    mock do
      stubs(:to_xml).returns("[#{function}]")
    end
  end
end

describe Request do
  context 'with no overrides' do
    describe :send do
      it 'sends request through the API' do
        request = Request.new(*function_stubs, AUTHENTICATION_PARAMS)
        response = mock('IntacctRuby::Response')

        api_spy = mock('IntacctRuby::Api')
        api_spy.expects(:send).with(request).returns(response)

        Response.expects(:new).with(response)

        request.send(api_spy)
      end

      it 'raises error unless all authentication keys are provided' do
        AUTHENTICATION_PARAMS.keys.each do |omitted_key|
          incomplete_params = AUTHENTICATION_PARAMS.dup
          incomplete_params.delete(omitted_key)

          request = Request.new(*function_stubs, incomplete_params)

          expected_error = Exceptions::InsufficientCredentialsException
          expected_message = Regexp.new(
            "\\[:#{omitted_key}\\] required for a valid request."
          )

          expect { request.send }
            .to raise_error(expected_error, expected_message)
        end
      end
    end

    before(:all) { generate_request_xml }

    describe 'control block' do
      it 'contains expected authentication parameters' do
        {
          senderid: 'senderid',
          sender_password: 'password'
        }.each do |parameter_name, xml_label|
          expected = AUTHENTICATION_PARAMS[parameter_name]
          actual = get_value_from control_block_xml, xml_label

          expect(actual).to eq expected
        end
      end

      it 'contains valid controlid' do
        controlid = get_value_from control_block_xml, 'controlid'

        # if controlid is not a valid datetime string, this will blow up
        expect { DateTime.parse(controlid) }.not_to raise_error
      end

      it 'contains a control block with default values' do
        %i(uniqueid dtdversion includewhitespace).each do |field_name|
          expected_value = Request::DEFAULTS[field_name].to_s
          actual_value = get_value_from control_block_xml, field_name.to_s

          expect(expected_value).to eq actual_value
        end
      end
    end

    describe 'authentication block' do
      it 'contains expected authentication parameters' do
        authentication_block_xml = @request_xml.xpath(
          '/request/operation/authentication/login'
        )

        {
          userid: 'userid',
          user_password: 'password',
          companyid: 'companyid'
        }.each do |parameter_name, xml_label|
          expected = AUTHENTICATION_PARAMS[parameter_name]
          actual = get_value_from authentication_block_xml, xml_label

          expect(actual).to eq expected
        end
      end
    end

    describe 'operation block' do
      it 'shows transaction default' do
        expect(operation_block_xml.first.attributes['transaction'].value)
          .to eq Request::DEFAULTS[:transaction].to_s
      end
    end

    describe 'content block' do
      it 'contains function payloads' do
        content_block = operation_block_xml.xpath('content').text
        function_stubs.each do |function|
          expect(content_block).to include function.to_xml
        end
      end
    end
  end

  context 'with overrides' do
    describe 'control block' do
      it 'shows overrides instead of defaults' do
        overrides = {
          uniqueid: 'uniqueid override',
          dtdversion: 'dtdversion override',
          includewhitespace: 'includewhitespace override'
        }

        generate_request_xml(overrides)

        overrides.each do |field_name, field_value|
          request_value = get_value_from control_block_xml, field_name.to_s

          expect(request_value).to eq field_value
        end
      end
    end

    describe 'operations block' do
      it 'shows overrides instead of defaults' do
        transaction_override_value = 'Transaction Override'

        generate_request_xml(transaction: transaction_override_value)

        request_attribute = operation_block_xml.first.attributes['transaction']

        expect(request_attribute.value).to eq transaction_override_value
      end
    end
  end
end
