require 'rubygems'
require 'test/unit'
require 'shoulda'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'fsm'


class Test::Unit::TestCase
  def assert_equal_symbols(a1, a2)
    assert_equal  Array(a1).map() {|item| item.to_s}.sort, 
                  Array(a2).map() {|item| item.to_s}.sort
  end
end