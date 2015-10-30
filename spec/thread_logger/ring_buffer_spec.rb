require 'spec_helper'


module ThreadLogger
  describe RingBuffer do
    let(:buffer) { RingBuffer.new(5)}

    it 'should rotate' do

      (1..10).each{|i| buffer << i}

      expect(buffer).to eq([6,7,8,9,10])
    end
  end
end
