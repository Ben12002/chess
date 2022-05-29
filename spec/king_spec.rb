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

describe King do

  

  describe "#get_full_move_range" do
    context "when the king is at [3,3]" do
      subject(:king_three) { described_class.new(Position.new(3,3), "black") }
      it "returns a list of 8 moves" do
        result = king_three.get_full_move_range
        expect(result).to contain_exactly(Position.new(2,4), Position.new(2,3), Position.new(2,2),
                                          Position.new(3,4), Position.new(3,2), Position.new(4,4),
                                          Position.new(4,3), Position.new(4,2))
      end
    end

    context "when the king is at [0,0]" do
      subject(:king_zero) { described_class.new(Position.new(0,0), "black") }
      it "doesn't include moves that go out of bounds" do
        result = king_zero.get_full_move_range
        expect(result).to contain_exactly(Position.new(0,1), Position.new(1,1), Position.new(1,0))
      end
    end
  end

  describe "#can_castle_short?" do
    
  end

  describe "#can_castle_long?" do
  end

  describe "#get_legal_moves" do
  end
end