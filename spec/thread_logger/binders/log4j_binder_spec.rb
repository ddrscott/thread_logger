require 'spec_helper'


module ThreadLogger
  module Binders
    describe ThreadLogger::Binders::Log4rBinder do
      require 'log4r'

      before do
        ThreadLogger.config.max_entries = 5
      end

      let(:null_file) { File.open(File::NULL, 'a') }
      let(:outputter) { Log4r::IOOutputter.new('test', null_file) }

      let(:logger) do
        Log4r::Logger.new('test').tap do |l|
          l.outputters = outputter
        end
      end

      let(:hijacked) { ThreadLogger.hijack(logger, outputter: outputter) }

      it 'should be detectable' do

        klass = ThreadLogger.detect_binder_class(logger)

        expect(klass).to eq(ThreadLogger::Binders::Log4rBinder)
      end

      it 'should respond to history after hijack' do
        expect(hijacked).to respond_to(:history)
      end

      it 'should ring around history' do
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
