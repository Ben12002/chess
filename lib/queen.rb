require_relative '../lib/piece'
require_relative 'straight_mover'
require_relative 'diagonal_mover'


class Queen < Piece

  include StraightMover, DiagonalMover

  def unicode
    "\u265B"
  end
  
  # Disregards other pieces on the board.
  def get_full_move_range
    # StraightMover.get_full_move_range + DiagonalMover.get_full_move_range
    get_full_move_range_diagonal + get_full_move_range_straight
  end

  # Affected by pins/checks and obstructions.
  def get_legal_moves(board, ply)
    get_full_move_range.filter do |tile|
      !board.same_color?(@color, tile.file, tile.rank) &&
      !vertically_obstructed_tile?(board, tile) &&
      !horizontally_obstructed_tile?(board, tile) &&
      !diagonally_obstructed_tile?(board, tile)
      # && !in_check_if_move?(board, tile, ply)        # test this when king implementation is done

      
    end
  end


  # Disregards pins/checks, but affected by obstructions.
  def get_attacked_tiles(board)
    get_full_move_range.filter do |tile|
      !board.same_color?(@color, tile.file, tile.rank) &&
      !vertically_obstructed_tile?(board, tile) &&
      !horizontally_obstructed_tile?(board, tile) &&
      !diagonally_obstructed_tile?(board, tile)
    end
  end

end
