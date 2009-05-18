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
  context 'Invoice' do
    
    should 'Initial State is the first state defined unless no initial() call was made' do
      invoice = Invoice.new
      assert_equal(:open, invoice.state)
    end
    
    should 'Accept an initial state from outside' do
      invoice = Invoice.new(:paid)
      assert_equal(:paid, invoice.state)
    end
    
    should 'Trasition to paid and then refunded' do
      invoice = Invoice.new
      assert_equal(:open, invoice.state)
      
      invoice.pay(1000)
      assert_equal(:paid, invoice.state)
      
      invoice.refund
      assert_equal(:refunded, invoice.state)
    end
    
    should 'Raise on illegal transition' do
      invoice = Invoice.new
      assert_raise(FSM::InvalidStateTransition) do
        invoice.refund
      end
    end
    
    should 'Pass the arguments to the event handler' do
      invoice = Invoice.new
      invoice.pay(1000)
      assert_equal(0, invoice.amount)
    end
    
  end
end
