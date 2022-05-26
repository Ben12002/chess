
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

    full_move_range.push(Position.new(x + 1, y - 1)) if (x + 1) >= 0 && (y - 1) >= 0
    full_move_range.push(Position.new(x, y - 1)) if (y - 1) >= 0 
    full_move_range.push(Position.new(x - 1, y - 1)) if (x - 1) >= 0 && (y - 1) >= 0
    full_move_range
  end

  def get_attacked_tiles(board)
    get_full_move_range
  end

  def get_legal_moves(board, ply)
    legal_moves = get_full_move_range.filter{|tile| !board.threatened_tile?(@color, tile)}
    if @color == "white"
      castle_short = Position.new(6,0)
      castle_long = Position.new(2,0)
    else
      castle_short = Position.new(6,7)
      castle_long = Position.new(2,7)
    end
    legal_moves.push(castle_short) if can_castle?("short", board, @color)
    legal_moves.push(castle_short) if can_castle?("long", board, @color)
    
    legal_moves
  end

  def can_castle?(castle_direction, board, color)
    if color == "white"
      long_rook_file = 0
      short_rook_file = 7
      rook_rank = 0
    else
      long_rook_file = 7
      short_rook_file = 0
      rook_rank = 7
    end

    if castle_direction == "short"
      return false if board.rook_moved_already?(@color, short_rook_file, rook_rank)
    else
      return false if board.rook_moved_already?(@color, long_rook_file, rook_rank)
    end

    return false if @moved_already
    return false if (board.threatened_tile?(@color, Position.new(5,rook_rank)) || board.threatened_tile?(@color, Position.new(6,rook_rank))) && castle_direction == "short"
    return false if (board.threatened_tile?(@color, Position.new(2,rook_rank)) || board.threatened_tile?(@color, Position.new(3,rook_rank))) && castle_direction == "long"
    return false if board.rook_moved_already?(@color, short_rook_file) && castle_direction == "short"
    return false if board.rook_moved_already?(@color, long_rook_file) && castle_direction == "long"
    # no pieces between king and rook
    return false if (!board.square_empty?(Position.new(5,rook_rank)) || !board.square_empty?(Position.new(6,rook_rank)) ) && castle_direction == "short"
    return false if (!board.square_empty?(Position.new(1,rook_rank)) || !board.square_empty?(Position.new(2,rook_rank)) || !board.square_empty?(Position.new(3,rook_rank))) && castle_direction == "long"


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