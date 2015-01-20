require_relative 'piece'

class SlidingPiece < Piece
  SIDE_DELTAS     = [[ 0,-1], [-1,0], [0,1], [1, 0]]
  DIAGONAL_DELTAS = [[-1,-1], [-1,1], [1,1], [1,-1]]
    
  def moves
    moves_list = []

    piece_deltas.each do |delta|
      x, y = delta
      
      1.upto(7) do |multiple|
        temp_move = [@pos.first + (x * multiple), @pos.last + (y * multiple) ]
        
        if move_valid?(temp_move)
          moves_list << temp_move
          break if opponent_piece?(temp_move)
        else
          break
        end
      end
    end
    
    moves_list.uniq 
  end
end


