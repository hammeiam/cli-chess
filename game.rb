require_relative 'pieces'
require_relative 'board'
require_relative 'errors'
require 'colorize'

class Game
  attr_reader :board
  
  def initialize(player1, player2)
    @player1 = Player.new(player1, :white)
    @player2 = Player.new(player2, :black)
    @board = Board.new()
    @taken_by_white = []
    @taken_by_black = []
  end

  def play_game
    cur_player = @player1

    until game_over?
      @board.display(cur_player.color)
      puts "Oh no, you're in check!" if @board.in_check?(cur_player.color)
      show_stats
      take_turn(cur_player)
      cur_player = (cur_player == @player1 ? @player2 : @player1)
    end

    display_outcome
  end
  
  def checkmated?
    @board.checkmate?(:white) || @board.checkmate?(:black)
  end
  
  def stalemate?
    white_cant_move = @board.pieces_array(:white).all?{ |p| p.valid_moves.empty? }
    black_cant_move = @board.pieces_array(:black).all?{ |p| p.valid_moves.empty? }
    (!@board.in_check?(:white) && white_cant_move) || (!@board.in_check?(:black) && black_cant_move)
  end

  def display_outcome
    if checkmated?
      winner = (@board.checkmate?(:white) ? @player2 : @player1)
    elsif stalemate?
      winner = @player1
      puts "Stalemate.  Everybody wins!"
      return
    else #ran out of time
      winner = (@player1.game_time < 0 ? @player2 : @player1)
    end
    @board.display(winner.color)
    puts "#{ winner.name } won the game!"
  end
  
  def show_stats
    white_points = @taken_by_white.reduce(0){ |total, piece| total + piece.value}
    black_points = @taken_by_black.reduce(0){ |total, piece| total + piece.value}    
    
    unless @taken_by_white.empty? && @taken_by_black.empty?
      white_arr = @taken_by_white.sort_by{|p| p.value }.reverse.map{|p| p.icon }
      black_arr = @taken_by_black.sort_by{|p| p.value }.reverse.map{|p| p.icon }
      puts "White: #{white_points} points,#{white_arr.join(' ')}"
      puts "Black: #{black_points} points,#{black_arr.join(' ')}"
    end
  end

  def convert_coordinates(user_input)
    letter_map = Hash[[*'a'..'h'].reverse.zip([*0..7])]
    move1, move2 = user_input.split
    [move1, move2].map do |coord|
      chars = coord.split('')
      chars[0] = letter_map[chars.first]
      [chars[1].to_i - 1, chars[0]]
    end
  end

  def take_turn(player)
    puts "#{player.name}s move. Time Remaining: #{player.game_time/60}m#{player.game_time%60}s "
    start_time = Time.now
    begin
      print ":".blink
      start_pos, end_pos = convert_coordinates(gets.chomp)
      piece_at_end_pos = @board[end_pos]
      @board.move(start_pos, end_pos, player.color)
    rescue StandardError => e
      puts "#{e.message}"
      retry
    end
    player.game_time -= (Time.now - start_time).round
    if player.color == :white 
      @taken_by_white << piece_at_end_pos unless piece_at_end_pos.nil?
    else
      @taken_by_black << piece_at_end_pos unless piece_at_end_pos.nil?
    end
  end

  def game_over?
    @board.checkmate?(:white) || @board.checkmate?(:black) || 
    @player1.game_time <= 0 || @player2.game_time <= 0 || stalemate?
  end
  
end

class Player
  attr_reader :color, :name
  attr_accessor :game_time
  
  def initialize(name, color)
    @name = name
    @color = color
    @game_time = 900  #15 min in seconds
  end
  
end

game = Game.new('Justin', 'David')
# king = King.new(game.board, [0,0], :black)
# rook1 = Rook.new(game.board, [2,2], :white)
# rook2 = Rook.new(game.board, [2,1], :white)

game.play_game