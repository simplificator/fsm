require File.dirname(__FILE__) + '/../../lib/fsm'

class Invoice
  include FSM
  define_fsm do
    state(:open,      :enter => :on_enter_open,     :exit => :on_exit_open)
    state(:progress,  :enter => :on_enter_progress, :exit => :on_exit_progress)
    state(:closed)
    initial(:open)
    
    attribute(:state)
    
    transition(:start, :open, :progress, :event => :event_start)
    transition(:close, :progress, :closed)
    transition(:reopen, :progress, :open)
  end
  
  private
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
puts "state is #{i.state}"
puts "Next states: #{i.reachable_state_names.join(', ')} / Next events #{i.available_transition_names.join(', ')}"
i.start('arguments', 'can be passed')
puts "state is #{i.state}"
puts "Next states: #{i.reachable_state_names.join(', ')} / Next events #{i.available_transition_names.join(', ')}"
#i.close
#i.reopen
#i.reopen