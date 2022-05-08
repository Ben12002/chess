class Game

  def initialize
    @board = Board.new
    @turn = 0
    @ply = 1
    @white_resign = false
    @black_resign = false
    @draw = false
  end

  def play
    set_up_game
    turns
    game_results
  end

  def set_up_game
    introduction_message
    create_characters
  end

  def create_characters
    name = get_name_input
    @white = Player.new(name, "white")
    name = get_name_input
    @black = Player.new(name, "black")
  end

  def get_name_input
    loop do
      name = gets.chomp
      return name if name.length < 20
      print "Please enter less than 20 characters: "
    end
  end

  def introduction_message
    puts <<-HEREDOC
         ---------------------------------------------------------------------------------------------------------
         Welcome to chess. On every turn, please use the chess algebraic notation (e.g: bxd5) to make a move. 
         simply enter "draw" or "resign" to offer a draw or resign respectively. Similarly, you can save and 
         load a game at any time.
         ---------------------------------------------------------------------------------------------------------
         HEREDOC
  end

  def turns
    loop do
      current_player = @ply.odd? ? @white : @black

      current_move = ply(current_player)
      @board.display

      return if game_over?

      @ply += 1
      @turn += 1 if current_player = @black
    end
  end

  # A ply is half a turn. In one turn, there are 2 plies: white's move and black's move.
  def ply(player)
    player_move = get_move_input
    if (player_move.include?("draw"))
      make_draw_offer(player)
    elsif (player_move.include?("resign"))
      resign(player)
    else
      @board.move(player, player_move)
    end
  end

  def get_move_input
    loop do
      move = gets.chomp.downcase
      return move if valid_input?(player, player_move)
      puts "Please enter a valid move"
    end
  end

  
  def valid_input?(player, player_move)
    valid_format = valid_format?(player_move)
    legal_move = @board.legal_move?(player, player_move)
    valid_format && legal_move
  end

  def valid_format(move)
    length = move.length
    return false if !length.between?(2,6)

    return move.match?(/[a-h][1-8]/) if length == 2

  end
  

  def make_draw_offer(player)
    print "#{player} offered a draw. Accept? (y/n): "
    loop do
      answer = gets.chomp.downcase
      return @draw = true if answer = "y"
      return @draw = false if answer = "n"
      print "Please enter either 'y' or 'n': "
    end
  end

  def resign(player)
    if player == @white
      @white_resign = true
    else
      @black_resign = true
    end
  end

  def game_over?
    checkmate = @board.checkmate?
    stalemate = @board.stalemate?
    @white_resign || @black_resign || @draw || checkmate || stalemate
  end

  def game_results
    return puts "White resigned. Black wins!" if @white_resign
    return puts "Black resigned. White wins!" if @black_resign
    return puts "Draw!" if @draw
    return puts "White wins!" if @board.winner = "white"
    return puts "Black wins!" if @board.winner = "black"
    return puts "Stalemate..." if @board.stalemate?
  end
  

  
end