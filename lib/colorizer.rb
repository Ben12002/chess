module Colorizer

  DARK_TILE_COLOR = 100
  LIGHT_TILE_COLOR = 47

  # Cyan Orange
  # DARK_TILE_COLOR = 44
  # LIGHT_TILE_COLOR = 43

  # Yellow orange
  # DARK_TILE_COLOR = 103
  # LIGHT_TILE_COLOR = 43

  WHITE_PIECE_COLOR = 1
  BLACK_PIECE_COLOR = 30

  def colorize(element, file, rank)
    color = tile_color_selector(file, rank)
    element = color_piece(element.color, element.unicode) if (element != " ")
    "\e[#{color}m #{element} \e[0m"
  end

  def tile_color_selector(file, rank)
    dark_tile?(file, rank) ? DARK_TILE_COLOR : LIGHT_TILE_COLOR
  end

  def color_piece(color, unicode)
    piece_color = color == "white"? WHITE_PIECE_COLOR : BLACK_PIECE_COLOR
    "\e[#{piece_color}m#{unicode}\e[1m"
  end

end