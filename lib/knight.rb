class Knight < Piece

  def get_legal_moves
  end

  def get_tiles_attacked
    x = @position[0]
    y = @position[1]
    tiles_attacked = []

    tiles_attacked.push([x + 1, y + 2]) if (x + 1) < 8 && (y + 2) < 8
    tiles_attacked.push([x + 1, y + 2]) if (x + 2) < 8 && (y + 1) < 8
    tiles_attacked.push([x - 1, y + 2]) if (x - 1) >= 0 && (y + 2) < 8
    tiles_attacked.push([x + 1, y + 2]) if (x - 2) < 8 && (y + 1) < 8
    tiles_attacked.push([x - 1, y - 2]) if (x - 1) >= 0 && (y - 2) >= 0 
    tiles_attacked.push([x - 2, y - 1]) if (x - 2) >= 0 && (y - 1) >= 0
    tiles_attacked.push([x + 1, y - 2]) if (x + 1) < 8 && (y - 2) >= 0 
    tiles_attacked.push([x + 2, y - 1]) if (x + 2) < 8 && (y - 1) >= 0
  end

  def get_moveable_tiles
    get_tiles_attacked
  end

  def get_legal_moves(board)
    get_tiles_attacked.filter do |tile|
      board_copy = board.clone
      board_copy.move(@position, tile, ply)
      return false if board_copy.player_in_check?(@color)
      !board.same_color?(tile)
    end
  end

end