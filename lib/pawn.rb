require_relative '../lib/piece'

class Pawn < Piece

  attr_accessor :position
  attr_reader :color

  def initialize(position, color)
    @position = position
    @color = color
    @move_counter = 0
  end
  
  # en passant only possible for 1 turn after a pawn moves 2 square

  # have to take into account en passant
  def get_tiles_attacked(board)
    tiles_attacked = []
    x = @position[0]
    y = @position[1]

    if @color = "white"
      tiles_attacked.push([x + 1, y + 1])
      tiles_attacked.push([x - 1, y + 1])
    end

    if @color = "black"
      tiles_attacked.push([x + 1, y - 1])
      tiles_attacked.push([x - 1, y - 1])
    end

    tiles_attacked
  end

  def get_moveable_tiles
    get_tiles_attacked

  end

  
  def get_legal_moves(board, turn)
    
  end

  
end

