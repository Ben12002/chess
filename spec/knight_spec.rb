require_relative '../lib/knight'
require_relative '../lib/piece'
require_relative '../lib/board'
require_relative '../lib/pawn'
require_relative '../lib/knight'
require_relative '../lib/knight'
require_relative '../lib/king'
require_relative '../lib/queen'
require_relative '../lib/straight_mover'
require_relative '../lib/diagonal_mover'
require_relative '../lib/position'

describe Knight do

  describe "#get_full_move_range" do

    context "when knight is at (7,7)" do
      subject(:knight_seven) { described_class.new(Position.new(7,7), "black")}
      it "returns a list of <8 moves" do
        result = knight_seven.get_full_move_range
        expect(result).to contain_exactly(Position.new(5,6), Position.new(6,5))
      end
    end

    context "when knight is at (3,3)" do
      subject(:knight_three) { described_class.new(Position.new(3,3), "black")}
      it "returns a list of 8 moves" do
        result = knight_three.get_full_move_range
        expect(result).to contain_exactly(Position.new(1,4), Position.new(2,5), Position.new(4,5), Position.new(5,4),
                                          Position.new(1,2), Position.new(2,1), Position.new(4,1), Position.new(5,2))
      end
    end
  end

  describe "#get_legal_moves" do
    subject(:knight) { described_class.new(Position.new(3,3), "black")}
    let(:board) { instance_double(Board) }
    before do
      allow(knight).to receive(:in_check_if_move?).with(board, Position.new(1,4), 12).and_return true
      allow(knight).to receive(:in_check_if_move?).with(board, Position.new(2,5), 12).and_return true
      allow(knight).to receive(:in_check_if_move?).with(board, Position.new(4,5), 12).and_return true
      allow(knight).to receive(:in_check_if_move?).with(board, Position.new(5,4), 12).and_return true
      allow(knight).to receive(:in_check_if_move?).with(board, Position.new(1,2), 12).and_return false
      allow(knight).to receive(:in_check_if_move?).with(board, Position.new(2,1), 12).and_return true
      allow(knight).to receive(:in_check_if_move?).with(board, Position.new(4,1), 12).and_return false
      allow(knight).to receive(:in_check_if_move?).with(board, Position.new(5,2), 12).and_return true

      allow(board).to receive(:same_color?).with("black", 1, 4).and_return true
      allow(board).to receive(:same_color?).with("black", 2, 5).and_return true
      allow(board).to receive(:same_color?).with("black", 4, 5).and_return true
      allow(board).to receive(:same_color?).with("black", 5, 4).and_return false
      allow(board).to receive(:same_color?).with("black", 1, 2).and_return true
      allow(board).to receive(:same_color?).with("black", 2, 1).and_return true
      allow(board).to receive(:same_color?).with("black", 4, 1).and_return false
      allow(board).to receive(:same_color?).with("black", 5, 2).and_return true
    end
    it "doesn't include any moves that puts the same color king in check, nor moves that collide with friendly pieces" do
      result = knight.get_legal_moves(board, 12)
      expect(result).to eq([Position.new(4,1)])
    end
  end

end