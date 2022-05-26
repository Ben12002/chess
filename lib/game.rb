
require 'yaml'

class Game

  COMMANDS = ["resign", "draw"]

  def initialize
    @board = Board.new
    @turn = 1
    @ply = 0
    @white_resign = false
    @black_resign = false
    @draw = false
    @move_list = []
    @algebraic_notation_mode = false # an_mode is a flag which indicates whether the user should input a move in algebraic notation or not.
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
      print "Please enter your name: "
      name = gets.chomp
      return name if name.length < 20
      print "Please enter less than 20 characters: "
    end
  end

  def introduction_message
    puts <<-HEREDOC
         ---------------------------------------------------------------------------------------------------------
         Welcome to chess. simply enter "draw" or "resign" to offer a draw or resign respectively. 
         Similarly, you can save and load a game at any time. Enter "help" to see instructions.
         ---------------------------------------------------------------------------------------------------------
         HEREDOC
  end

  def turns
    loop do
      current_player = @ply.odd? ? @black : @white
      @board.simple_display_with_index

      current_move = ply(current_player)
      

      return if game_over?(current_player)

      @ply += 1
      @turn += 1 if current_player = @black
    end
  end

  # A ply is half a turn. In one turn, there are 2 plies: white's move and black's move.
  def ply(player)
    player_move = get_move_input(player)
    if (player_move.include?("draw"))
      make_draw_offer(player)
    elsif (player_move.include?("resign"))
      resign(player)
    else
      @board.move(player_move[0], player_move[1], @ply)
    end
  end



  def get_move_input(player)
    while true
      print "Please enter the coordinates of a piece you'd like to move: "
      from_input = gets.chomp.downcase
      return from_input if COMMANDS.include?(from_input)
      
      if valid_move_format?(from_input)
        from_array = from_input.split(",")
        from = Position.new(from_array[0].to_i, from_array[1].to_i)
        break if @board.valid_from?(player, from.file, from.rank, @ply)
      end
      puts "Please enter a valid move"
    end

    while true
      print "Please enter the coordinates where you'd like to move the piece: "
      to_input = gets.chomp
      return to_input if COMMANDS.include?(to_input)
      if (valid_move_format?(to_input)
        to_array = to_input.split(",")
        to = Position.new(to_array[0].to_i, to_array[1].to_i)
        break if @board.legal_move?(from, to, @ply))
      end
      puts "Please enter a valid move"
    end

    

    [from, to]
  end

  def valid_move_format?(input)
    input.length == 3 && input.match?(/[0-7],[0-7]/) 
  end

  def make_draw_offer(player)
    print "#{player} offered a draw. Accept? (y/n): "
    loop do
      answer = gets.chomp.downcase
      return @draw = true if answer == "y"
      return @draw = false if answer == "n"
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

  def game_over?(current_player)
    checkmate = @board.checkmate?(current_player.color, @ply)
    stalemate = @board.stalemate?(current_player.color, @ply)
    insufficient_material = @board.insufficient_material?
    threefold_repetition = @board.threefold_repetition?(@ply)
    @white_resign || @black_resign || @draw || checkmate || stalemate || threefold_repetition
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