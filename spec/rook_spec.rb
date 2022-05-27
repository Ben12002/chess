require_relative '../lib/rook'
require_relative '../lib/piece'
require_relative '../lib/board'
require_relative '../lib/pawn'
require_relative '../lib/knight'
require_relative '../lib/bishop'
require_relative '../lib/king'
require_relative '../lib/queen'
require_relative '../lib/straight_mover'


describe Rook do

  subject(:rook) { described_class.new(Position.new(3,3), "white") }
  let(:board) { instance_double(Board) }

  before do
    allow(board).to receive(:square_empty?).with(0,3).and_return false
    allow(board).to receive(:square_empty?).with(1,3).and_return false
    allow(board).to receive(:square_empty?).with(2,3).and_return true
    allow(board).to receive(:square_empty?).with(4,3).and_return true
    allow(board).to receive(:square_empty?).with(5,3).and_return false
    allow(board).to receive(:square_empty?).with(6,3).and_return true
    allow(board).to receive(:square_empty?).with(7,3).and_return false
    allow(board).to receive(:square_empty?).with(3,0).and_return false
    allow(board).to receive(:square_empty?).with(3,1).and_return false
    allow(board).to receive(:square_empty?).with(3,2).and_return true
    allow(board).to receive(:square_empty?).with(3,4).and_return true
    allow(board).to receive(:square_empty?).with(3,5).and_return true
    allow(board).to receive(:square_empty?).with(3,6).and_return false
    allow(board).to receive(:square_empty?).with(3,7).and_return false

    allow(board).to receive(:same_color?).with("white", 0,3).and_return false
    allow(board).to receive(:same_color?).with("white", 1,3).and_return true
    allow(board).to receive(:same_color?).with("white", 2,3).and_return false
    allow(board).to receive(:same_color?).with("white", 4,3).and_return false
    allow(board).to receive(:same_color?).with("white", 5,3).and_return false
    allow(board).to receive(:same_color?).with("white", 6,3).and_return false
    allow(board).to receive(:same_color?).with("white", 7,3).and_return false
    allow(board).to receive(:same_color?).with("white", 3,0).and_return true
    allow(board).to receive(:same_color?).with("white", 3,1).and_return true
    allow(board).to receive(:same_color?).with("white", 3,2).and_return false
    allow(board).to receive(:same_color?).with("white", 3,4).and_return false
    allow(board).to receive(:same_color?).with("white", 3,5).and_return false
    allow(board).to receive(:same_color?).with("white", 3,6).and_return false
    allow(board).to receive(:same_color?).with("white", 3,7).and_return true

    allow(rook).to receive(:in_check_if_move?).with(board, Position.new(2,3), 12).and_return true
    allow(rook).to receive(:in_check_if_move?).with(board, Position.new(4,3), 12).and_return true
    allow(rook).to receive(:in_check_if_move?).with(board, Position.new(5,3), 12).and_return true
    allow(rook).to receive(:in_check_if_move?).with(board, Position.new(3,2), 12).and_return true
    allow(rook).to receive(:in_check_if_move?).with(board, Position.new(3,4), 12).and_return true
    allow(rook).to receive(:in_check_if_move?).with(board, Position.new(3,5), 12).and_return true
    allow(rook).to receive(:in_check_if_move?).with(board, Position.new(3,6), 12).and_return true
  end

  describe "#get_full_move_range" do

    context "when rook is at [3,3]" do
      it "returns the list of tiles" do
        result = rook.get_full_move_range
        expect(result).to contain_exactly(Position.new(0,3), Position.new(1,3), Position.new(2,3), Position.new(4,3), Position.new(5,3), 
                                          Position.new(6,3), Position.new(7,3), Position.new(3,0), Position.new(3,1), Position.new(3,2), 
                                          Position.new(3,4), Position.new(3,5), Position.new(3,6), Position.new(3,7))
      end
    end
  end

  describe "#get_pieces_in_range" do

    it "returns a list of coordinates" do
      result = rook.get_pieces_in_range(board)
      expect(result).to contain_exactly(Position.new(0,3), Position.new(1,3), Position.new(5,3), Position.new(7,3),
                                        Position.new(3,0), Position.new(3,1), Position.new(3,6), Position.new(3,7))
    end
  end

  describe "#vertically_obstructed_tile?" do

    context "when it is not obstructed vertically" do
      
      it "returns false" do
        expect(rook.vertically_obstructed_tile?(board, Position.new(2,3))).to be false
      end

      it "returns false" do
        expect(rook.vertically_obstructed_tile?(board, Position.new(3,6))).to be false
      end

      it "returns false" do
        expect(rook.vertically_obstructed_tile?(board, Position.new(3,2))).to be false
      end
    end

    context "when it is obstructed vertically" do

      it "returns true" do
        expect(rook.vertically_obstructed_tile?(board, Position.new(3,7))).to be true
      end

      it "returns true" do
        expect(rook.vertically_obstructed_tile?(board, Position.new(3,0))).to be true
      end
    end
    
  end

  describe "#horizontally_obstructed_tile?" do
    
    context "when it is not obstructed horizontally" do

      it "returns false" do
        expect(rook.horizontally_obstructed_tile?(board, Position.new(3,0))).to be false
      end

      it "returns false" do
        expect(rook.horizontally_obstructed_tile?(board, Position.new(1,3))).to be false
      end

      it "returns false" do
        expect(rook.horizontally_obstructed_tile?(board, Position.new(4,3))).to be false
      end

      it "returns false" do
        expect(rook.horizontally_obstructed_tile?(board, Position.new(5,3))).to be false
      end
    end

    context "when it is obstructed horizontally" do

      it "returns true" do
        expect(rook.horizontally_obstructed_tile?(board, Position.new(0,3))).to be true
      end

      it "returns true" do
        expect(rook.horizontally_obstructed_tile?(board, Position.new(6,3))).to be true
      end

      it "returns true" do
        expect(rook.horizontally_obstructed_tile?(board, Position.new(7,3))).to be true
      end
    end
  end

  describe "#get_attacked_tiles" do

    it "returns a list of coordinates" do
      result = rook.get_attacked_tiles(board)
      expect(result).to contain_exactly(Position.new(2,3), Position.new(3,2), Position.new(4,3), Position.new(5,3), 
                                        Position.new(3,4), Position.new(3,5), Position.new(3,6))
    end
  end

  

  describe "#get_legal_moves" do

    it "returns a list of coordinates" do
      result = rook.get_legal_moves(board, 12)
      expect(result).to eq([])
    end
  end
end