
require 'yaml'

class Game

  COMMANDS = ["resign", "draw", "help", "save", "load"]

  def initialize
    @board = Board.new
    @turn = 1
    @ply = 0
    @white_resign = false
    @black_resign = false
    @draw = false
    @current_player = nil
  end

  def to_yaml
    str = YAML.dump ({
      :board => @board,
      :turn => @turn,
      :ply => @ply,
      :white_resign => @white_resign,
      :black_resign => @black_resign,
      :draw => @draw,
      :current_player => @current_player
    })
    file = File.open("test.yaml", "w")
    file.write(str)
    file.close
  end

  def from_yaml(fname)
    contents = File.open(fname, "r") {|file| file.read}
    data = YAML.load contents
    @board = data[:board]
    @turn = data[:turn]
    @ply = data[:ply]
    @white_resign = data[:white_resign]
    @black_resign = data[:black_resign]
    @draw = data[:draw]
    @current_player = data[:current_player]
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

  def help_message
    puts <<-HEREDOC

          --------------------------------------------HELP---------------------------------------------------
          First, enter the coordinates of the piece you would like to move in the format 'x,y'. 
          Then, enter the coordinates where you would like to move that piece. If you enter a coordinate
          which corresponds to an empty tile, an opponent's piece, or a piece with no legal moves, you will
          have to enter another coordinate.
          ---------------------------------------------------------------------------------------------------
         HEREDOC
  end

  def turns
    @board.simple_display_with_index
    loop do
      @current_player = @ply.odd? ? @black : @white
      return if game_over?(@current_player)
      current_move = ply(@current_player)
      @board.simple_display_with_index
      @ply += 1
      @turn += 1 if @current_player = @black
    end
  end

  # A ply is half a turn. In one turn, there are 2 plies: white's move and black's move.
  def ply(player)
    player_move = get_move_input(player)
    if player_move.include?("draw")
      ply(player) if !make_draw_offer(player)
    elsif player_move.include?("resign")
      resign(player)
    elsif player_move.include?("help")
      help_message
      ply(player)
    elsif player_move.include?("save")
      save_game
      ply(player)
    elsif player_move.include?("load")
      load_game
      ply(@current_player)
    elsif @board.promotion?(player_move[0], player_move[1])
      @board.promote(player_move[0], player_move[1], get_promotion_input)
    else
      @board.move(player_move[0], player_move[1], @ply)
    end
  end

  def load_game
    from_yaml("test.yaml")
    puts "Loaded save!"
    @board.simple_display_with_index
  end

  def save_game
    to_yaml
    puts "Game saved!"
  end

  def get_promotion_input
    valid_inputs = ["queen", "rook", "bishop", "knight"]
    loop do
      print "please enter the type of piece to promote to: "
      piece_type = gets.chomp.downcase
      return piece_type if valid_inputs.include?(piece_type)
      puts "please enter a valid input. "
    end
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
    threefold_repetition = @board.threefold_repetition?
    @white_resign || @black_resign || @draw || checkmate || stalemate || threefold_repetition || insufficient_material
  end

  def game_results
    return puts "White resigned. Black wins!" if @white_resign
    return puts "Black resigned. White wins!" if @black_resign
    return puts "Draw!" if @draw
    return puts "White wins!" if @board.checkmate?("black", @ply)
    return puts "Black wins!" if @board.checkmate?("white", @ply)
    return puts "Stalemate..." if @board.stalemate?("white", @ply) || @board.stalemate?("black", @ply)
    return puts "Draw! Threefold repetition!" if @board.threefold_repetition?
    return puts "Draw! Insufficient material!" if @board.insufficient_material?
  end

  # def get_move_input(player)
  #   while true
  #     print "Please enter the coordinates of a piece you'd like to move (#{player.name}'s turn): "
  #     from_input = gets.chomp.downcase
  #     return from_input if COMMANDS.include?(from_input)
      
  #     if valid_move_format?(from_input)
  #       from_array = from_input.split(",")
  #       from = Position.new(from_array[0].to_i, from_array[1].to_i)
  #       break if @board.valid_from?(player, from.file, from.rank, @ply)
  #     end
  #     puts "Please enter a valid move"
  #   end

  #   while true
  #     print "Please enter the coordinates where you'd like to move the piece: "
  #     to_input = gets.chomp
  #     return to_input if COMMANDS.include?(to_input)
  #     if (valid_move_format?(to_input)
  #       to_array = to_input.split(",")
  #       to = Position.new(to_array[0].to_i, to_array[1].to_i)
  #       break if @board.legal_move?(from, to, @ply))
  #     end
  #     puts "Please enter a valid move"
  #   end

  #   [from, to]
  # end

  def get_move_input(player)
    from = get_from_input(player)
    return from if COMMANDS.include?(from)
    to = get_to_input(player, from)
    return to if COMMANDS.include?(to)
    [from, to]
  end

  def get_from_input(player)
    while true
      print "Please enter the coordinates of a piece you'd like to move (#{player.name}'s turn): "
      from_input = gets.chomp.downcase
      return from_input if COMMANDS.include?(from_input)
      
      if valid_move_format?(from_input)
        from_array = from_input.split(",")
        from = Position.new(from_array[0].to_i, from_array[1].to_i)
        return from if @board.valid_from?(player, from.file, from.rank, @ply)
      end
      puts "Please enter a valid move"
    end
  end

  def get_to_input(player, from)
    while true
      print "Please enter the coordinates where you'd like to move the piece: "
      to_input = gets.chomp
      return to_input if COMMANDS.include?(to_input)
      if (valid_move_format?(to_input)
        to_array = to_input.split(",")
        to = Position.new(to_array[0].to_i, to_array[1].to_i)
        return to if @board.legal_move?(from, to, @ply))
      end
      puts "Please enter a valid move"
    end
  end



  
end