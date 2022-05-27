class Knight < Piece

  def unicode
    "\u265E"
  end

  def get_full_move_range
    x = @position.file
    y = @position.rank
    full_move_range = []

    full_move_range.push(Position.new(x + 1, y + 2)) if (x + 1) < 8 && (y + 2) < 8
    full_move_range.push(Position.new(x + 1, y + 2)) if (x + 2) < 8 && (y + 1) < 8
    full_move_range.push(Position.new(x - 1, y + 2)) if (x - 1) >= 0 && (y + 2) < 8
    full_move_range.push(Position.new(x + 1, y + 2)) if (x - 2) < 8 && (y + 1) < 8
    full_move_range.push(Position.new(x - 1, y - 2)) if (x - 1) >= 0 && (y - 2) >= 0 
    full_move_range.push(Position.new(x - 2, y - 1)) if (x - 2) >= 0 && (y - 1) >= 0
    full_move_range.push(Position.new(x + 1, y - 2)) if (x + 1) < 8 && (y - 2) >= 0 
    full_move_range.push(Position.new(x + 2, y - 1)) if (x + 2) < 8 && (y - 1) >= 0

    full_move_range
  end

  def get_legal_moves(board, ply)
    get_full_move_range.filter do |tile|
      !in_check_if_move?(board, tile, ply)        # test this when king implementation is done
    end
    # get_full_move_range
  end

  def get_attacked_tiles(board)
    get_full_move_range
  end

end