
class King < Piece

  attr_reader :moved_already

  def initialize(position, color)
    super(position, color)
    @moved_already = false
  end

  def unicode
    "\u265A"
  end

  def in_check?(board)
    board.player_in_check?(@color)
  end

  def get_full_move_range
    x = @position.file
    y = @position.rank
    full_move_range = []

    full_move_range.push(Position.new(x + 1, y + 1)) if (x + 1) < 8 && (y + 1) < 8
    full_move_range.push(Position.new(x, y + 1)) if x < 8 && (y + 1) < 8
    full_move_range.push(Position.new(x - 1, y + 1)) if (x - 1) >= 0 && (y + 1) < 8

    full_move_range.push(Position.new(x + 1, y)) if (x + 1) < 8
    full_move_range.push(Position.new(x - 1, y)) if (x - 1) >= 0

    full_move_range.push(Position.new(x + 1, y - 1)) if (x + 1) < 8 && (y - 1) >= 0
    full_move_range.push(Position.new(x, y - 1)) if (y - 1) >= 0 
    full_move_range.push(Position.new(x - 1, y - 1)) if (x - 1) >= 0 && (y - 1) >= 0
    full_move_range
  end

  def get_attacked_tiles(board)
    get_full_move_range
  end

  def get_legal_moves(board, ply)
    legal_moves = get_full_move_range.filter do |tile| 
      !board.threatened_tile?(@color, tile) && 
      !board.same_color?(@color, tile.file, tile.rank) &&
      !in_check_if_move?(board, tile, ply) 
    end
    if @color == "white"
      castle_short = Position.new(6,0)
      castle_long = Position.new(2,0)
    else
      castle_short = Position.new(6,7)
      castle_long = Position.new(2,7)
    end
    legal_moves.push(castle_short) if can_castle_short?(board)
    legal_moves.push(castle_long) if can_castle_long?(board)
    legal_moves
  end

  def can_castle_short?(board)
    short_rook_file = 7
    rook_rank = @color == "white" ? 0 : 7
    return false if @moved_already
    return false if board.rook_moved_already?(@color, short_rook_file, rook_rank) 
    return false if board.short_castle_tiles_threatened?(@color)
    return false if board.short_castle_tiles_obstructed?(@color)
    true
  end

  def can_castle_long?(board)
    long_rook_file = 0
    rook_rank = @color == "white" ? 0 : 7
    return false if @moved_already
    return false if board.rook_moved_already?(@color, long_rook_file, rook_rank)
    return false if board.long_castle_tiles_threatened?(@color)
    return false if board.long_castle_tiles_obstructed?(@color)
    true
  end

  def in_check?(board)
    under_attack?(board)
  end
  
  def move(to, ply=nil)
    @position = to
    @moved_already = true if !@moved_already
  end

end