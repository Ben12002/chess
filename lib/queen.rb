require_relative '../lib/piece'

class Queen < Piece

  include StraightMover, DiagonalMover
  
  # Disregards other pieces on the board.
  def get_full_move_range
    StraightMover.get_full_move_range + DiagonalMover.get_full_move_range
  end

  # Affected by pins/checks and obstructions.
  def get_legal_moves(board, ply)
    get_full_move_range.filter do |tile|
      return false if board.same_color?(@color, tile.file, tile.rank)
      return false if  vertically_obstructed_tile?(board, tile) || 
                       horizontally_obstructed_tile?(board, tile) || 
                       diagonally_obstructed_tile?(board, tile)
      board_copy = board.clone
      board_copy.move(@position, tile, ply)
      return false if board_copy.player_in_check?(@color)
      return true
    end
  end


  # Disregards pins/checks, but affected by obstructions.
  def get_attacked_tiles(board, ply)
    get_full_move_range.filter do |tile|
      !board.same_color?(@color, tile.file, tile.rank) &&
      !vertically_obstructed_tile?(board, tile) &&
      !horizontally_obstructed_tile?(board, tile) &&
      !diagonally_obstructed_tile?(board, tile)
    end
  end

end
