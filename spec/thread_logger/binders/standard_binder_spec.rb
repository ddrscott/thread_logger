require 'spec_helper'


module ThreadLogger
  module Bindings
    describe ThreadLogger::Binders::StandardBinder do
      require 'logger'

      before do
        ThreadLogger.config.max_entries = 5
      end

      let(:null_file) { File.open(File::NULL, 'a') }
      let(:std_logger) { ::Logger.new(null_file)}
      let(:hijacked) { ThreadLogger.hijack(std_logger) }

      it 'should be detectable' do

        klass = ThreadLogger.detect_binder_class(std_logger)

        expect(klass).to eq(ThreadLogger::Binders::StandardBinder)
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

        hijacked.history.clear

        expect(hijacked.history.to_a).to eq([])
      end

      it 'should isolate history to current thread' do
        results = {}

        threads = [
            Thread.new { ('a'..'c').each{|l| hijacked.info(l)}; results[Thread.current] = hijacked.history },
            Thread.new { ('x'..'z').each{|l| hijacked.info(l)}; results[Thread.current] = hijacked.history }
        ]

        threads.each { |thr| thr.join }

        expect(results[threads[0]].size).to eq(3)
        expect(results[threads[0]].to_text).to match(/a\n.*b\n.*c\n/m)

        expect(results[threads[1]].size).to eq(3)
        expect(results[threads[1]].to_text).to match(/x\n.*y\n.*z\n/m)
      end
    end
  end
end

