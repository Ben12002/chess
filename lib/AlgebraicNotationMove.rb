
# Provides methods used when using AN (Algebraic notation) mode.
module AlgebraicNotationMove

  def self.get_move_input
    loop do
      move = gets.chomp.downcase
      return move if valid_input?(player, player_move)
      puts "Please enter a valid move"
    end
  end

  def self.valid_format?(move)
    length = move.length
    return false if !length.between?(2,6)

    return move.match?(/[a-h][1-8]/) if length == 2
  end

  def self.piece_to_be_moved(move)
  end

  def self.starting_position(move)
  end

  def self.end_position(move)
  end

  def self.capture?(move)
  end

  def self.update_move_list(move)
  end

  def self.convert_to_array_notation(move)
  end

  def self.valid_pawn
  end
end