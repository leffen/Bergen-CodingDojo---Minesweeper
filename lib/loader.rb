require 'pp'

class MinesweeperLoader
  attr_accessor :games
  
  def loadfile(filename)
    @games,game = [],false,nil

    File.readlines(filename).each do |line|
      if !game || game.is_compeletly_loaded then
        game = makeNewGame line
      else
        game.add_line(line) 
      end
    end

    @games
  end
  
  private
  def makeNewGame(line)
    @game_num = (@game_num|| 0)  + 1 
    dimensions = line.split(" ")
    x = MineSweeperGame.new  @game_num,dimensions[0].to_i,dimensions[1].to_i
    @games<< x
    @games.last
  end
  
end


class MineSweeperGame
  attr_accessor :nr,:expected_rows,:expected_colums,:curr_row,:fields,:cells,:hints,:bombs
  
  def initialize(nr,rows,columns)
    @bombs = {}
    @nr,@expected_rows,@expected_colums,@curr_row = nr,rows,columns,0
  end
  
  def is_compeletly_loaded
    @curr_row >= @expected_rows
  end
  
  def add_line(line)
    line.strip.split(//).each_with_index{|char,index|@bombs[[@curr_row,index]]='*' if char=='*' }
    @curr_row = @curr_row + 1
  end
  
  def cell_is_bomb(r,k)
    @bombs[[r,k]]=='*' ? 1 : 0
  end
  
  def analyze
    @hints=[]
    (0...@expected_rows).each{|r|
      @hints[r]=[]
      (0...@expected_colums).each{|k|
        @hints[r][k]= cell_is_bomb(r,k) == 1 ? '*' :
                    cell_is_bomb(r-1,k-1) + cell_is_bomb(r-1,k) + cell_is_bomb(r-1,k+1) +
                    cell_is_bomb(r,k-1)   +                       cell_is_bomb(r,k+1) +
                    cell_is_bomb(r+1,k-1) + cell_is_bomb(r+1,k) + cell_is_bomb(r+1,k+1)
      }
    }

  end
  
  def nice_print
    puts "Game # #{@nr} rows=#{@expected_rows} columns=#{@expected_colums}"
    num_dots=(@expected_colums*4)
    puts "-"*num_dots
    (0...@expected_rows).each{|r|
      line = ""
      (0...@expected_colums).each{|k|
        line << ' ' + @hints[r][k].to_s + " |"  
      }
      puts line
    }
    puts "-"*num_dots
    puts ""
  end
  
end



