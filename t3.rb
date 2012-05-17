require 'yaml'

class Game
    
  def initialize
		# initialize the game board (3 horizontal, 3 vertical, 2 diagonal)
		
		@turn_number = 1
		
		@spots = {
		  '00' => '', '01' => '', '02' => '', 
		  '10' => '', '11' => '', '12' => '',
		  '20' => '', '21' => '', '22' => ''
		}
		
		@zones = Hash[ 'zones', Hash[
		  'corners', Hash['spots',Array['00', '02', '20', '22'],'points',1],
		  'middle', Hash['spots',Array['11'],'points',2],
		  'betweens', Hash['spots',Array['01', '10', '12','21'],'points',0]
		]]
		
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
    #p 'What is your name?'
    #@name = gets.chomp
    #p "Okay #{@name}, choose X or O!"
    #while @human != 'X'
    #  @human = gets.chomp
    #  p 'Please choose X or O.'
    #end
    #@human == 'X' ? @cpu = 'O' : @cpu = 'X'
    
    
    @human = 'X'
    @cpu = 'O'
    p "So you\'re #{@human}, eh? Prepare to lose!"
    self.human_move
  end

	
	def save
    File.open(File.join(File.dirname(__FILE__) , 'output.yml'), 'w') {|f| f.write(@data.to_yaml) }
    return 'Game saved.'
	end
	
	
	def human_move
	  p 'Human\'s turn'
	  @dest = ''
	  
	  while @dest == ''
      p 'Where would you like to move?'
	    @dest = gets.chomp
      if @spots.values_at(@dest).first == @human or @spots.values_at(@dest).first == @cpu
        p 'That place is already taken. Please try again!'
        @dest = ''
      elsif @spots.values_at(@dest).to_s == '[nil]'
        p 'Please choose a valid play tile.'
        @dest = ''
      else
        p 'Spot not taken, move ready.'
      end
    end
	  
    self.update_board(@human)
    self.computer_move
  end
  
  
  def computer_move
    @dest.clear
    p 'Computer\'s turn'
		

		# 1 - Prioritize blocks and wins
		#=================================
		@data.keys.each do |a|
      row = Array.new
      
      # loop 3 times per row and add the player marker to the row array
      for i in 0..2
        row << @data[a][i][1]
      end
              
      human_count = row.count(@human)
      cpu_count = row.count(@cpu)

      # must block a win or win, so dest will be set
      #p "Row number: #{a}"
	    if ( human_count == 2 and cpu_count == 0 ) || ( human_count == 0 and cpu_count == 2 )
	      #p 'Block or win detected'
	      #p "Data[a] is: #{@data[a]}"
        @data[a].each do |b|
          if b[1].length == 0
	          @dest = b[0] 
            break b
          end
        end
      end
    end
    
    
    # 2 - Prioritize zones and change points, then evaluate
    #======================================================
    if @dest == ''
      if @turn_number == 2
        p 'Second turn detected'
        row = Array.new
        @zones['zones']['betweens']['spots'].each do |a|
          row << @spots[a]
        end
        zone_empty_count = row.count('')
        if zone_empty_count == 3
          # find an empty spot in this zone, starting with an array of empty spots:
          @spots.select{|k,v| v == ''}.each do |b|
            # for each empty spot (b[0]):
            @dest = b[0] if @zones['zones']['betweens']['spots'].count(b[0]) > 0
            break b if @dest != ''
          end
        end
      end
    end
    
		# 3 - Pick a zone stop
    if @dest == ''
      p 'No blocks or wins detected, so picking the highest potential spot'
		  @scoreboard = Hash.new
		  
		    # see how many blank rows are in each square
	      # loop through all blank spots

	      @spots.select{|k,v| v == ''}.each do |a|
	        #array..floor
	        p current_spot = a[0]
	        current_spot_score = 0
	        #
	        #loop through every block in the same row
	        @data.each do |b|
	          if b[1].select{|k,v| k == current_spot}.count == 1 && b[1].select{|k,v| v == ''}.count == 3
	            #p 'Blank row detected'
	            current_spot_score = current_spot_score + 1
	          end
	        end
	        @scoreboard.store(current_spot, current_spot_score)
	      end
	      
	      p 'Displaying scoreboard'
	      p @scoreboard
	      p @dest = @scoreboard.key(@scoreboard.values.max)
    end
    
    self.update_board(@cpu)
    self.human_move
  end
  
  
  
  def update_board(player_move)
    
    @spots.keys.each do |a|
  	  @spots[@dest] = player_move if @spots[@dest] == ''
    end
    
    @spots.each do |a|
      @data.keys.each do |b|
        # loop 3 times per row
        for i in 0..2
          @data[b][i][1] = a[1] if @data[b][i][0] == a[0]
        end
      end
    end
    p 'Updating board complete.'
    @turn_number = @turn_number + 1
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
        raise RuntimeError, '~~~~~~~~~~~~~~~~~~~~~~~~~~ Computer wins! ~~~~~~~~~~~~~~~~~~~~~~~~~~'
      elsif @spots.select{|k,v| v == ''}.count == 0
        self.print_board
        raise RuntimeError, '~~~~~~~~~~~~~~~~~~~~~~~~~~ DRAW! ~~~~~~~~~~~~~~~~~~~~~~~~~~'
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
      if a[1] == ''
        value = ' ' 
      elsif a[1] != ''
        value = a[1]
      end
      row = row + "|#{value}"
      if i%3 == 0 && i != 0
        p row + "|"
        p '_______'
        row.clear
      end
      i = i+1
    end
  end
    
end

