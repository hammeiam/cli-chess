class Board
  attr_reader :black_sq, :board

  def initialize(setup = true)
    @board = Array.new(8) { Array.new(8) }
    @black_sq = "\u25A0"
    board_setup if setup
  end

  def [](pos)
    x, y = pos
    @board[x][y]
  end

  def []=(pos, piece)
    x, y = pos
    @board[x][y] = piece
  end

  def dup
    dup_board = Board.new(false)

    dup_board.board.each_with_index do |row, x|
      row.each_index do |y|
        piece = self[[x, y]]
        dup_board[[x, y]] = piece.class.new(dup_board, [x, y], piece.color) unless piece.nil?
      end
    end

    dup_board
  end

  def move!(start_pos, end_pos)
    self[start_pos], self[end_pos] = nil, self[start_pos]
    self[end_pos].pos = end_pos
  end

  def move(start_pos, end_pos, color)
    piece = self[start_pos]
    raise StartPositionEmpty.new 'Your starting position is empty' if piece.nil?
    raise InvalidMove.new "That's not your piece!" unless piece.color == color
    raise InvalidMove.new "Piece can't move there" unless piece.moves.include?(end_pos)
    raise InvalidMove.new 'That move would put you in check' if piece.move_into_check?(end_pos)
    move!(start_pos, end_pos)
  end

  def in_check?(color)
    opp_color = (color == :white ? :black : :white)
    all_moves = []
    pieces_array(opp_color).each { |piece| all_moves += piece.moves }
    all_moves.any? { |pos| self[pos].class == King && self[pos].color == color }
  end

  def checkmate?(color)
    in_check?(color) && pieces_array(color).all? { |p| p.valid_moves.empty? }
  end

  def pieces_array(color)
    @board.flatten.compact.select { |piece| piece.color == color }
  end

  def display(player_color)
    system('clear') # check warnings about string literals for unicode

    white_move = player_color == :white
    temp_board = (white_move ? @board.reverse.map(&:reverse) : @board)
    
    col_letters = (white_move ? [*'a'..'h'] : [*'a'..'h'].reverse)
    row_nums = (white_move ? [*'1'..'8'].reverse : [*'1'..'8'])
    output = ""
    
    temp_board.each_with_index do |row, row_idx|
      output += row_nums[row_idx]
      row.each_with_index do |el, col_idx|
        sq_color = square_color(row_idx, col_idx)
        if el.nil?
          output += '  '.colorize(background: sq_color)
        else
          output += (el.icon + ' ').colorize(background: sq_color)
        end
      end
      output += "\n"
    end
    
    output += '.'.white + col_letters.join(' ')
    puts output
  
  end
  
  def square_color(idx1, idx2)
    if (idx1.even? && idx2.even?) || (idx1.odd? && idx2.odd?)
      :light_green
    else
      :green
    end
  end

  def board_setup
    setup_pawns
    setup_back_rows
  end

  def setup_pawns
    8.times do |col|
      [1, 6].each do |row|
        piece_color = (row <= 1 ? :white : :black)
        Pawn.new(self, [row, col], piece_color)
      end
    end
  end

  def setup_back_rows
    [[0, :white], [7, :black]].each do |(x, color)|
      pieces = [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]
      pieces.each_with_index do |klass, y|
        pos = x, y
        klass.new(self, pos, color)
      end
    end
  end
end