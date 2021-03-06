require_relative "colorizer"

class Piece

  include Colorizer

  attr_reader :color, :position

  def initialize(position, color)
    @position = position
    @color = color
  end

  # def initialize(file, rank, color)
  #   @position = Position.new(file, rank)
  #   @color = color
  # end

  def can_be_en_passant?(ply)
    false
  end

  def file
    @position.file
  end

  def rank
    @position.rank
  end

  def move(to, ply=nil)
    @position = to
  end

  def unicode
  end

  def to_s
    unicode
  end

  # Will this alter the state of pieces other than the rook?
  # def in_check_if_move?(board, tile, ply)
  #   board_copy = board.clone
  #   original_position = @position
  #   board_copy.move(@position, tile, ply)
  #   @position = original_position
  #   board_copy.player_in_check?(@color)
  # end

  def in_check_if_move?(board, tile, ply)
    board_copy = Marshal.load(Marshal.dump(board))
    original_position = @position
    board_copy.move(@position, tile, ply)
    @position = original_position
    board_copy.player_in_check?(@color)
  end

  def under_attack?(board)
    board.threatened_tile?(@color, @position)
  end
  
end

