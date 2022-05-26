require_relative "game"
require_relative "board"
require_relative "position"
require_relative "piece"
require_relative "player"


def play_game
  game = Game.new()
  game.play
  play_again
end

def play_again
  # After game ends, give option to play again or end program
  answer = ""
  while answer != "y" && answer != "n"
    puts "would you like to play again? (y/n)"
    answer = gets.chomp

    if answer == "n"
      puts "Shutting down......."
    elsif answer != "y"
      puts "invalid answer"
    else
      puts "Another game!"
      play_game
    end
  end
end


play_game