require_relative '../lib/piece'

class Pawn < Piece

  attr_accessor :position
  attr_reader :color

  def initialize(position, color)
    @position = position
    @color = color
    moved_already = false
    @double_move_ply = -1
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
    get_moveable_tiles = get_tiles_attacked

    x = @position[0]
    y = @position[1]

    get_moveable_tiles.push([x, y + 1]) if @color == "white"
    get_moveable_tiles.push([x, y + 2]) if @color == "white"

    get_moveable_tiles.push([x, y - 1]) if @color == "black"
    get_moveable_tiles.push([x, y - 2]) if @color == "black"
  end


  def get_legal_moves(board, ply)
    
  end

  def can_be_en_passant?(ply)
    (ply - @double_move_ply == 1)
  end

  def move(new_position, ply)
    
    @moved_already = true if !moved_already
    
  end

  def update_position
    @position = new_position
  end

  def update_en_passant_status
    y = @position[1] 
    new_y = new_position[1] 
    @double_move_ply = turn if (new_y - y == 2)
  end

  
end

