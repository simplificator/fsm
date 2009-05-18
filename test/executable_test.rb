require 'test_helper'

class ExecutableTest < Test::Unit::TestCase
  context 'Should execute method without arguments' do
    should 'with symbol' do
      assert_equal 4, FSM::Executable.new(:length).execute('1234')
    end
    should 'with string' do
      assert_equal 4, FSM::Executable.new('length').execute('1234')
    end
    should 'with proc' do
      assert_equal 4, FSM::Executable.new(lambda { |target| target.length }).execute('1234')
    end
  end
  
  context 'Should execute method with arguments' do
    should 'with symbol' do
      assert_equal 'firstlast', FSM::Executable.new(:+).execute('first', 'last')
    end
    should 'with string' do
      assert_equal 'firstlast', FSM::Executable.new('+').execute('first', 'last')
    end
    
    should 'with proc varargs' do
      assert_equal 'some things are good', FSM::Executable.new(lambda {|target, *args| args.join(' ') }).execute(:foo, 'some', 'things', 'are', 'good')
    end
    
    should 'with proc' do
      assert_equal 'some things', FSM::Executable.new(lambda {|target, a, b| "#{a} #{b}" }).execute(:foo, 'some', 'things')
    end
    
  end
end
