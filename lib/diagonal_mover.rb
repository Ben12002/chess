module DiagonalMover

  def diagonally_obstructed_tile?(board, tile)
    up_right_diagonally_obstructed_tile?(board, tile) || 
    up_left_diagonally_obstructed_tile?(board, tile) ||
    down_left_diagonally_obstructed_tile?(board, tile) ||
    down_right_diagonally_obstructed_tile?(board, tile)
  end

  def up_right_diagonally_obstructed_tile?(board, tile)
    this_x = @position[0]
    this_y = @position[1]
    tile_x = tile[0]
    tile_y = tile[1]
    pieces_in_range = get_pieces_in_range(board).filter { |piece| (piece[0] > this_x) && (piece[1] > this_y) }

    return false if !get_tiles_attacked.include?(tile)
    return false if pieces_in_range.include?(tile)
    return false if !((tile_x > this_x) && (tile_y > this_y))

    i = 0
    while i < pieces_in_range.length
      piece_x = pieces_in_range[i][0]
      piece_y = pieces_in_range[i][1]
      return true if piece_x < tile_x
      i += 1
    end
    false
  end

  def up_left_diagonally_obstructed_tile?(board, tile)
    this_x = @position[0]
    this_y = @position[1]
    tile_x = tile[0]
    tile_y = tile[1]
    pieces_in_range = get_pieces_in_range(board).filter { |piece| (piece[0] < this_x) && (piece[1] > this_y) }

    return false if !get_tiles_attacked.include?(tile)
    return false if pieces_in_range.include?(tile)
    return false if !((tile_x < this_x) && (tile_y > this_y))

    i = 0
    while i < pieces_in_range.length
      piece_x = pieces_in_range[i][0]
      piece_y = pieces_in_range[i][1]
      return true if piece_x > tile_x
      i += 1
    end
    false
  end

  def down_left_diagonally_obstructed_tile?(board, tile)
    this_x = @position[0]
    this_y = @position[1]
    tile_x = tile[0]
    tile_y = tile[1]
    pieces_in_range = get_pieces_in_range(board).filter { |piece| (piece[0] < this_x) && (piece[1] < this_y) }

    return false if !get_tiles_attacked.include?(tile)
    return false if pieces_in_range.include?(tile)
    return false if !((tile_x < this_x) && (tile_y < this_y))

    i = 0
    while i < pieces_in_range.length
      piece_x = pieces_in_range[i][0]
      piece_y = pieces_in_range[i][1]
      return true if piece_x > tile_x
      i += 1
    end
    false
  end

  def down_right_diagonally_obstructed_tile?(board, tile)
    this_x = @position[0]
    this_y = @position[1]
    tile_x = tile[0]
    tile_y = tile[1]
    pieces_in_range = get_pieces_in_range(board).filter { |piece| (piece[0] > this_x) && (piece[1] < this_y) }

    return false if !get_tiles_attacked.include?(tile)
    return false if pieces_in_range.include?(tile)
    return false if !((tile_x > this_x) && (tile_y < this_y))

    i = 0
    while i < pieces_in_range.length
      piece_x = pieces_in_range[i][0]
      piece_y = pieces_in_range[i][1]
      return true if piece_x < tile_x
      i += 1
    end
    false
  end

end