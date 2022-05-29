require_relative "colorizer"
require_relative "position"
require_relative "pawn"
require_relative "king"
require_relative "queen"
require_relative "rook"
require_relative "bishop"
require_relative "knight"
require_relative "piece"

class Board

  attr_reader :white_pieces

  include Colorizer


  def initialize(arr=nil, white_pieces=nil, black_pieces=nil)
    if !arr && !white_pieces && !black_pieces
      @arr = [[" ", " ", " ", " ", " ", " ", " ", " "],
              [" ", " ", " ", " ", " ", " ", " ", " "],
              [" ", " ", " ", " ", " ", " ", " ", " "],
              [" ", " ", " ", " ", " ", " ", " ", " "],
              [" ", " ", " ", " ", " ", " ", " ", " "],
              [" ", " ", " ", " ", " ", " ", " ", " "],
              [" ", " ", " ", " ", " ", " ", " ", " "],
              [" ", " ", " ", " ", " ", " ", " ", " "]]
      set_up_board
    else
      @arr = arr
      @white_pieces = white_pieces
      @black_pieces = black_pieces
    end 
  end

  def get_square(file, rank)
    @arr[file][rank]
  end

  def update_square(element, file, rank)
    @arr[file][rank] = element
  end

  def dark_tile?(file, rank)
    (file - rank).abs.even?
  end

  # Displays board in different perspectives depending on current player.
  def display(current_player)
  end

  # Displays board in different perspectives depending on current player.
  def simple_display_with_index
    i = 0
    j = 7
    outstr = "\n"

    while j >= 0
      while i < 8
        outstr += colorize(get_square(i,j), i, j)
        i += 1
      end
      i = 0
      outstr += " #{j} \n"
      j -= 1
    end
    outstr += " 0  1  2  3  4  5  6  7"
    puts outstr
  end

  def to_s
    i = 0
    j = 7
    outstr = ""
    while j >= 0
      while i < 8
        outstr += colorize(get_square(i,j), i, j)
        i += 1
      end
      i = 0
      outstr += "\n"
      j -= 1
    end
    outstr
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
      # @arr[piece.file][piece.rank] = piece
      update_square(piece, piece.file, piece.rank)
    end
  end
  
  def move(from, to, ply)
    piece_to_move = @arr[from.file][from.rank]
    
    if castle?(piece_to_move, from, to)
      castle(from, to) 
    elsif en_passant?(piece_to_move, from, to)
      en_passant(from, to, ply)
    elsif pawn_double_move?(piece_to_move, from, to)
      pawn_double_move()
    elsif promotion?(piece_to_move, from, to)
      promotion()
    else
      # p get_square(from.file, to.file)
      @arr[from.file][from.rank] = " "
      capture_piece(to) unless square_empty?(to.file, to.rank)
      @arr[to.file][to.rank] = piece_to_move
      piece_to_move.move(to, ply)
    end
    # Update pawns' en_passantable status
    update_all_pawns_status(ply)
  end

  def update_all_pawns_status(ply)
  end

  def pawn_double_move?(piece_to_move, from, to)
    false
  end

  def promotion?(piece_to_move, from, to)
    false
  end

  def en_passant(from, to, ply)
    piece_to_move = get_square(from.file, from.rank)
    if piece_to_move.color == "white"
      tile_beside = Position.new(to.file, to.rank - 1)
    else
      tile_beside = Position.new(to.file, to.rank + 1)
    end

    opponent_pawn = get_square(tile_beside.file, tile_beside.rank)
    capture_piece(opponent_pawn)
    
    piece_to_move.move(to, ply)
    update_square(" ", from.file, from.rank)
    update_square(piece_to_move, to.file, to.rank)
  end

  def en_passant?(piece_to_move, from, to)
    return false if !piece_to_move.is_a?(Pawn)

    if piece_to_move.color == "white"
      tile_beside = Position.new(to.file, to.rank - 1)
      opposite_color = "black"
    else
      tile_beside = Position.new(to.file, to.rank + 1)
      opposite_color = "white"
    end
    square_empty?(to.file, to.rank) && piece_to_move.get_attacked_tiles(self).include?(to) && same_color?(opposite_color, tile_beside.file, tile_beside.rank)
  end

  def castle(from, to)
    piece_to_move = @arr[from.file][from.rank]
    # short castle
    if to == Position.new(6,from.rank)
      rook = get_short_rook(piece_to_move.color)
      @arr[7][from.rank] = " "
      @arr[5][from.rank] = rook
    # long castle
    elsif to == Position.new(2,from.rank)
      rook = get_long_rook(piece_to_move.color)
      @arr[0][from.rank] = " "
      @arr[3][from.rank] = rook
    end
    rook.move()
    piece_to_move.move(to, ply)
    @arr[to.file][to.rank] = piece_to_move
  end

  def castle?(piece_to_move, from, to)
    return false if !piece_to_move.is_a?(King)
    (from.file == 4) && ((from.file - to.file).abs == 2)
  end

  def get_short_rook(color)
    rank = color == "white" ? 0 : 7
    @arr[7][rank]
  end

  def get_long_rook(color)
    rank = color == "white" ? 0 : 7
    @arr[0][rank]
  end

  def rook_moved_already?(color, file, rank)
    pieces = color == "white" ? @white_pieces : @black_pieces
    pieces.find do |piece| 
      piece.is_a?(Rook) &&
      !piece.moved_already &&
      piece.file == file && 
      piece.rank == rank
    end
  end

  def capture_piece(position)
    captured_piece = @arr[position.file][position.rank]
    @arr[position.file][position.rank] = " "
    if captured_piece.color == "white"
      @white_pieces.delete(captured_piece)    
    else
      @black_pieces.delete(captured_piece)
    end
  end

  def legal_move?(from, to, ply)
    piece_to_move = @arr[from.file][from.rank]
    piece_to_move.get_legal_moves(self, ply).include?(to)
  end

  # Checks whether the player's king of a given color is in check
  def player_in_check?(color)
    return @white_pieces.find{|piece| piece.is_a?(King)}.in_check?(self) if color == "white"
    return @black_pieces.find{|piece| piece.is_a?(King)}.in_check?(self) if color == "black"
  end

  # return all tiles attacked by pieces of a given color.
  def all_attacked_tiles(color)
    pieces = (color == "white") ? @white_pieces : @black_pieces
    pieces.reduce([]) do |acc, curr| 
      acc + curr.get_attacked_tiles(self)
    end
  end

  # return false if square referred to by from is either 
  # empty, or has an opponent piece on it.
  # return false if format is wrong.
  def valid_from?(player, x, y, ply)
    players_piece?(player, x, y) && !@arr[x][y].get_legal_moves(self, ply).empty? 
  end

  def players_piece?(player, x, y)
    !square_empty?(x,y) && @arr[x][y].color == player.color
  end

  def square_empty?(x, y)
    @arr[x][y] == " "
  end

  def same_color?(color, x, y)
    !square_empty?(x, y) && @arr[x][y].color == color
  end

  # whether a tile is threatened from the perspective of color.
  def threatened_tile?(color, tile)
    opposite_color = (color == "white") ? "black" : "white"
    all_attacked_tiles(opposite_color).include?(tile)
  end

  def get_all_legal_moves(color, ply)
    pieces = (color == "white") ? @white_pieces : @black_pieces
    pieces.reduce([]){|acc, curr| acc + curr.get_legal_moves(self, ply)}
  end

  def no_legal_moves?(color, ply)
    get_all_legal_moves(color, ply).length == 0
  end

  def stalemate?(color, ply)
    !player_in_check?(color) && no_legal_moves?(color, ply)
  end

  def checkmate?(color, ply)
    player_in_check?(color) && no_legal_moves?(color, ply)
  end

  def insufficient_material?
    false #stub
  end

  def threefold_repetition?(ply)
    false #stub
  end

  def can_en_passant?(color, ply, tile)
    if color == "white"
      tile_beside = Position.new(tile.file, tile.rank - 1)
    else
      tile_beside = Position.new(tile.file, tile.rank + 1)
    end
    return false if square_empty?(tile_beside.file, tile_beside.rank)
    get_square(tile_beside.file, tile_beside.rank).can_be_en_passant?(ply)
  end

end