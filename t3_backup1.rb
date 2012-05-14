require 'yaml'

class Game
    
  def initialize
		# initialize the game board (3 horizontal, 3 vertical, 2 diagonal)
		
		@spots = {
		  '00' => '', '01' => '', '02' => '', 
		  '10' => '', '11' => '', '12' => '',
		  '20' => '', '21' => '', '22' => ''
		}
		
		@data = Hash[
		  '1', [['00', ''], ['01', ''], ['02', '']],
	 		'2', [['10', ''], ['11', ''], ['12', '']],
			'3', [['20', ''], ['21', ''], ['22', '']],
			'4', [['00', ''], ['10', ''], ['20', '']],
			'5', [['01', ''], ['11', ''], ['21', '']],
			'6', [['02', ''], ['12', ''], ['22', '']],
			'7', [['00', ''], ['11', ''], ['22', '']],
			'8', [['20', ''], ['11', ''], ['02', '']]
		]
		
    self.save
    p 'New game started!'
    self.print_board
    p 'What is your name?'
    @name = gets.chomp
    p "Okay #{@name}, choose X or O!"
    while @human != 'X'
      @human = gets.chomp
      p 'Please choose X or O.'
    end
    @human == 'X' ? @cpu = 'O' : @cpu = 'X'
    p "So you\'re #{@human}, eh? Prepare to lose!"
    self.human_move
  end

	
	def save
    File.open(File.join(File.dirname(__FILE__) , 'output.yml'), 'w') {|f| f.write(@data.to_yaml) }
    return 'Game saved.'
	end
	
	
	def human_move
	  @dest = ''
	  
	  p 'Where would you like to move?'
	  @dest = gets.chomp
    while @spots.values_at(@dest).to_s == '[nil]'
      p 'Please choose a valid play tile.'
      @dest = gets.chomp
    end
	  
	  return 'Spot taken!' if @spots[@dest] != ''
  	@spots.keys.each do |a|
  	  @spots[@dest] = @human if @spots[@dest] == ''
    end
    p 'You placed an X on ' + @dest
    
    self.update_board
    p 'Starting computer\'s turn'
    self.computer_move
  end
  
  
  def computer_move
    self.check_board
    p 'Computer board check complete, initiating turn logic'
    p 'First play detected'
      @next = 1
      if @dest == '00'
        @dest = '22'
      elsif @dest == '02'
        @dest = '20'
      elsif @dest == '22'
        @dest = '00'
      elsif @dest == '20'
        @dest = '02'
      else
        @dest = ''
        @next = 2
      end
      p "Destination: #{@dest}"

    
    if @next == 2
      p 'Initiating logic'
    if @win.count > 0
      p "Moving to a must location"
      @win.each do |a|
        break a if @dest != ''
        @data[a].each do |b|
          break b if @dest != ''
          if b[1].length == 0
            p "Computer moving to #{b[0]}"
            @dest = b[0]
            break a
            break b
          end 
        end
      end
    elsif @must.count > 0
      p "Moving to a must location"
      @must.each do |a|
        break a if @dest != ''
        @data[a].each do |b|
          break b if @dest != ''
          p b[1].length
          if b[1].length == 0
            p "Computer moving to #{b[0]}"
            @dest = b[0]
            break a
            break b
          end 
        end
      end
    elsif 
      p "Moving to a can location"
      @can.each do |a|
        break a if @dest != ''
        @data[a].each do |b|
          break b if @dest != ''
          if b[1].length == 0
            p "Computer moving to #{b[0]}"
            if @spots['11'] == ''
              @dest = '11'
            else
              @dest = b[0]
            end
          end 
        end
      end
    else
      self.win_check  
    end
  end

    
    return 'Spot taken!' if @spots[@dest] != ''
  	@spots.keys.each do |a|
  	  @spots[@dest] = @cpu if @spots[@dest] == ''
    end
    
    self.update_board
    self.human_move
  end
  
  
  def check_board
    @can = Array.new
    @cant = Array.new
    @must = Array.new
    @win = Array.new
    
    @data.keys.each do |a|
      row = ''
      # loop 3 times per row
      for i in 0..2
        #p @data[a][i][1]
        row = row + @data[a][i][1]
      end
      
      human_count = row.count(@human)
      cpu_count = row.count(@cpu)
      #p "cpu: #{cpu_count} human: #{human_count}"
      if human_count == 3 or cpu_count == 3
        self.win_check
      elsif human_count + cpu_count == 3
        #p "Row #{a[0]} is full."
        @cant << a[0]
      elsif (human_count + cpu_count == 0) or (human_count == 1 or cpu_count == 1)
        #p "Nobody has played on row #{a[0]}."
        #p a[0]
        @can << a[0]
      elsif human_count > cpu_count && cpu_count > 0
        #p "Human played on row #{a[0]}."
        @cant << a[0]
      elsif human_count > 1 && cpu_count > 1
        #p "Both players have played on this row. Don't play."
        @cant << a[0]
      elsif ( human_count == 2 and cpu_count == 0 )
        #p "YOU MUST PLAY HERE!!!"
        @must << a[0]      
      elsif( cpu_count == 2 and human_count == 0 )
        #p "YOU MUST PLAY HERE!!!"
        @win << a[0]
      end
    end
    #p "Winning play available: #{@win}" if @win.count > 0
    #p "Can play: #{@can}" if @can.count > 0
    #p "Cant play: #{@cant}" if @cant.count > 0
    #p "Must play: #{@must}" if @must.count > 0
  end
  
  def update_board
    @spots.each do |a|
      @data.keys.each do |b|
        # loop 3 times per row
        for i in 0..2
          @data[b][i][1] = a[1] if @data[b][i][0] == a[0]
        end
      end
    end
    p 'Updating board complete.'
    self.win_check  
    self.print_board
  end
  
  def win_check
    p 'Checking for a win...'
    @data.keys.each do |a|
      row = ''
      # loop 3 times per row
      for i in 0..2
        row = row + @data[a][i][1]
      end
      human_count = row.count(@human)
      cpu_count = row.count(@cpu)
      if human_count == 3
        self.print_board
        raise RuntimeError, '~~~~~~~~~~~~~~~~~~~~~~~~~~ Human wins! ~~~~~~~~~~~~~~~~~~~~~~~~~~'
      elsif cpu_count == 3
        self.print_board
        raise RuntimeError, '~~~~~~~~~~~~~~~~~~~~~~~~~~ Computer wins, ~~~~~~~~~~~~~~~~~~~~~~~~~~'
      end
    end
    p 'No winner found'
	end
  
  def print_board
    row = ''
    value = ''
    i = 1
    p '_______'
    @spots.each do |a|
      value = ' ' if a[1] == ''
      value = a[1] if a[1] != ''
      row = row + "|#{value}"
      if i%3 == 0 && i != 0
        p row + "|"
        p '_______'
        row = ''
      end
      i = i+1
    end
  end
    
end

