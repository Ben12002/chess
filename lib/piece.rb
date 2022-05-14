class Piece

  def initialize(position, color)
    @position = position
    @color = color
  end

  def get_tiles_attacked
  end

  # For all pieces but the pawn, attacked tiles == moveable tiles. 
  # Pawns however attack diagonally yet move vertically.
  def get_moveable_tiles
  end

  def move(new_position, ply)
  end

  def get_legal_moves(board, ply)
  end

  def to_s
  end

  def move(to, ply)
    @position = to
  end

end

