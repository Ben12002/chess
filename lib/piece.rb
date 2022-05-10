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

end

