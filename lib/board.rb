require_relative "colorizer"
require_relative "position"
require_relative "pawn"
require_relative "king"
require_relative "queen"
require_relative "rook"
require_relative "bishop"
require_relative "knight"
require_relative "piece"
require_relative "display"

class Board

  attr_reader :white_pieces

  include Colorizer, Display


  def initialize()
    @arr = [[" ", " ", " ", " ", " ", " ", " ", " "],
            [" ", " ", " ", " ", " ", " ", " ", " "],
            [" ", " ", " ", " ", " ", " ", " ", " "],
            [" ", " ", " ", " ", " ", " ", " ", " "],
            [" ", " ", " ", " ", " ", " ", " ", " "],
            [" ", " ", " ", " ", " ", " ", " ", " "],
            [" ", " ", " ", " ", " ", " ", " ", " "],
            [" ", " ", " ", " ", " ", " ", " ", " "]]
    set_up_board
    @board_states = []
  end

  def ==(other)
    self.to_s == other.to_s
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
      update_square(piece, piece.file, piece.rank)
    end
  end
  
  def move(from, to, ply)
    piece_to_move = get_square(from.file, from.rank)
    if castle?(piece_to_move, from, to)
      castle(from, to, ply) 
    elsif en_passant?(piece_to_move, from, to)
      en_passant(from, to, ply)
    else
      regular_move(from, to, ply)
    end
    update_board_states
  end

  def regular_move(from, to, ply)
    piece_to_move = get_square(from.file, from.rank)
    update_square(" ", from.file, from.rank)
    capture_piece(to) unless square_empty?(to.file, to.rank)
    update_square(piece_to_move, to.file, to.rank)
    piece_to_move.move(to, ply)
  end

  def update_board_states
    board_copy = Marshal.load(Marshal.dump(self))
    @board_states.push(board_copy.to_s)
  end

  def threefold_repetition?
    @board_states.filter {|state| state == self.to_s}.length == 3
  end

  def promotion?(from, to)
    piece_to_move = get_square(from.file, from.rank)
    return false if !piece_to_move.is_a?(Pawn)
    (piece_to_move.color == "white" && to.rank == 7) ||
    (piece_to_move.color == "black" && to.rank == 0)
  end

  def promote(from, to, piece_type)
    pawn_to_promote = get_square(from.file, from.rank)
    pieces = (pawn_to_promote.color == "white") ? @white_pieces : @black_pieces
    capture_piece(from)
    
    case piece_type
    when "queen"
      new_piece = Queen.new(to, pawn_to_promote.color)
    when "rook"
      new_piece = Rook.new(to, pawn_to_promote.color)
    when "bishop"
      new_piece =  Bishop.new(to, pawn_to_promote.color)
    when "knight"
      new_piece = Knight.new(to, pawn_to_promote.color)
    end
    # these two lines could be turned into a #add_piece method
    pieces.push(new_piece)
    update_square(new_piece, to.file, to.rank)
  end

  def capture_piece(position)
    captured_piece = get_square(position.file, position.rank)
    update_square(" ", position.file, position.rank)
    
    if captured_piece.color == "white"
      @white_pieces.delete(captured_piece)    
    else
      @black_pieces.delete(captured_piece)
    end
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
    square_empty?(to.file, to.rank) && 
    piece_to_move.get_attacked_tiles(self).include?(to) && 
    same_color?(opposite_color, tile_beside.file, tile_beside.rank)
  end

  def castle(from, to, ply)
    piece_to_move = get_square(from.file, from.rank)
    # short castle
    if to == Position.new(6,from.rank)
      rook = get_short_rook(piece_to_move.color)
      previous_rook_file = rook.file
      new_rook_file = 5
    # long castle
    elsif to == Position.new(2,from.rank)
      rook = get_long_rook(piece_to_move.color)
      previous_rook_file = rook.file
      new_rook_file = 3
    end

    # move rook
    update_square(" ", previous_rook_file, from.rank)
    update_square(rook, new_rook_file, from.rank)
    rook.move(Position.new(new_rook_file, from.rank), ply)

    # move king
    update_square(" ", from.file, from.rank)
    piece_to_move.move(to, ply)
    update_square(piece_to_move, to.file, to.rank)
  end
  
  def castle?(piece_to_move, from, to)
    return false if !piece_to_move.is_a?(King)
    (from.file == 4) && ((from.file - to.file).abs == 2)
  end

  def short_castle_tiles_threatened?(color)
    rook_rank = color == "white" ? 0 : 7
    threatened_tile?(color, Position.new(5,rook_rank)) || threatened_tile?(color, Position.new(6,rook_rank))
  end

  def long_castle_tiles_threatened?(color)
    rook_rank = color == "white" ? 0 : 7
    threatened_tile?(color, Position.new(2,rook_rank)) || threatened_tile?(color, Position.new(3,rook_rank))
  end

  def short_castle_tiles_obstructed?(color)
    short_rook_file = color == "white" ? 7 : 0
    rook_rank = color == "white" ? 0 : 7
    !square_empty?(5,rook_rank) || !square_empty?(6,rook_rank)
  end

  def long_castle_tiles_obstructed?(color)
    long_rook_file = color == "white" ? 0 : 7
    rook_rank = color == "white" ? 0 : 7
    !square_empty?(1,rook_rank) || !square_empty?(2,rook_rank) || !square_empty?(3,rook_rank)
  end

  def rook_moved_already?(color, file, rank)
    pieces = color == "white" ? @white_pieces : @black_pieces
    pieces.find do |piece| 
      piece.is_a?(Rook) &&
      piece.moved_already &&
      piece.file == file && 
      piece.rank == rank
    end
  end

   # return all tiles attacked by pieces of a given color.
   def all_attacked_tiles(color)
    pieces = (color == "white") ? @white_pieces : @black_pieces
    pieces.reduce([]) do |acc, curr| 
      acc + curr.get_attacked_tiles(self)
    end
  end

  # whether a tile is threatened from the perspective of color.
  def threatened_tile?(color, tile)
    opposite_color = (color == "white") ? "black" : "white"
    all_attacked_tiles(opposite_color).include?(tile)
  end

  def get_short_rook(color)
    rank = color == "white" ? 0 : 7
    get_square(7, rank)
  end

  def get_long_rook(color)
    rank = color == "white" ? 0 : 7
    get_square(0, rank)
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
    king_vs_king? ||
    king_and_knight_vs_king? ||
    king_and_bishop_vs_king? ||
    same_color_bishop_draw?
  end

  def king_vs_king?
    @white_pieces.length == 1 && @black_pieces.length == 1
  end

  def king_and_knight_vs_king?
    [@white_pieces.length, @black_pieces.length].max <= 2 &&
    (@white_pieces.filter { |piece| piece.is_a?(Knight) || piece.is_a?(King)}.length == 2 && @black_pieces.length == 1) ||
    (@black_pieces.filter { |piece| piece.is_a?(Knight) || piece.is_a?(King)}.length == 2 && @white_pieces.length == 1)
  end

  def king_and_bishop_vs_king?
    [@white_pieces.length, @black_pieces.length].max <= 2 &&
    (@white_pieces.filter { |piece| piece.is_a?(Bishop) || piece.is_a?(King)}.length == 2 && @black_pieces.length == 1) ||
    (@black_pieces.filter { |piece| piece.is_a?(Bishop) || piece.is_a?(King)}.length == 2 && @white_pieces.length == 1)
  end

  def same_color_bishop_draw?
    return false if !bishop_vs_bishop?
    black_bishop = @black_pieces.find { |piece| piece.is_a?(Bishop)}
    white_bishop = @white_pieces.find { |piece| piece.is_a?(Bishop)}
    dark_tile?(white_bishop.file, white_bishop.rank) == dark_tile?(black_bishop.file, black_bishop.rank)
  end

  def bishop_vs_bishop?
    @white_pieces.length == 2 && 
    @black_pieces.length == 2 &&
    (@white_pieces.filter { |piece| piece.is_a?(Bishop) || piece.is_a?(king) }.length == 2) &&
    (@black_pieces.filter { |piece| piece.is_a?(Bishop) || piece.is_a?(king) }.length == 2)
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