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
		
		@zones = Hash[
		  'corner', ['00','02','20','22'],
		  'middle', ['11'],
		  'edge', ['01','10','12','21']		  		  
		]
		
		@data = Hash[
			#Horizontal rows
		  '1', [['00', ''], ['01', ''], ['02', '']],
	 		'2', [['10', ''], ['11', ''], ['12', '']],
			'3', [['20', ''], ['21', ''], ['22', '']],
			#Vertical rows
			'4', [['00', ''], ['10', ''], ['20', '']],
			'5', [['01', ''], ['11', ''], ['21', '']],
			'6', [['02', ''], ['12', ''], ['22', '']],
			# Diagonal rows
			'7', [['00', ''], ['11', ''], ['22', '']],
			'8', [['20', ''], ['11', ''], ['02', '']]
		]
		
    self.save
    p 'New game started!'
    self.print_board
    
    p "Choose X or O! (Remember that X goes first)"
    if @human != 'X' || @human != 'O'
      @human = gets.chomp
      p 'Please choose X or O.'
    end
    @human == 'X' ? @cpu = 'O' : @cpu = 'X'
    
    p "So you\'re #{@human}, eh? Prepare to lose!"
    @human == 'X' ? self.human_move : self.computer_move
    
  end

	
	def save
	  
    File.open(File.join(File.dirname(__FILE__) , 'data.yml'), 'w') {|f| f.write(@data.to_yaml) }
    File.open(File.join(File.dirname(__FILE__) , 'spots.yml'), 'w') {|f| f.write(@spots.to_yaml) }
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
      end
    end
	  
    self.update_board(@human)
    self.computer_move
  end
  
  
  def computer_move
    @dest = ''
    p 'Computer\'s turn'

		# 1 - Prioritize winning moves
		#==============================
		@data.keys.each do |board_row|

      row = Array.new
      
      # loop 3 times per row and add the player marker to the row array
      for i in 0..2
        row << @data[board_row][i][1]
      end
              
      human_count = row.count(@human)
      cpu_count = row.count(@cpu)

	    if ( human_count == 0 and cpu_count == 2 )
        @data[board_row].each do |b|
          if b[1].length == 0
	          @dest = b[0] 
            break board_row
          end
        end
      end
      
    end
    
    
    # 2 - Prioritize blocking opponent wins
		#=======================================
		if @dest == ''
		  
		  @data.keys.each do |board_row|
		  
        row = Array.new
      
        # loop 3 times per row and add the player marker to the row array
        for i in 0..2
          row << @data[board_row][i][1]
        end
            
        human_count = row.count(@human)
        cpu_count = row.count(@cpu)
        
	      if ( human_count == 2 and cpu_count == 0 )
	        @data[board_row].each do |b|
            if b[1].length == 0
	            @dest = b[0]
              break board_row
            end
          end
        end
      end
      
    end


    # 3 - How to deal with a lightsaber (xoo,oox) or a sandwich(oxo,xox)!
		#===================================================
		if @dest == ''
		  
		  @data.keys.each do |board_row|
							
        row = Array.new
      
        # loop 3 times per row and add the player marker to the row array
        for i in 0..2
          row << @data[board_row][i][1]
        end
            
        human_count = row.count(@human)
        cpu_count = row.count(@cpu)

				if board_row.to_i > 6
					if ( human_count == 2 and cpu_count == 1 )
						open_zone_spots = Array.new
						@zones['edge'].each do |spot|
						  open_zone_spots << spot if @spots.select{|k,v| k==spot and v==''}.count > 0
						end
						@dest = open_zone_spots.shuffle.first if open_zone_spots.count > 0
					elsif ( human_count == 1 and cpu_count == 2 )
					  open_zone_spots = Array.new
						@zones['corner'].each do |spot|
						  open_zone_spots << spot if @spots.select{|k,v| k==spot and v==''}.count > 0
						end
						@dest = open_zone_spots.shuffle.first if open_zone_spots.count > 0
					end
				end
				
      end
    end
    
    
		# 2 - Prioritize spots belonging to the highest number of blank rows
		#===================================================================
    if @dest == ''
		  @scoreboard = Hash.new
		  
	      # loop through all blank spots and add 1 to the score for each blank row the spot belongs to
	      @spots.select{|k,v| v == ''}.each do |a|
	        current_spot = a[0]
	        current_spot_score = 0

	        #loop through every spot in a row
	        @data.each do |b|
	          current_spot_score = current_spot_score + 1 if b[1].select{|k,v| k == current_spot}.count == 1 && b[1].select{|k,v| v == ''}.count == 3
	        end
	        @scoreboard.store(current_spot, current_spot_score)
	      end
	      
        @dest = @scoreboard.key(@scoreboard.values.max)
    end
    
    self.update_board(@cpu)
    self.human_move
  end
  
  
  def update_board(player_move)
    
    self.end_game("Incorrect destination detected: #{@dest}") if !@spots.has_key?(@dest)
    
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
    
    @turn_number = @turn_number + 1
    self.save
    p 'Board update and save complete.'
    self.win_check
    self.print_board
    
  end
  
  
  def win_check
    
    @data.keys.each do |a|
      row = ''
      # loop 3 times per row
      for i in 0..2
        row = row + @data[a][i][1]
      end
      human_count = row.count(@human)
      cpu_count = row.count(@cpu)
      if human_count == 3
        end_game('Human wins!')
      elsif cpu_count == 3
        end_game('Computer wins!')
      elsif @spots.select{|k,v| v == ''}.count == 0
        end_game('Draw!')
      end
    end
    
	end
	
	
	def end_game(message)
	  self.print_board
	  p message
	  p 'Would you like to play again? (y or n)'
	  play_again = gets.chomp
	  if play_again == 'y' or play_again == 'Y'
	    g = Game.new
	  else
	    raise 'Thank you for playing!'
	  end
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
        p '-------'
        row.clear
      end
      i = i+1
    end
  end
  
end