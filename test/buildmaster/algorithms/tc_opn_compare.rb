require 'spec'

dir = File.dirname(__FILE__)

require dir + '/../../../lib/buildmaster/algorithms/opn_compare'

module BuildMaster
  module Algorithms
    describe NegativeIndexArray do
      it 'index with negative number' do
        array = NegativeIndexArray.new(5, 5) {|index| 'default'}
        array[-5].should == 'default'
        array[5].should == 'default'
        array[5] = '+5'
        array[-5] = '-5'
        array[5].should == '+5'
        array[-5].should == '-5'
        (-4..4).each {|index| array[index].should == 'default'}
      end

      it 'default value' do
        array = NegativeIndexArray.new(5, 5) {|index| index}
        array[-1].should == -1
      end
    end

    describe OpnCompare, 'O(pn) Compare Algorithm' do
      it 'no diff' do
        m = 'abcdefg'
        n = 'abcdefg'
        diff = OpnCompare.new(m, n).compare
#        diff.should be_nil
      end

      it 'one character change' do
        m = 'abfcde'
        n = 'abcdef'
        diff = OpnCompare.new(m, n).compare
#        diff.should have(1).edits
#        diff.edits[0].should == EditStep.new(EditAction.Add, 5)
      end
    end
  end
end