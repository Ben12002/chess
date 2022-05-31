require_relative '../lib/piece'
require_relative "colorizer"

class Pawn < Piece

  attr_accessor :position
  attr_reader :color, :moved_already

  def unicode
    "\u265F"
  end

  def initialize(position, color)
    @position = position
    @color = color
    moved_already = false
    @double_move_ply = -99
  end

  
  # en passant only possible for 1 turn after a pawn moves 2 square

  # have to take into account en passant
  def get_attacked_tiles(board)
    tiles_attacked = []
    x = @position.file
    y = @position.rank

    if @color == "white"
      tiles_attacked.push(Position.new(x + 1, y + 1)) if (x + 1 < 8) && (y + 1 < 8)
      tiles_attacked.push(Position.new(x - 1, y + 1)) if (x - 1 >= 0) && (y + 1 < 8)
    end

    if @color == "black"
      tiles_attacked.push(Position.new(x + 1, y - 1)) if (x + 1 < 8) && (y - 1 >= 0)
      tiles_attacked.push(Position.new(x - 1, y - 1)) if (x - 1 >= 0) && (y - 1 >= 0)
    end

    tiles_attacked
  end

  def get_vertical_moves
    vertical_moves = []
    x = @position.file
    y = @position.rank

    if @color == "white"
      vertical_moves.push(Position.new(x, y + 1)) if (y + 1 < 8)
      vertical_moves.push(Position.new(x, y + 2)) if (y + 2 < 8)
    else
      vertical_moves.push(Position.new(x, y - 1)) if (y - 1 >= 0)
      vertical_moves.push(Position.new(x, y - 2)) if (y - 2 >= 0)
    end
  end

  def get_full_move_range(board)
   get_vertical_moves + get_attacked_tiles(board, ply)
  end

  # def get_legal_moves(board, ply)
  #   valid_non_capture_moves = get_vertical_moves.filter do |tile| 
  #     board.square_empty?(tile.file, tile.rank) &&
  #     !(@moved_already && double_move?(tile)) &&
  #     !in_check_if_move?(board, tile, ply)
  #   end

  #   valid_capture_moves = get_attacked_tiles(board).filter do |tile| 
  #     !board.same_color?(@color, tile.file, tile.rank) && 
  #     (!board.square_empty?(tile.file, tile.rank) || board.can_en_passant?(@color, ply, tile)) &&
  #     !in_check_if_move?(board, tile, ply)
    
  #   end
  #   valid_non_capture_moves + valid_capture_moves
  # end

  # def get_legal_vertical_moves(board, ply)
  # end

  # def get_legal_capture_moves(board, ply)
  # end

  def get_legal_moves(board, ply)
    get_legal_vertical_moves(board, ply) + get_legal_capture_moves(board, ply)
  end

  def get_legal_vertical_moves(board, ply)
    get_vertical_moves.filter do |tile| 
      board.square_empty?(tile.file, tile.rank) &&
      !(@moved_already && double_move?(tile)) &&
      !in_check_if_move?(board, tile, ply)
    end
  end

  def get_legal_capture_moves(board, ply)
    get_attacked_tiles(board).filter do |tile| 
      !board.same_color?(@color, tile.file, tile.rank) && 
      (!board.square_empty?(tile.file, tile.rank) || board.can_en_passant?(@color, ply, tile)) &&
      !in_check_if_move?(board, tile, ply)
    end
  end

  def double_move?(tile)
    (tile.rank - @position.rank).abs == 2
  end

  # def can_en_passant?(board, ply, tile)
  #   if @color == "white"
  #     tile_beside = Position.new(tile.file, tile.rank - 1)
  #   else
  #     tile_beside = Position.new(tile.file, tile.rank + 1)
  #   end
  #   board.get_square(tile_beside.file, tile_beside.rank).can_be_en_passant?(ply)
  # end

  def can_be_en_passant?(ply)
    ply - @double_move_ply == 1
  end


  def move(to, ply=nil)
    update_en_passant_status(to, ply)
    @moved_already = true if !@moved_already
    @position = to
  end

  def update_en_passant_status(to, ply)
    @double_move_ply = ply if ((to.rank - @position.rank).abs == 2)
  end

  
end

