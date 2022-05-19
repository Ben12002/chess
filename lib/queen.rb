require_relative '../lib/piece'

class Queen < Piece

  attr_accessor :position
  attr_reader :color
  
  def get_tiles_attacked
    get_tiles_attacked_diagonal + get_tiles_attacked_straight
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

  def get_legal_moves(board, ply)
    get_tiles_attacked.filter do |tile|
      return false if board.same_color?(@color, tile[0], tile[1])
      return false if  vertically_obstructed_tile?(board, tile) || 
                       horizontally_obstructed_tile?(board, tile) || 
                       diagonally_obstructed_tile?(board, tile)
      board_copy = board.clone
      board_copy.move(@position, tile, ply)
      return false if board_copy.player_in_check?(@color)
      return true
    end
  end

  def diagonally_obstructed_tile?(tile)
    queen_x = @position[0]
    queen_y = @position[1]
    this_x = tile[0]
    this_y = tile[1]
    pieces_attacked = get_pieces_attacked(board)
    flag = false

    return false if !get_tiles_attacked.include?(tile)

    i = 0
    while i < pieces_attacked.length
      piece_x = pieces_attacked[i][0]
      piece_y = pieces_attacked[i][1]
      
      if queen_x > piece_x
        flag = this_x < piece_x
      else
        flag = this_x > piece_x
      end
      return flag if !flag
      i += 1
    end
    true
  end

end
