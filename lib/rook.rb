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
      !horizontally_obstructed_tile?(board, tile) &&
      !in_check_if_move?(board, tile, ply)
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


