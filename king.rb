#encoding: utf-8
require_relative 'stepping_piece'

class King < SteppingPiece
  
  def initialize(board, pos, color)
    super
    @icon = (color == :white ? "♔" : "♚")
    # @icon = unicode.encode('utf-8')
  end
  
  def piece_deltas
    KING_DELTAS
  end 
  
end