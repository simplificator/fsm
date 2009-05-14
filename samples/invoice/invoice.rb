require File.dirname(__FILE__) + '/../../lib/fsm'

class Invoice
  include FSM
  attr_accessor(:state_col)
  
  define_fsm do
    state(:open,      :enter => :on_enter_open,     :exit => :on_exit_open)
    state(:progress,  :enter => :on_enter_progress, :exit => :on_exit_progress)
    state(:closed)
    
    initial(:open)
    
    state_attribute(:state_col)
    
    transition(:start, :open, :progress, :event => :event_start)
    # assert that no double event exists for state
    #transition(:start, :open, :closed)
    
    transition(:close, :progress, :closed)
    transition(:reopen, :closed, :open)
  end
  
  #
  #alias :fsm_state_col_before :state_col
  #alias :fsm_state_col_before= :state_col=
  #def state_col
  #  fsm_state_col_before
  #end
  
  #def state_col=(value)
  #  self.fsm_state_col_before = value
  #  Machine[self.class].initial value
  #end
  
  private
  def on_enter_open
    puts "enter open (after event)"
  end
  def on_exit_open
    puts "exit open (before event)"
  end
  
  def on_exit_progress
    puts "exit progress (before event)"
  end
  
  def on_enter_progress
    puts "enter progress (after event)"
  end
  
  def event_start(arg1, arg2)
    puts "event start (event): #{arg1} #{arg2}"
  end
end


i = Invoice.new
i.state_col = :open
puts "state is #{i.state_col}"
puts "Next states: #{i.reachable_state_names.join(', ')} / Next events #{i.available_transition_names.join(', ')}"
i.start('arguments', 'can be passed')
puts "state is #{i.state_col}"
puts "Next states: #{i.reachable_state_names.join(', ')} / Next events #{i.available_transition_names.join(', ')}"
i.close
puts "state is #{i.state_col}"
puts "Next states: #{i.reachable_state_names.join(', ')} / Next events #{i.available_transition_names.join(', ')}"
i.reopen
puts "state is #{i.state_col}"
puts "Next states: #{i.reachable_state_names.join(', ')} / Next events #{i.available_transition_names.join(', ')}"

#i.reopen