module BoardDatabase

  FILE_FOR_CHECKS = "board.yaml"

  def to_yaml(fname)
    str = YAML.dump ({
      :arr => @arr,
      :white_pieces => @white_pieces,
      :black_pieces => @black_pieces,
    })
    file = File.open(fname, "w")
    file.write(str)
    file.close
  end

  def self.from_yaml(fname)
    contents = File.open(fname, "r") {|file| file.read}
    data = YAML.load contents
    self.new(data[:arr],data[:white_pieces],data[:black_pieces])
  end

  def deep_copy
    copy_board = Marshal.load(Marshal.dump(real_board))
  end

end