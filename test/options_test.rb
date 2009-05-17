require 'test_helper'

class OptionsTest < Test::Unit::TestCase
  include FSM::Options::InstanceMethods
  context 'assert_options' do
    should 'allow empty options' do
      assert_options({})
    end
    should('throw on unknown key') do
      assert_raise(ArgumentError) do
        assert_options({:foo => 12}, [], [])
      end
      assert_raise(ArgumentError) do
        assert_options({:foo => 12}, [:optional], [])
      end
      assert_raise(ArgumentError) do
        assert_options({:foo => 12}, [], [:mandatory])
      end
      assert_raise(ArgumentError) do
        assert_options({:foo => 12}, [:optional], [:mandatory])
      end
    end
    should('find missong mandatory options') do
      assert_raise(ArgumentError) do
        assert_options({}, [], [:foo])
      end
      assert_raise(ArgumentError) do
        assert_options({:foo => 12}, [], [:bar])
      end
      assert_raise(ArgumentError) do
        assert_options({:foo => 12}, [:bar], [:bar])
      end
      assert_options({:foo => 42}, [], [:foo])
      assert_options({:foo => 42}, [:foo], [:foo])
    end
  end
end
