require 'test_helper_ar'
class ArTest < Test::Unit::TestCase
  
  context 'AR' do
    
    should 'set the state' do
      o1 = Order.new
      assert_equal  :open, o1.state
      o1.save!
      o2 = Order.find o1.id
      assert_equal  'open', o2[:state]
      assert_equal  :open, o2.state
    end
    
    should 'return initial state when state is empty string' do
      o1 = Order.new(:state => '')
      assert_equal :open, o1.state
    end
    
    should 'make transition' do
      o = Order.new
      assert_equal :open, o.state
      o.deliver
      assert_equal :delivered, o.state
      o.save!
      assert_equal :delivered, o.state
      o.reload
      o = Order.find(o.id)
      assert_equal :delivered, o.state
    end
    
    
    should 'have state check methods' do
      o = Order.new
      assert o.state_open?
      o.deliver
      assert o.state_delivered?
    end
  end
end