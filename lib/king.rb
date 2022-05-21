class King < Piece

  def initialize(position, color)
    super(position, color)
    @moved_already = false
  end

  def in_check?(board)
    board.player_in_check?(@color)
  end

  def get_full_move_range
    x = @position.file
    y = @position.range
    full_move_range = []

    full_move_range.push(Position.new(x + 1, y + 1)) if (x + 1) < 8 && (y + 1) < 8
    full_move_range.push(Position.new(x, y + 1)) if x < 8 && (y + 1) < 8
    full_move_range.push(Position.new(x - 1, y + 1)) if (x - 1) >= 0 && (y + 1) < 8

    full_move_range.push(Position.new(x + 1, y)) if (x + 1) < 8
    full_move_range.push(Position.new(x - 1, y)) if (x - 1) >= 0

    full_move_range.push(Position.new(x + 1, y - 1)) if (x + 1) >= 0 && (y - 1) >= 0
    full_move_range.push(Position.new(x, y - 1)) if (y - 1) >= 0 
    full_move_range.push(Position.new(x - 1, y - 1)) if (x - 1) >= 0 && (y - 1) >= 0
  end

  def get_attacked_tiles(board)
    get_full_move_range
  end

  def get_legal_moves(board, ply)
    legal_moves = get_full_move_range.filter{|tile| !board.threatened_tile?(@color, tile)}
    if @color = "white"
      castle_short = Position.new(6,0)
      castle_long = Position.new(2,0)
    else
      castle_short = Position.new(6,7)
      castle_long = Position.new(2,7)
    end
      legal_moves.push(castle_short) if board.can_castle?(castle_short, @color)
      legal_moves.push(castle_short) if board.can_castle?(castle_long, @color)
  end

  def can_castle?

  end


  
end