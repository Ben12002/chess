require_relative '../lib/piece'

class Bishop < Piece

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

  def get_moveable_tiles
    get_tiles_attacked
  end

  
end

print Bishop.new([3,3],"white").get_tiles_attacked
