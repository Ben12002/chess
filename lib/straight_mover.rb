module StraightMover

  def vertically_obstructed_tile?(board, tile)
    this_x = @position[0]
    this_y = @position[1]
    tile_x = tile[0]
    tile_y = tile[1]
    pieces_attacked = get_pieces_in_range(board)
    pieces_attacked_y = pieces_attacked.filter {|piece| piece[0] == this_x}
    flag = false

    return false if this_x != tile_x
    return false if !get_tiles_attacked.include?(tile)

    i = 0
    while i < pieces_attacked_y.length
      piece_x = pieces_attacked_y[i][0]
      piece_y = pieces_attacked_y[i][1]
  
      if piece_y > this_y
        flag = (tile_y > piece_y)
      else
        flag = (tile_y < piece_y)
      end
      return true if flag
      i += 1
    end 
    false
  end

  def horizontally_obstructed_tile?(board, tile)
    this_x = @position[0]
    this_y = @position[1]
    tile_x = tile[0]
    tile_y = tile[1]
    pieces_attacked = get_pieces_in_range(board)
    pieces_attacked_x = pieces_attacked.filter {|piece| piece[1] == this_y}
    flag = false

    return false if this_y != tile_y
    return false if !get_tiles_attacked.include?(tile)

    i = 0
    while i < pieces_attacked_x.length
      piece_x = pieces_attacked_x[i][0]
      piece_y = pieces_attacked_x[i][1]
      
      if piece_x > this_x
        flag = (tile_x > piece_x)
      else
        flag = (tile_x < piece_x)
      end
      return true if flag
      i += 1
    end
    false
  end

end