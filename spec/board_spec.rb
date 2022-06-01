require_relative '../lib/board'


describe Board do

  before do
    white_a_pawn = instance_double(Pawn, color: "white", position: Position.new(0,1))
    white_b_pawn = instance_double(Pawn, color: "white", position: Position.new(1,1))
    white_c_pawn = instance_double(Pawn, color: "white", position: Position.new(2,1))
    white_d_pawn = instance_double(Pawn, color: "white", position: Position.new(3,1))
    allow(Pawn).to receive(new).and_return()
  end
  
  
  describe '#update_square' do
  end

  describe '#promotion?' do
  end

  describe '#promote' do
  end

  describe '#capture_piece' do
  end

  describe '#castle?' do
  end

  describe '#rook_moved_already?' do
  end

  describe '#capture_piece' do
  end

  describe '#all_attacked_tiles' do
  end

  describe '#threatened_tile?' do
  end

  describe '#player_in_check?' do
  end

  describe '#king_and_knight_vs_king?' do
  end

  describe '#king_and_bishop_vs_king?' do
  end

  describe '#same_color_bishop_draw?' do
  end
  
  describe '#bishop_vs_bishop?' do
  end
end
