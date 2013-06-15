require 'spec_helper'

describe AfterDo do
  let(:after_do) {Dummy.new.extend AfterDo}
  let(:mockie) {mock}

  class Dummy

    def zero
      0
    end

    def one(param)
      param
    end

    def two(param1, param2)
      param2
    end
  end

  it 'responds to after' do
    after_do.should respond_to :after
  end

  it 'calls a method on the injected mockie' do
    mockie.should_receive :call_method
    after_do.after :zero do mockie.call_method end
    after_do.zero
  end

  it 'does not change the return value' do
    before = after_do.zero
    after_do.after :zero do 42 end
    after = after_do.zero
    after.should eq before
  end

  it 'does not change the behaviour of other objects of this class' do
    after_do.after :zero do mockie.call_method end
    mockie.should_not_receive :call_method
    Dummy.new.zero
  end

  describe 'with parameters' do

    before :each do
      mockie.should_receive :call_method
    end


    it 'can handle methods with a parameter' do
      after_do.after :one do mockie.call_method end
      after_do.one 5
    end

    it 'can handle methods with 2 parameters' do
      after_do.after :two do mockie.call_method end
      after_do.two 5, 8
    end
  end

  describe 'multiple methods' do

    def call_all_3_methods
      after_do.zero
      after_do.one 4
      after_do.two 4, 5
    end

    it 'can take multiple method names as arguments' do
      mockie.should_receive(:call_method).exactly(3).times
      after_do.after :zero, :one, :two do mockie.call_method end
      call_all_3_methods
    end

    it 'raises an error when no method is specified' do
      expect do
        after_do.after do mockie.call_method end
      end.to raise_error ArgumentError
    end

  end
end