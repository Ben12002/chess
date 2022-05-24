require './AlgebraicNotationMove'
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
      current_player = @ply.odd? ? @white : @black

      current_move = ply(current_player)
      @board.display

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
      @board.move(player, player_move[0], player_move[1], @ply)
    end
  end



  def get_move_input(player)
    loop do
      from = gets.chomp.downcase
      return from if COMMANDS.include?(from)
      from_array = from.split(",")
      break if (valid_move_format(from) && @board.valid_from?(player, from_array[0],from_array[1])
      puts "Please enter a valid move"
    end

    loop do
      to = gets.chomp
      return to if COMMANDS.include?(from)
      break if (valid_move_format(to) && @board.legal_move?(from, to, @ply)
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

  def game_over?(current_player)
    checkmate = @board.checkmate?(current_player.color)
    stalemate = @board.stalemate?(current_player.color)
    insufficient_material = @board.insufficient_material?
    threefold_repetition = @board.threefold_repetition?
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