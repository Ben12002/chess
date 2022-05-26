class Position

  attr_reader :file, :rank

  def initialize(x,y)
    @file = x
    @rank = y
  end

  def ==(other)
    (self.class == other.class) && (@file == other.file) && (@rank == other.rank)
  end

  
end







