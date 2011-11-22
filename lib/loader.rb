require 'pp'

class Skjema
  attr_accessor :nr,:rows,:colums,:fields,:cells,:hints
  def initialize(nr,rows,columns)
    @fields=[]
    @nr,@rows,@columns = nr,rows,columns
  end
  
  def add_line(line)
    @fields << line
    @fields.count < @rows
  end
  
  def have_bomb(r,k)
    return 0 if (r>= @cells.count) || (r<0)
    return 0 if (k>=@cells[r].count) || (k<0)
    @cells[r][k]=='*' ? 1 : 0
  end
  
  def analyze
    @cells = @fields.each_with_object([]){|line,o|o<<line.strip.split(//)}
    @hints=[]
    
    @cells.each_with_index{|row,r|
      @hints[r]=[]
      row.each_with_index{|cell,k|
  
        @hints[r][k]= have_bomb(r,k) == 1 ? '*' :
                    have_bomb(r-1,k-1)+have_bomb(r-1,k) +have_bomb(r-1,k+1)+
                    have_bomb(r,k-1)+                    have_bomb(r,k+1)+
                    have_bomb(r+1,k-1)+have_bomb(r+1,k) +have_bomb(r+1,k+1)
      }
    }
  end
  
end


class Loader

  def loadfile(filename)
    fields,inbody,skjema,fnr = {},false,nil,-1

    File.readlines(filename).each do |line|
      if !inbody then
        fields[fnr]=skjema if fnr >= 0
        fnr=fnr+1
        tall = line.split(" ")
      
        skjema=Skjema.new fnr+1,tall[0].to_i,tall[1].to_i
        inbody = true
      else
        inbody = skjema.add_line(line) 
      end
    end

    fields[fnr]=skjema if fnr >= 0
    fields
  end
end

