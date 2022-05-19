require_relative '../lib/piece'
require_relative '../lib/straight_mover'

class Rook < Piece
  
  include StraightMover

  attr_accessor :position
  attr_reader :color

  def initialize(position, color)
    super(position, color)
    @moved_already = false
  end
  

  def get_tiles_attacked
    tiles_attacked = []
    x = @position[0]
    y = @position[1]

    #left
    offset = 1
    while x - offset >= 0
      tiles_attacked.push([x - offset, y])
      offset += 1
    end

    #right
    offset = 1
    while x + offset <= 7 
      tiles_attacked.push([x + offset, y])
      offset += 1
    end

    #down
    offset = 1
    while y - offset >= 0
      tiles_attacked.push([x, y - offset])
      offset += 1
    end

    #up
    offset = 1
    while y + offset <= 7
      tiles_attacked.push([x, y + offset])
      offset += 1
    end

    tiles_attacked
  end

  def get_legal_moves(board, ply)
    get_tiles_attacked.filter do |tile|
      !board.same_color?(@color, tile[0], tile[1]) &&
      !vertically_obstructed_tile?(board, tile) &&
      !horizontally_obstructed_tile?(board, tile)
      # !in_check_if_move?(board, tile, ply)        # test this when king implementation is done


      # check if this move would end up putting the friendly king in check. If it does, not legal.
      # board_copy = board.clone
      # board_copy.move(@position, tile, ply) # will this modify this rook's @position?
      # return !board_copy.player_in_check?(@color)
    end
  end

  def move(to, ply)
    super(to)
    @moved_already = true if !@moved_already
  end

end


