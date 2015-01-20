class Piece
  attr_accessor :pos
  attr_reader :icon, :color, :value
  
  def initialize(board, pos, color)
    @board = board
    @pos = pos
    @color = color
    @value = nil
    @board[pos] = self
  end
  
  def move_into_check?(move_pos)
    dup_board = @board.dup
    dup_board.move!(@pos, move_pos)
    dup_board.in_check?(@color)
  end
  
  def move_valid?(pos)
    return false unless on_board?(pos)
    @board[pos].nil? ? true : opponent_piece?(pos)  
  end
  
  def on_board?(pos)
    pos.all?{ |coordinate| coordinate.between?(0,7) }
  end
  
  def opponent_piece?(pos)
    return false if !on_board?(pos) || @board[pos].nil?
    @board[pos].color != @color
  end
  
  def valid_moves
    moves.reject { |move| move_into_check?(move) }
  end
  
end