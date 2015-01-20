require_relative 'piece'

class SteppingPiece < Piece

  KING_DELTAS = [[ 0,-1], [-1,0], [0,1], [1, 0],[-1,-1], [-1,1], [1,1], [1,-1]]
  KNIGHT_DELTAS = [[-2, -1],[-2, 1],[-1, -2],[-1, 2],[1, -2],[1, 2], [2, -1], [2, 1]]
  
  def moves
    moves_list = []

    piece_deltas.each do |delta|
      temp_move = [@pos.first + delta.first, @pos.last + delta.last]
      moves_list << temp_move if move_valid?(temp_move)
    end
    
    moves_list.uniq
  end
end