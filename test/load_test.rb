# encoding: utf-8
require 'rubygems'
require 'test/unit'
require 'pp'
require_relative '../lib/loader'

class MineHintTest < Test::Unit::TestCase

  def setup
    @loader = MinesweeperLoader.new
  end

  def teardown
  end
  
  def test_loadfile_num_fields
    games = @loader.loadfile "./data/input1.txt"
    assert_equal(games.count, 3)
  end
  
  def test_has_bomb
    games = @loader.loadfile "./data/input1.txt"
    games.each{|game|
      puts "Game #{game.nr}"
      game.analyze
      (0...game.expected_rows).each{|r|
        (0...game.expected_colums).each{|k|
          puts "r=#{r} k=#{k} has_bomb=#{game.cell_is_bomb(r,k)}"
        }
      }
    }
    
  end
  
  def test_analyze
    games = @loader.loadfile "./data/input1.txt"
    games.each{|game|
      game.analyze
      game.nice_print  
    }
  end

end
