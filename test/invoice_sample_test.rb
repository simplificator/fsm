require 'test_helper'

class Invoice
  attr_accessor(:state, :amount)
  include FSM
  define_fsm do
    state_attribute(:state) 
    state(:open)
    state(:paid)
    state(:refunded)
    
    transition(:pay, :open, :paid, :event => :event_paid)
    transition(:refund, :paid, :refunded)
  end
  
  
  def initialize(state = :open, amount = 1000)
    self.state = state
    self.amount = amount
  end
  
  private
  def event_paid(amount_paid)
    raise "Not enough paid" unless amount_paid == self.amount
    self.amount -= amount_paid
  end
end

class InvoiceSampleTest < Test::Unit::TestCase
  context 'an Invoice' do
    setup do
      @invoice = Invoice.new
    end
    should 'Initial State is the first state defined unless no initial() call was made' do
      assert_equal(:open, @invoice.state)
    end
    
    should 'Accept an initial state from outside' do
      invoice = Invoice.new(:paid)
      assert_equal(:paid, invoice.state)
    end
    
    should 'Trasition to paid and then refunded' do
      assert_equal(:open, @invoice.state)
      
      @invoice.pay(1000)
      assert_equal(:paid, @invoice.state)
      
      @invoice.refund
      assert_equal(:refunded, @invoice.state)
    end
    
    should 'Raise on illegal transition' do
      assert_raise(FSM::InvalidStateTransition) do
        @invoice.refund
      end
    end
    
    should 'Pass the arguments to the event handler' do
      @invoice.pay(1000)
      assert_equal(0, @invoice.amount)
    end
    
    should 'List all states' do
        assert_equal_symbols [:paid, :refunded, :open], @invoice.fsm_state_names
    end
    should 'List all transitions' do
        assert_equal_symbols [:pay, :refund], @invoice.fsm_transition_names
    end
    
    should 'List next states' do
      assert_equal_symbols :paid, @invoice.fsm_next_state_names
      @invoice.pay(1000)
      assert_equal_symbols :refunded, @invoice.fsm_next_state_names
    end
    
    should 'List next transitions' do
      assert_equal_symbols :pay, @invoice.fsm_next_transition_names
      @invoice.pay(1000)
      assert_equal_symbols :refund, @invoice.fsm_next_transition_names
    end
    
    

  end
end
