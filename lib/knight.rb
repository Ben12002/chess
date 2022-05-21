class Knight < Piece

  def get_legal_moves
  end

  def get_full_move_range
    x = @position.file
    y = @position.range
    full_move_range = []

    full_move_range.push(Position.new(x + 1, y + 2)) if (x + 1) < 8 && (y + 2) < 8
    full_move_range.push(Position.new(x + 1, y + 2)) if (x + 2) < 8 && (y + 1) < 8
    full_move_range.push(Position.new(x - 1, y + 2)) if (x - 1) >= 0 && (y + 2) < 8
    full_move_range.push(Position.new(x + 1, y + 2)) if (x - 2) < 8 && (y + 1) < 8
    full_move_range.push(Position.new(x - 1, y - 2)) if (x - 1) >= 0 && (y - 2) >= 0 
    full_move_range.push(Position.new(x - 2, y - 1)) if (x - 2) >= 0 && (y - 1) >= 0
    full_move_range.push(Position.new(x + 1, y - 2)) if (x + 1) < 8 && (y - 2) >= 0 
    full_move_range.push(Position.new(x + 2, y - 1)) if (x + 2) < 8 && (y - 1) >= 0
  end

  def get_moveable_tiles
    get_full_move_range
  end

  def get_legal_moves(board)
    get_full_move_range.filter do |tile|
      board_copy = board.clone
      board_copy.move(@position, tile, ply)
      return false if board_copy.player_in_check?(@color)
      !board.same_color?(tile)
    end
  end

  def get_attacked_tiles
    get_full_move_range
  end

end