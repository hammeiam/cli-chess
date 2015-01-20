#encoding: utf-8
require_relative 'sliding_piece'

class Queen < SlidingPiece
  
  def initialize(board, pos, color)
    super
    @icon = (color == :white ? "♕" : "♛")
    @value = 9
  end
  
  def piece_deltas
    SIDE_DELTAS + DIAGONAL_DELTAS
  end 
  
end