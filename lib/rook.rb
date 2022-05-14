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

  def get_legal_moves(board, ply)
    this_x = @position[0]
    this_y = @position[1]
    get_tiles_attacked.filter do |tile|
      !vertically_obstructed_tile?(tile)  && !horizontally_obstructed_tile?(tile)
      # If piece moves and king is in check afterward, then illegal move.
    end
  end

  def get_pieces_attacked
    get_tiles_attacked.filter do |tile|
      x = tile[0]
      y = tile[1]
      !square_empty?(x, y)
    end
  end

  def vertically_obstructed_tile?(tile)
    rook_x = @position[0]
    rook_y = @position[1]

    this_y = tile[1]

    flag = false

    while i = 0
      piece_x = get_pieces_attacked[0][0]
      piece_y = get_pieces_attacked[0][1]
      if piece_x == rook_x
        if piece_y > rook_y
          flag = (this_y > piece_y)
        else
          flag = (this_y < piece_y)
        end
      end
    end
    flag
  end

  def horizontally_obstructed_tile?(tile)
    rook_x = @position[0]
    rook_y = @position[1]

    this_x = tile[0]

    flag = false

    while i = 0
      piece_x = get_pieces_attacked[0][0]
      piece_y = get_pieces_attacked[0][1]
      if piece_y == rook_y
        if piece_x > rook_x
          flag = (this_x > piece_x)
        else
          flag = (this_x < piece_x)
        end
      end
    end
    flag
  end

end


