require 'test_helper'
require 'rubygems'
require 'active_record'

ActiveRecord::Base.establish_connection(  
  :adapter  => 'sqlite3',   
  :database => 'test.sqlite3',   
  :timeout => 5000
)


begin
  ActiveRecord::Base.connection.drop_table(:orders)
rescue
  # no such table
end

ActiveRecord::Base.connection.create_table(:orders) do |table|
  table.string(:state, :null => false, :limit => 10)
end

class Order < ActiveRecord::Base
  include FSM
  define_fsm do 
    states :open, :closed, :delivered
    transition(:deliver, :open, :delivered)
  end
end

# ActiveRecord::Base.logger = Logger.new(STDOUT)
# ActiveRecord::Base.logger.level = Logger::DEBUG # change to DEBUG if you want to see something :-)
