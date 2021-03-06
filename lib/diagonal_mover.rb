module DiagonalMover

  def get_full_move_range_diagonal
    full_move_range = []
    x = @position.file
    y = @position.rank

    #down-left
    offset = 1
    while (x - offset >= 0) && (y - offset >= 0)
      full_move_range.push(Position.new(x - offset, y - offset))
      offset += 1
    end

    #up-left
    offset = 1
    while (x - offset >= 0) && (y + offset <= 7)
      full_move_range.push(Position.new(x - offset, y + offset))
      offset += 1
    end

    #down-right
    offset = 1
    while (x + offset <= 7) && (y - offset >= 0)
      full_move_range.push(Position.new(x + offset, y - offset))
      offset += 1
    end

    #up-right
    offset = 1
    while (x + offset <= 7) && (y + offset <= 7)
      full_move_range.push(Position.new(x + offset, y + offset))
      offset += 1
    end

    full_move_range
  end

  def get_full_move_range
    full_move_range = []
    x = @position.file
    y = @position.rank

    #down-left
    offset = 1
    while (x - offset >= 0) && (y - offset >= 0)
      full_move_range.push(Position.new(x - offset, y - offset))
      offset += 1
    end

    #up-left
    offset = 1
    while (x - offset >= 0) && (y + offset <= 7)
      full_move_range.push(Position.new(x - offset, y + offset))
      offset += 1
    end

    #down-right
    offset = 1
    while (x + offset <= 7) && (y - offset >= 0)
      full_move_range.push(Position.new(x + offset, y - offset))
      offset += 1
    end

    #up-right
    offset = 1
    while (x + offset <= 7) && (y + offset <= 7)
      full_move_range.push(Position.new(x + offset, y + offset))
      offset += 1
    end

    full_move_range
  end

  # Still includes pieces that blocked by others. returns all pieces in get_full_move_range.
  def get_pieces_in_range(board)
    get_full_move_range.filter {|tile| !board.square_empty?(tile.file, tile.rank)} 
  end

  def diagonally_obstructed_tile?(board, tile)
    up_right_diagonally_obstructed_tile?(board, tile) || 
    up_left_diagonally_obstructed_tile?(board, tile) ||
    down_left_diagonally_obstructed_tile?(board, tile) ||
    down_right_diagonally_obstructed_tile?(board, tile)
  end

  def up_right_diagonally_obstructed_tile?(board, tile)
    this_x = @position.file
    this_y = @position.rank
    tile_x = tile.file
    tile_y = tile.rank
    pieces_in_range = get_pieces_in_range(board).filter { |piece| (piece.file > this_x) && (piece.rank > this_y) }
    piece_in_range = pieces_in_range.sort_by { |tile| tile.file}.first

    return false if !get_full_move_range.include?(tile)
    return false if piece_in_range == tile
    return false if !((tile_x > this_x) && (tile_y > this_y))

    i = 0
    while i < pieces_in_range.length
      piece_x = pieces_in_range[i].file
      piece_y = pieces_in_range[i].rank
      return true if piece_x < tile_x
      i += 1
    end
    false
  end

  def up_left_diagonally_obstructed_tile?(board, tile)
    this_x = @position.file
    this_y = @position.rank
    tile_x = tile.file
    tile_y = tile.rank
    pieces_in_range = get_pieces_in_range(board).filter { |piece| (piece.file < this_x) && (piece.rank > this_y) }
    piece_in_range = pieces_in_range.sort_by { |tile| tile.file}.last
    
    return false if !get_full_move_range.include?(tile)
    return false if piece_in_range == tile
    return false if !((tile_x < this_x) && (tile_y > this_y))

    i = 0
    while i < pieces_in_range.length
      piece_x = pieces_in_range[i].file
      piece_y = pieces_in_range[i].rank
      return true if piece_x > tile_x
      i += 1
    end
    false
  end

  def down_left_diagonally_obstructed_tile?(board, tile)
    this_x = @position.file
    this_y = @position.rank
    tile_x = tile.file
    tile_y = tile.rank
    pieces_in_range = get_pieces_in_range(board).filter { |piece| (piece.file < this_x) && (piece.rank < this_y) }
    piece_in_range = pieces_in_range.sort_by { |tile| tile.file}.last

    return false if !get_full_move_range.include?(tile)
    return false if piece_in_range == tile
    return false if !((tile_x < this_x) && (tile_y < this_y))

    i = 0
    while i < pieces_in_range.length
      piece_x = pieces_in_range[i].file
      piece_y = pieces_in_range[i].rank
      return true if piece_x > tile_x
      i += 1
    end
    false
  end

  def down_right_diagonally_obstructed_tile?(board, tile)
    this_x = @position.file
    this_y = @position.rank
    tile_x = tile.file
    tile_y = tile.rank
    pieces_in_range = get_pieces_in_range(board).filter { |piece| (piece.file > this_x) && (piece.rank < this_y) }
    piece_in_range = pieces_in_range.sort_by { |tile| tile.file}.first

    return false if !get_full_move_range.include?(tile)
    return false if piece_in_range == tile
    return false if !((tile_x > this_x) && (tile_y < this_y))

    i = 0
    while i < pieces_in_range.length
      piece_x = pieces_in_range[i].file
      piece_y = pieces_in_range[i].rank
      return true if piece_x < tile_x
      i += 1
    end
    false
  end

end