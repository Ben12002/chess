require_relative '../lib/piece'

class Rook < Piece

  attr_accessor :position
  attr_reader :color
  

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

  def get_moveable_tiles
    get_tiles_attacked
  end

  
end


