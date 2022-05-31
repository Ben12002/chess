module Display
  # Displays board in different perspectives depending on current player.
  def display(current_player)
  end

  def simple_display_with_index
    i = 0
    j = 7
    outstr = "\n"

    while j >= 0
      while i < 8
        outstr += colorize(get_square(i,j), i, j)
        i += 1
      end
      i = 0
      outstr += " #{j} \n"
      j -= 1
    end
    outstr += " 0  1  2  3  4  5  6  7"
    puts outstr
  end
end