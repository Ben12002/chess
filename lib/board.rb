class Board


  def initialize
    @arr = [[" ", " ", " ", " ", " ", " ", " ", " "],
            [" ", " ", " ", " ", " ", " ", " ", " "],
            [" ", " ", " ", " ", " ", " ", " ", " "],
            [" ", " ", " ", " ", " ", " ", " ", " "],
            [" ", " ", " ", " ", " ", " ", " ", " "],
            [" ", " ", " ", " ", " ", " ", " ", " "],
            [" ", " ", " ", " ", " ", " ", " ", " "],
            [" ", " ", " ", " ", " ", " ", " ", " "]]
    set_up_board
  end

  def set_up_board
    @white_pieces = create_pieces("white")
    @black_pieces = create_pieces("black")
    put_pieces_on_board(@white_pieces)
    put_pieces_on_board(@black_pieces)
  end

  def create_pieces(color)
    pieces = []

    if color == "white"
      pawn_y_position = 1
      piece_y_position = 0
    else
      pawn_y_position = 6
      piece_y_position = 7
    end

    8.times do |x_position|
      start_position = [x_position, pawn_y_position]
      pieces.push(Pawn.new(start_position, color))
    end

    pieces.push(Rook.new([0,piece_y_position], color))
    pieces.push(Rook.new([7,piece_y_position], color))

    pieces.push(Knight.new([1, piece_y_position], color))
    pieces.push(Knight.new([6, piece_y_position], color))

    pieces.push(Bishop.new([2,piece_y_position], color))
    pieces.push(Bishop.new([5,piece_y_position], color))

    pieces.push(Queen.new([3,piece_y_position], color))
    pieces.push(King.new([4,piece_y_position], color))

    pieces
  end

  def put_pieces_on_board(list_of_pieces)
    list_of_pieces.each do |piece|
      x = piece.position[0]
      y = piece.position[1]

      arr[x][y] = piece

    end
  end

  def display
  end

  def move(player, from, to, ply)
    x = from[0]
    y = from[1]
    piece_to_move = @arr[x][y]
    @arr[x][y] = " "
    piece_to_move.move(to, ply)
  end

  def legal_move?(from, to, ply)
    x = from[0]
    y = from[1]
    piece_to_move = @arr[x][y]
    piece_to_move.get_legal_moves(board, ply).include?(to)
  end

  def player_in_check?(color)
    return @white_pieces.find{|piece| object.is_a?(king)}.in_check? if color == "white"
    return @black_pieces.find{|piece| object.is_a?(king)}.in_check? if color == "black"
  end

  def all_attacked_tiles(color)
    pieces = (color == "white") ? @white_pieces : @black_pieces
    return pieces.reduce([]){|acc, curr| acc += curr.get_tiles_attacked}
  end

  def can_be_en_passant?(piece)

  end

  # return false if square referred to by from is either 
  # empty, or has an opponent piece on it.
  # return false if format is wrong.
  def valid_from?(player, x, y)
    !square_empty?(x,y) && players_piece?(player, x, y)
  end

  def players_piece?(player, x, y)
    @arr[x][y].color == player.color
  end

  def square_empty?(col, row)
    @arr[col][row] == " "
  end

  def same_color?(color, col, row)
    !board.square_empty?(col, row) && @arr[col][row].color == color
  end

end
