require 'yaml'

class Game
    
  def initialize
    p 'Initializing new game...'
		# initialize the game board (3 horizontal, 3 vertical, 2 diagonal)
		
		@spots = [
		  '00', '01', '02', 
		  '10', '11', '12',
		  '20', '21', '22'
		]
		
    @data = [
			{'00' => 0, '01' => 0, '02' => 0},
	 		{'10' => 0, '11' => 0, '12' => 0},
			{'20' => 0, '21' => 0, '22' => 0},
			{'00' => 0, '10' => 0, '20' => 0},
			{'01' => 0, '11' => 0, '21' => 0},
			{'02' => 0, '12' => 0, '22' => 0},
			{'00' => 0, '11' => 0, '22' => 0},
			{'20' => 0, '11' => 0, '02' => 0}
		]
    self.save
    p 'Initialization complete! Game on.'
  end

	def win_check
		@data.each do |a|
			a.each do |b|
				b.each do |c|
					p 'Check!'
				end
			end
		end
	end
	
	def save
    File.open(File.join(File.dirname(__FILE__) , 'output.yml'), 'w') {|f| f.write(@data.to_yaml) }
    return 'Game saved.'
	end
	
	
	
	def move(dest)
	  marker = 1
  	@data.each do |a|
  	  if !a[dest].nil?
  	    return 'Spot taken!' if a[dest] != 0
        a[dest] = marker if a[dest] == 0
      end
    end
    p 'You placed an X on ' + dest
    self.update_board(dest)
    self.check_board(marker)
    self.computer_move('')
  end
  
  
  
  def computer_move(dest)
    marker = 4
    dest = @spots.sample.to_s if dest == ''
    p 'Computer destination set: ' + dest

    @data.each do |a|
      if !a[dest].nil?
  	    return 'Spot taken! This AI is horrible!' if a[dest] != 0
        a[dest] = marker if a[dest] == 0
      end
    end
    self.update_board(dest)
    self.check_board(marker)
  end
  
  
  
  def update_board(dest)
    self.save
    @spots.delete(dest)
    p 'Draw!' if @spots.count == 0
  end
  
  
  
  def check_board(marker)
    n = 0
    @data.each do |a|
      a.each do |b|
        n = n + b[1]
        #p b[1]
      end
      p 'Checking results...'
      if n % marker == 3
        p 'Human wins!'
      elsif n % marker == 2
        p a.to_s + ' You must play here!'
        dest = a.select{|k,v| v == 0}.keys[0]
        #self.computer_move(dest)
        p 'Computer wins!'
      elsif n % marker == 1
        p a.to_s + ' Don\'t play here!'
        del = a.select{|k,v| v == 0}.values
        
        del.each do |a|
          @spots.delete(a)
        end
      elsif n % marker == 0
        p a.to_s + ' Play here!'
      end
      n = 0
    end
  end
  
  
  
  def print_board
    @data.each do |a|
      a.each do |b|
        p b[1]
      end
      p " "
    end
  end
    
end

