require 'intacct_ruby/functions/gltransactions/base_function'
require 'intacct_ruby/helpers/date_helper'

module IntacctRuby
  module Functions
    # creates gltransaction instance in Intacct
    class CreateGLTransaction < GLTransactionBaseFunction
      include DateHelper

      def initialize(attrs = {})
        super "create_gltransaction (#{attrs[:description]} #{timestamp})",
              attrs
      end

      def to_xml
        super do |xml|
          xml.create_gltransaction do
            xml << gltransaction_header_params(@attrs)

            xml.gltransactionentries do
              xml << gltransactionentry_params(@attrs[:gltransactionentries])
            end
          end
        end
      end
    end
  end
end
