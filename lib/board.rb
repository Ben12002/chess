class Board

  def initialize
    @arr = [[" ", " ", " ", " ", " ", " ", " ", " "],
            [" ", " ", " ", " ", " ", " ", " ", " "],
            [" ", " ", " ", " ", " ", " ", " ", " "],
            [" ", " ", " ", " ", " ", " ", " ", " "],
            [" ", " ", " ", " ", " ", " ", " ", " "],
            [" ", " ", " ", " ", " ", " ", " ", " "],
            [" ", " ", " ", " ", " ", " ", " ", " "],
            [" ", " ", " ", " ", " ", " ", " ", " "]]
    create_pieces
  end

  def create_pieces
    @white_pieces = []
    @black_pieces = []
  end

  def display
  end

  def move(player, from, to)
  end

  def legal_move?(from, to)
    
  end

  def get_legal_moves(piece)
  end

  # return false if square referred to by from is either 
  # empty, or has an opponent piece on it.
  # return false if format is wrong.
  def valid_from?(player, x, y)
    !square_empty?(x,y) && players_piece?(player, x, y)
  end

  def players_piece?(player, x, y)
    @arr[x][y].color == player.color
  end

  def square_empty?(col,row)
    @arr[col][row] == " "
  end

end
