require File.dirname(__FILE__) + '/../../lib/fsm'
class Ticket
  attr_accessor(:state)
  include FSM
  define_fsm do
    states(:created, :reserved, :sold, :invalid, :inside, :outside)
    
    transition(:reserve, :created, :reserved)
    transition(:buy, :reserved, :sold)
    
    transition(:enter, :sold, :inside)
    transition(:enter, :outside, :inside)
    transition(:exit, :inside, :outside)
    
    transition(:invalidate, [:created, :reserved, :inside, :outside], :invalid)
  end
end

Ticket.draw_graph(:format => 'ps')