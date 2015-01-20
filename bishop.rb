#encoding: utf-8
require_relative 'sliding_piece'

class Bishop < SlidingPiece
  
  def initialize(board, pos, color)
    super
    @icon = (color == :white ? "♗" : "♝")
    @value = 3
  end
  
  def piece_deltas
    DIAGONAL_DELTAS
  end 
  
end