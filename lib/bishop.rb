require_relative '../lib/piece'
require_relative '../lib/diagonal_mover'

class Bishop < Piece

  include DiagonalMover

  def unicode
    "\u265D"
  end

  def get_legal_moves(board, ply)
    get_full_move_range.filter do |tile|
      !board.same_color?(@color, tile.file, tile.rank) &&
      !diagonally_obstructed_tile?(board, tile) &&
      !in_check_if_move?(board, tile, ply)
    end
  end

  def get_attacked_tiles(board)
    get_full_move_range.filter do |tile|
      !diagonally_obstructed_tile?(board, tile)
    end
  end

    


end

