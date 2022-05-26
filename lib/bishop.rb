require_relative '../lib/piece'
require_relative '../lib/diagonal_mover'

class Bishop < Piece

  include DiagonalMover

  def unicode
    "\u265D"
  end
  
  # def get_legal_moves(board, ply)
  #   get_attacked_tiles(board, ply).filter do |tile|
  #     !board.same_color?(@color, tile.file, tile.rank) &&
  #     !diagonally_obstructed_tile?(board, tile)
  #     # board_copy = board.clone
  #     # board_copy.move(@position, tile, ply)
  #     # return false if board_copy.player_in_check?(@color)
  #   end
  # end

  def get_legal_moves(board, ply)
    get_full_move_range.filter do |tile|
      !board.same_color?(@color, tile.file, tile.rank) &&
      !diagonally_obstructed_tile?(board, tile)
      # && !in_check_if_move?(board, tile, ply)        # test this when king implementation is done
    end
  end

  def get_attacked_tiles(board)
    get_full_move_range.filter do |tile|
      !board.same_color?(@color, tile.file, tile.rank) &&
      !diagonally_obstructed_tile?(board, tile)
      # && !in_check_if_move?(board, tile, ply)        # test this when king implementation is done
    end
  end

    


end

