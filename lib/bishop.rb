require_relative '../lib/piece'
require_relative '../lib/diagonal_mover'

class Bishop < Piece

  include DiagonalMover

  attr_accessor :position
  attr_reader :color
  

  def get_tiles_attacked
    tiles_attacked = []
    x = @position[0]
    y = @position[1]

    #down-left
    offset = 1
    while (x - offset >= 0) && (y - offset >= 0)
      tiles_attacked.push([x - offset, y - offset])
      offset += 1
    end

    #up-left
    offset = 1
    while (x - offset >= 0) && (y + offset <= 7)
      tiles_attacked.push([x - offset, y + offset])
      offset += 1
    end

    #down-right
    offset = 1
    while (x + offset <= 7) && (y - offset >= 0)
      tiles_attacked.push([x + offset, y - offset])
      offset += 1
    end

    #up-right
    offset = 1
    while (x + offset <= 7) && (y + offset <= 7)
      tiles_attacked.push([x + offset, y + offset])
      offset += 1
    end

    tiles_attacked
  end

  def get_legal_moves(board, ply)
    get_tiles_attacked.filter do |tile|
      !board.same_color?(@color, tile[0], tile[1]) &&
      !diagonally_obstructed_tile?(board, tile)
      # board_copy = board.clone
      # board_copy.move(@position, tile, ply)
      # return false if board_copy.player_in_check?(@color)
    end
  end


end

