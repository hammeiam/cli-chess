# encoding: utf-8
class Pawn < Piece
  MOVE_DELTAS = [[1, 0], [2, 0]]
  ATTACK_DELTAS = [[1, -1], [1, 1]]

  def initialize(board, pos, color)
    super
    @icon = (color == :white ? '♙' : '♟')
    @value = 1
  end

  def moves
    moves_list = []

    move_deltas.each do |delta|
      temp_move = [@pos.first + delta.first, @pos.last + delta.last]
      moves_list << temp_move if move_valid?(temp_move)
    end

    attack_deltas.each do |delta|
      temp_move = [@pos.first + delta.first, @pos.last + delta.last]
      moves_list << temp_move if opponent_piece?(temp_move)
    end

    moves_list
  end

  def move_valid?(move)
    super(move) && !opponent_piece?(move)
  end

  def unmoved?
    (@color == :white && @pos[0] == 1) || (@color == :black && @pos[0] == 6)
  end

  # def direction
  #   @color == :black ? -1 : 1
  # end

  def move_deltas
    deltas = MOVE_DELTAS
    deltas = deltas.map { |delta| [delta[0] * -1, delta[1]] } if @color == :black
    unmoved? ? deltas : deltas.take(1)
  end

  def attack_deltas
    deltas = ATTACK_DELTAS
    deltas = deltas.map { |delta| [delta[0] * -1, delta[1] * -1] } if @color == :black
    deltas
  end
end
