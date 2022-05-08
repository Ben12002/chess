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
    @white_pieces = 
    @black_pieces = 
  end

  def display
  end

  def move(player, player_move)
  end

  def legal_move?(player_move)

  end

  def get_legal_moves(piece)
  end

end
