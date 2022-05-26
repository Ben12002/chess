require_relative '../lib/piece'
require_relative '../lib/straight_mover'


class Rook < Piece

  include StraightMover

  attr_reader :moved_already

  def unicode
    "\u265C"
  end

  def initialize(position, color)
    super(position, color)
    @moved_already = false
  end

  def get_legal_moves(board, ply)
    get_full_move_range.filter do |tile|
      !board.same_color?(@color, tile.file, tile.rank) &&
      !vertically_obstructed_tile?(board, tile) &&
      !horizontally_obstructed_tile?(board, tile)
      # && !in_check_if_move?(board, tile, ply)        # test this when king implementation is done


      # check if this move would end up putting the friendly king in check. If it does, not legal.
      # board_copy = board.clone
      # board_copy.move(@position, tile, ply) # will this modify this rook's @position?
      # return !board_copy.player_in_check?(@color)
    end
  end

  # Identical to get_legal_moves, except not caring about checks/pins.
  def get_attacked_tiles(board)
    get_full_move_range.filter do |tile|
      !board.same_color?(@color, tile.file, tile.rank) &&
      !vertically_obstructed_tile?(board, tile) &&
      !horizontally_obstructed_tile?(board, tile)
    end
  end

  def move(to, ply)
    super(to)
    @moved_already = true if !@moved_already
  end

end


