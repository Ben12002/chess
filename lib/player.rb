class Player

  attr_reader :name, :color
  
  def initialize(name, color)
    @color = color
    @name = name
  end

  def to_s
    "#{name} (#{color})"
  end

end