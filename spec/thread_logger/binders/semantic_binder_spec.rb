require 'spec_helper'

module ThreadLogger
  module Binders
    describe SemanticBinder do
      before do
        ThreadLogger.config.max_entries = 5
      end

      let(:logger) do
        SemanticLogger['test']
      end

      let(:hijacked) { ThreadLogger.hijack(logger) }

      it 'should be detectable' do
        klass = ThreadLogger.detect_binder_class(logger)
        expect(klass).to eq(ThreadLogger::Binders::SemanticBinder)
      end

      it 'should respond to history after hijack' do
        expect(hijacked).to respond_to(:history)
      end

      it 'should ring around history' do
        SemanticLogger.default_level = :debug
        hijacked.debug('zero')
        hijacked.debug('one')
        hijacked.info('two')
        hijacked.warn('three')
        hijacked.error('four')
        hijacked.fatal('five')

        as_array = hijacked.history.to_a
        expect(as_array.size).to eq(ThreadLogger.config.max_entries)
        expect(as_array[0]).to match(/one/)
        expect(as_array[1]).to match(/two/)
        expect(as_array[2]).to match(/three/)
        expect(as_array[3]).to match(/four/)
        expect(as_array[4]).to match(/five/)
      end
    end
  end
end
