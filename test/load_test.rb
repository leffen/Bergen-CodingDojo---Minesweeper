# encoding: utf-8
require 'rubygems'
require 'test/unit'
require 'pp'
require_relative '../lib/loader'

class MineHintTest < Test::Unit::TestCase

  def setup
    @loader = Loader.new
  end

  def teardown
  end
  
  def test_loadfile_num_fields
    data = @loader.loadfile "./data/input1.txt"
    assert_equal(data.keys.count, 3)
  end
  
  def test_has_bomb
    data = @loader.loadfile "./data/input1.txt"
    data.each{|key,skjema|
      puts "Skjema #{skjema.nr}"
      skjema.analyze
      skjema.cells.each_with_index{|row,r|
        row.each_with_index{|cell,k|
          puts "r=#{r} k=#{k} cell=#{cell} has_bomb=#{skjema.have_bomb(r,k)}"
        }
      }
    }
    
  end
  
  def test_analyze
    data = @loader.loadfile "./data/input1.txt"
    data.each{|key,skjema|
      skjema.analyze
      puts "Skjema nr#{skjema.nr}"
      pp skjema.hints
    }
    
  end
  

  
  


end
