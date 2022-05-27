module Database

  def to_yaml
    str = YAML.dump ({
      :word => @word,
      :lives => @lives,
      :curr_guess => @curr_guess,
      :curr_state => @curr_state,
      :wrong_chars => @wrong_chars
    })
    file = File.open("test.yaml", "w")
    file.write(str)
    file.close
  end

  def self.from_yaml(fname)
    contents = File.open(fname, "r") {|file| file.read}
    data = YAML.load contents
    self.new(data[:word],data[:lives],data[:curr_guess],data[:curr_state], data[:wrong_chars])
  end

  def save?
    valid = false
    while !valid
      print "save game? (y/n):  "
      answer = gets.chomp.downcase
      valid = (answer == "y") || (answer == "n")
    end
    answer == "y" ? true : false
  end

  def load?
    valid = false
    while !valid
      print "Load previously saved game? (y/n):  "
      answer = gets.chomp.downcase
      valid = (answer == "y") || (answer == "n")
    end
    answer == "y" ? true : false
  end
end