#encoding: utf-8
require_relative 'stepping_piece'

class Knight < SteppingPiece
  
  def initialize(board, pos, color)
    super
    @icon = (color == :white ? "♘" : "♞")
    @value = 3
  end
  
  def piece_deltas
    KNIGHT_DELTAS
  end 
  
end