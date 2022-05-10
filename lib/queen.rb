require_relative '../lib/piece'

class Queen < Piece

  attr_accessor :position
  attr_reader :color
  
  def get_tiles_attacked
    get_tiles_attacked_diagonal + get_tiles_attacked_straight
  end

  def get_moveable_tiles
    get_tiles_attacked
  end

  def get_tiles_attacked_diagonal
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

  def get_tiles_attacked_straight
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

end
