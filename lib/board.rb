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
    # set_up_board
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
      start_position = Position.new(x_position, pawn_y_position)
      pieces.push(Pawn.new(start_position, color))
    end

    pieces.push(Rook.new(Position.new(0,piece_y_position), color))
    pieces.push(Rook.new(Position.new(7,piece_y_position), color))

    pieces.push(Knight.new(Position.new(1, piece_y_position), color))
    pieces.push(Knight.new(Position.new(6, piece_y_position), color))

    pieces.push(Bishop.new(Position.new(2,piece_y_position), color))
    pieces.push(Bishop.new(Position.new(5,piece_y_position), color))

    pieces.push(Queen.new(Position.new(3,piece_y_position), color))
    pieces.push(King.new(Position.new(4,piece_y_position), color))

    pieces
  end

  def put_pieces_on_board(list_of_pieces)
    list_of_pieces.each do |piece|
      arr[piece.file][piece.rank] = piece
    end
  end

  def display
  end

  def move(from, to, ply)
    piece_to_move = @arr[from.file][from.rank]
    @arr[from.file][from.rank] = " "
    capture_piece(to) unless square_empty?(to.file, to.rank)
    @arr[to.file][to.rank] = piece_to_move
    piece_to_move.move(to, ply)
  end

  def capture_piece(position)
    captured_piece = @arr[position.file][position.rank]
    if captured_piece.color == "white"
      # will this delete more than 1 instance? e.g delete all rooks instead of only the intended one?
      #https://ruby-doc.org/core-3.0.1/Array.html#method-i-delete
      @white_pieces.delete(captured_piece)    
    else
      @black_pieces.delete(captured_piece)
  end

  def legal_move?(from, to, ply)
    piece_to_move = @arr[from.file][from.rank]
    piece_to_move.get_legal_moves(board, ply).include?(to)
  end

  def player_in_check?(color)
    return @white_pieces.find{|piece| object.is_a?(king)}.in_threat_range? if color == "white"
    return @black_pieces.find{|piece| object.is_a?(king)}.in_check? if color == "black"
  end

  # return all tiles attacked by pieces of a given color.
  def all_attacked_tiles(color)
    pieces = (color == "white") ? @white_pieces : @black_pieces
    pieces.reduce([]){|acc, curr| acc += curr.get_full_move_range}
  end

  def can_be_en_passant?(piece)

  end

  # return false if square referred to by from is either 
  # empty, or has an opponent piece on it.
  # return false if format is wrong.
  def valid_from?(player, x, y)
    !square_empty?(x,y) && players_piece?(player, x, y) && !@arr[x][y].get_legal_moves.empty?
  end

  def players_piece?(player, x, y)
    @arr[x][y].color == player.color
  end

  def square_empty?(x, y)
    @arr[x][y] == " "
  end

  def same_color?(color, x, y)
    !square_empty?(x, y) && @arr[x][y].color == color
  end

  # has to be able to differentiate between the original rook and any promoted rooks.
  def can_castle?(position, color)
    if color == "white"
      left_rook_file = 0
      right_rook_file = 7
      rook_rank = 0
      pieces = @white_pieces
    else
      left_rook_file = 7
      right_rook_file = 0
      rook_rank = 7
      pieces = @black_pieces
    end

    if pieces.filter{|tile|}
  end

  def threatened_tile?(color, tile)
    opposite_color = (color == "white") ? "black", "white"
    all_attacked_tiles(opposite_color).include?(tile)
  end


end
