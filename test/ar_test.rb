require 'test_helper_ar'
class ArTest < Test::Unit::TestCase
  context 'AR' do
    
    should 'bla' do
      o = Order.new
      assert_equal  :open, o.state
    end
  end
end