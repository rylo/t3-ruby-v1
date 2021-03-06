		@spots = {
		  '00' => 0, '01' => 0, '02' => 0, 
		  '10' => 0, '11' => 0, '12' => 0,
		  '20' => 0, '21' => 0, '22' => 0
		}
		
		@data = [
		  {'00', '01', '02'},
	 		{'10', '11', '12'},
			{'20', '21', '22'},
			{'00', '10', '20'},
			{'01', '11', '21'},
			{'02', '12', '22'},
			{'00', '11', '22'},
			{'20', '11', '02'}
		]
		
		@data = {
		  1=>['00', '01', '02'],
	 		2=>['10', '11', '12'],
			3=>['20', '21', '22'],
			4=>['00', '10', '20'],
			5=>['01', '11', '21'],
			6=>['02', '12', '22'],
			7=>['00', '11', '22'],
			8=>['20', '11', '02']
		}
		
		
		@data = [
		  [1, ['00', ''], ['01', ''], ['02', '']],
	 		[2=>['10', ''], ['11', ''], ['12', '']],
			[3=>['20', ''], ['21', ''], ['22', '']],
			[4=>['00', ''], ['10', ''], ['20', '']],
			[5=>['01', ''], ['11', ''], ['21', '']],
			[6=>['02', ''], ['12', ''], ['22', '']],
			[7=>['00', ''], ['11', ''], ['22', '']],
			[8=>['20', ''], ['11', ''], ['02', '']]
		]
		
		@data = [
		  ['00', '01', '02'],
	 		['10', '11', '12'],
			['20', '21', '22'],
			['00', '10', '20'],
			['01', '11', '21'],
			['02', '12', '22'],
			['00', '11', '22'],
			['20', '11', '02']
		]
		
		@data = {
		  0=>{'00', '01', '02'},
	 		1=>{'10', '11', '12'},
			2=>{'20', '21', '22'},
			3=>{'00', '10', '20'},
			4=>{'01', '11', '21'},
			5=>{'02', '12', '22'},
			6=>{'00', '11', '22'},
			7=>{'20', '11', '02'}
		}
		
  def check_board(marker)
    n = 0
    check = @spots.merge(@board){|key, first, second| first + " " + second }
    
    @data.each do |a|
      a.each do |b|
        #n = n + b[1]
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
  
  
  
  
  
  
  
  
    def update_board
    @spots.each do |a|
      @data.keys.each do |a|
        for i in 0..2
          @data[a][i][1] = a[1] if if @spots[a] == ''
        end
      end
    end
  end
  
  
  
  
  
  
  
  
  	@zones = {
		  'corners', ['00', '02', '20', '22'],
		  'middle', ['01'],
		  'betweens', ['10', '11', '12','21']
		}
		
		
		
		
		
		
		
		
		
		
		
		
		   @scoreboard.sort_by{ |k, v| v['score'] }.reverse.each do |a|
	      
	      # go through each zone (pre_dest_zone)
	      pre_dest_zone = a[1]['zone']
	      @spots.select{|k,v| v == ''}.each do |b|
          # for each empty spot on board (b[0]):
          if @zones['zones'][pre_dest_zone]['spots'].count(b[0]) > 0
            break b if @dest_zone = pre_dest_zone
          end
        end
	      
	      # 3.1 Middle zone
	      @zones['zones'][@dest_zone]['spots']
		    zone_spots = @zones['zones'][@dest_zone]['spots'][0]
		    while @dest == ''
		      @spots.select{|k,v| k == zone_spots}.each do |a|
		        @dest = a[0] if zone_spots != ''
		      end
		    end
        if @spots.key(zone_spots)
          @dest = zone_spots
        end
        
	    end
    end
		
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  