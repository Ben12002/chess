class Player
  def initialize(name, color)
    @color = color
    @name = name
  end

  def to_s
    "#{name} (#{color})"
  end

end