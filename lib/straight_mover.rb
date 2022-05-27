module StraightMover

  def get_full_move_range_straight
    tiles_attacked = []
    x = @position.file
    y = @position.rank

    #left
    offset = 1
    while x - offset >= 0
      tiles_attacked.push(Position.new(x - offset, y))
      offset += 1
    end

    #right
    offset = 1
    while x + offset <= 7 
      tiles_attacked.push(Position.new(x + offset, y))
      offset += 1
    end

    #down
    offset = 1
    while y - offset >= 0
      tiles_attacked.push(Position.new(x, y - offset))
      offset += 1
    end

    #up
    offset = 1
    while y + offset <= 7
      tiles_attacked.push(Position.new(x, y + offset))
      offset += 1
    end

    tiles_attacked
  end

  def get_full_move_range
    tiles_attacked = []
    x = @position.file
    y = @position.rank

    #left
    offset = 1
    while x - offset >= 0
      tiles_attacked.push(Position.new(x - offset, y))
      offset += 1
    end

    #right
    offset = 1
    while x + offset <= 7 
      tiles_attacked.push(Position.new(x + offset, y))
      offset += 1
    end

    #down
    offset = 1
    while y - offset >= 0
      tiles_attacked.push(Position.new(x, y - offset))
      offset += 1
    end

    #up
    offset = 1
    while y + offset <= 7
      tiles_attacked.push(Position.new(x, y + offset))
      offset += 1
    end

    tiles_attacked
  end

  # Still includes pieces that blocked by others. returns all pieces in get_full_move_range.
  def get_pieces_in_range(board)
    get_full_move_range.filter {|tile| !board.square_empty?(tile.file, tile.rank)} 
  end

  def vertically_obstructed_tile?(board, tile)
    vertically_up_obstructed_tile?(board, tile) || vertically_down_obstructed_tile?(board, tile)
  end

  def horizontally_obstructed_tile?(board, tile)
    horizontally_left_obstructed_tile?(board, tile) || horizontally_right_obstructed_tile?(board, tile)
  end

  def vertically_up_obstructed_tile?(board, tile)
    this_x = @position.file
    this_y = @position.rank
    tile_x = tile.file
    tile_y = tile.rank
    pieces_in_range = get_pieces_in_range(board)
    pieces_in_range_y = pieces_in_range.filter { |piece| (piece.file == this_x) && (piece.rank > this_y) }
    piece_in_range_above = pieces_in_range_y.sort_by { |tile| tile.rank }.first
    flag = false

    return false if tile == piece_in_range_above
    return false if this_x != tile_x
    return false if !get_full_move_range.include?(tile)

    i = 0
    while i < pieces_in_range_y.length
      piece_y = pieces_in_range_y[i].rank
      return true if tile_y > piece_y
      i += 1
    end 
    false
  end

  def vertically_down_obstructed_tile?(board, tile)
    this_x = @position.file
    this_y = @position.rank
    tile_x = tile.file
    tile_y = tile.rank
    pieces_in_range = get_pieces_in_range(board)
    pieces_in_range_y = pieces_in_range.filter { |piece| (piece.file == this_x) && (piece.rank < this_y)}
    piece_in_range_below = pieces_in_range_y.sort_by { |tile| tile.rank }.last
    flag = false

    return false if tile == piece_in_range_below
    return false if this_x != tile_x
    return false if !get_full_move_range.include?(tile)

    i = 0
    while i < pieces_in_range_y.length
      piece_y = pieces_in_range_y[i].rank
      return true if tile_y < piece_y
      i += 1
    end 
    false
  end

  def horizontally_left_obstructed_tile?(board, tile)
    this_x = @position.file
    this_y = @position.rank
    tile_x = tile.file
    tile_y = tile.rank
    pieces_in_range = get_pieces_in_range(board)
    pieces_in_range_x = pieces_in_range.filter { |piece| (piece.rank == this_y) && (piece.file < this_x) }
    piece_in_range_left = pieces_in_range_x.sort_by { |tile| tile.file }.last
    flag = false

    return false if tile == piece_in_range_left
    return false if this_y != tile_y
    return false if !get_full_move_range.include?(tile)

    i = 0
    while i < pieces_in_range_x.length
      piece_x = pieces_in_range_x[i].file
      return true if (tile_x < piece_x)
      i += 1
    end
    false
  end

  def horizontally_right_obstructed_tile?(board, tile)
    this_x = @position.file
    this_y = @position.rank
    tile_x = tile.file
    tile_y = tile.rank
    pieces_in_range = get_pieces_in_range(board)
    pieces_in_range_x = pieces_in_range.filter {|piece| (piece.rank == this_y) && (piece.file > this_x)}
    piece_in_range_right = pieces_in_range_x.sort_by { |tile| tile.file }.first
    flag = false

    return false if tile == piece_in_range_right
    return false if this_y != tile_y
    return false if !get_full_move_range.include?(tile)

    i = 0
    while i < pieces_in_range_x.length
      piece_x = pieces_in_range_x[i].file
      return true if (tile_x > piece_x)
      i += 1
    end
    false
  end

  # def horizontally_obstructed_tile?(board, tile)
  #   this_x = @position.file
  #   this_y = @position.rank
  #   tile_x = tile.file
  #   tile_y = tile.rank
  #   pieces_in_range = get_pieces_in_range(board)
  #   pieces_in_range_x = pieces_in_range.filter {|piece| piece.file == this_y}
  #   flag = false

  #   return false if this_y != tile_y
  #   return false if !get_full_move_range.include?(tile)

  #   i = 0
  #   while i < pieces_in_range_x.length
  #     piece_x = pieces_in_range_x[i].file
  #     piece_y = pieces_in_range_x[i].rank
      
  #     if tile_x > this_x
  #       flag = (tile_x > piece_x)
  #     else
  #       flag = (tile_x < piece_x)
  #     end
  #     return true if flag
  #     i += 1
  #   end
  #   false
  # end

  # def vertically_obstructed_tile?(board, tile)
  #   this_x = @position.file
  #   this_y = @position.rank
  #   tile_x = tile.file
  #   tile_y = tile.rank
  #   pieces_in_range = get_pieces_in_range(board)
  #   pieces_in_range_y = pieces_in_range.filter {|piece| piece.file == this_x}
  #   flag = false

  #   return false if this_x != tile_x
  #   return false if !get_full_move_range.include?(tile)

  #   i = 0
  #   while i < pieces_in_range_y.length
  #     piece_x = pieces_in_range_y[i].file
  #     piece_y = pieces_in_range_y[i].rank
  
  #     if piece_y > this_y
  #       flag = (tile_y > piece_y)
  #     else
  #       flag = (tile_y < piece_y)
  #     end
  #     return true if flag
  #     i += 1
  #   end 
  #   false
  # end

  

end