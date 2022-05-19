class Piece

  attr_reader :color, :position

  def initialize(position, color)
    @position = position
    @color = color
  end

  def move(to, ply=nil)
    @position = to
  end 

  # Still includes pieces that blocked by others. returns all pieces in get_tiles_attacked.
  # problematic method to have?
  def get_pieces_in_range(board)
    get_tiles_attacked.filter do |tile|
      x = tile[0]
      y = tile[1]
      !board.square_empty?(x, y)
    end
  end

  # Only includes pieces that are within the line of sight. A subset of get_pieces_in_range.
  def get_pieces_attacked(board)
    all_pieces_in_range = get_tiles_attacked.filter {|tile| !board.square_empty?(tile[0], tile[1])}
    all_pieces_in_range.sort!
  end

  # if it's OKAY to have get_pieces_in_range:
  # get_pieces attacked would function differently for pawns, knights, kings.
  def get_pieces_attacked(board)
    get_pieces_in_range(board).filter {|tile| !tile.obstructed?}
  end

  def get_moveable_tiles
    get_tiles_attacked
  end

  def in_check_if_move?(board, tile, ply)
    board_copy = board.clone
    original_position = @position
    board_copy.move(@position, tile, ply)
    @position = original_position
    board_copy.player_in_check?(@color)
  end

  
end

