require 'yaml'

class Game
    
  def initialize
    data = [1 => {0 => 0, 1 => 0, 2 => 0}, 2 => {0 => 0, 1 => 0, 2 => 0}, 3 => {0 => 0, 1 => 0, 2 => 0}]
    File.open(File.join(File.dirname(__FILE__) , 'output.yml'), 'w') {|f| f.write(data.to_yaml) }
    p 'New game started!'
  end
    
end

def move(row, col)
  p 'You placed an X on ' + row.to_s + col.to_s
end

def box(location)
  p '['+location+']'
end