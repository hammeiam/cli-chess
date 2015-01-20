#encoding: utf-8
require_relative 'sliding_piece'

class Rook < SlidingPiece
  
  def initialize(board, pos, color)
    super
    @icon = (color == :white ? "♖" : "♜")
    @value = 5
  end
  
  def piece_deltas
    SIDE_DELTAS
  end 
  
end