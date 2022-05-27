require_relative '../lib/knight'
require_relative '../lib/piece'
require_relative '../lib/board'
require_relative '../lib/pawn'
require_relative '../lib/knight'
require_relative '../lib/bishop'
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
        expect(result).to contain_exactly()
      end
    end

    context "when knight is at (3,3)" do
      subject(:knight_three) { described_class.new(Position.new(7,7), "black")}
      it "returns a list of <8 moves" do
        result = knight_three.get_full_move_range
        expect(result).to contain_exactly()
      end
    end
  end

  describe "#get_legal_moves" do
    it "doesn't include any moves that puts the same color king in check" do
      
    end
  end

end