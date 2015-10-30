require 'spec_helper'

module ThreadLogger
  describe Historian do
    let(:historian) { Historian.new(10)}

    it 'should shift in' do

      (1..10).each{|i| historian << i}

      expect(historian.to_a).to eq((1..10).to_a)
    end

    it 'should output text' do
      historian << 'cats'

      expect(historian.to_text).to eq('cats')
    end

    it 'should output ansi to HTML' do
      historian << "\x1b[30mblack\x1b[37mwhite"

      expect(historian.to_html).to eq("<span style='color:#000'>black<span style='color:#AAA'>white</span></span>")
    end

    it 'should implement to_s' do
      historian << 'cats'
      expect(historian.to_s).to eq('[size: 1] cats')
    end
  end
end
