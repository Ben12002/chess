require_relative '../lib/rook'
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


describe Bishop do

  subject(:bishop) { described_class.new(Position.new(3,3), "white") }
  let(:board) { instance_double(Board) }

  before do
    # allow(board).to receive(:).with().and_return()
    allow(board).to receive(:square_empty?).with(2,4).and_return true
    allow(board).to receive(:square_empty?).with(1,5).and_return false
    allow(board).to receive(:square_empty?).with(0,6).and_return false 
    allow(board).to receive(:square_empty?).with(4,4).and_return true 
    allow(board).to receive(:square_empty?).with(5,5).and_return false 
    allow(board).to receive(:square_empty?).with(6,6).and_return true 
    allow(board).to receive(:square_empty?).with(7,7).and_return false 
    allow(board).to receive(:square_empty?).with(2,2).and_return true 
    allow(board).to receive(:square_empty?).with(1,1).and_return false 
    allow(board).to receive(:square_empty?).with(0,0).and_return false
    allow(board).to receive(:square_empty?).with(4,2).and_return false  
    allow(board).to receive(:square_empty?).with(5,1).and_return false
    allow(board).to receive(:square_empty?).with(6,0).and_return true 
    
  end

  describe "#get_full_move_range" do

    context "when the bishop is at [3,3]" do
      it "returns a list of positions" do
        result = bishop.get_full_move_range
        expect(result).to contain_exactly(Position.new(2,4), Position.new(1,5), Position.new(0,6), 
                                          Position.new(4,4), Position.new(5,5), Position.new(6,6), Position.new(7,7),
                                          Position.new(2,2), Position.new(1,1), Position.new(0,0),
                                          Position.new(4,2), Position.new(5,1), Position.new(6,0))
      end
    end
  end
  
  describe "#get_pieces_in_range" do
    it "returns a list of positions" do
      result = bishop.get_pieces_in_range(board)
      expect(result).to contain_exactly(Position.new(0,6), Position.new(1,5), Position.new(5,5), Position.new(7,7),
                                      Position.new(1,1), Position.new(0,0), Position.new(4,2), Position.new(5,1))
    end
  end

  describe "#diagonally obstructed?" do

    context "when it is not diagonally obstructed" do

      it "returns false" do
        expect(bishop_attack_pieces.diagonally_obstructed_tile?(board, [3,5])).to be false
      end

      it "returns false" do
        expect(bishop_attack_pieces.diagonally_obstructed_tile?(board, [4,4])).to be false
      end

      it "returns false" do
        expect(bishop_attack_pieces.diagonally_obstructed_tile?(board, [1,5])).to be false
      end

      it "returns false" do
        expect(bishop_attack_pieces.diagonally_obstructed_tile?(board, [2,2])).to be false
      end
    end

    context "when it is diagonally obstructed" do

      it "returns true" do
        expect(bishop_attack_pieces.diagonally_obstructed_tile?(board, [7,7])).to be true
      end

      it "returns true" do
        expect(bishop_attack_pieces.diagonally_obstructed_tile?(board, [0,0])).to be true
      end

      it "returns true" do
        expect(bishop_attack_pieces.diagonally_obstructed_tile?(board, [5,1])).to be true
      end

      it "returns true" do
        expect(bishop_attack_pieces.diagonally_obstructed_tile?(board, [6,0])).to be true
      end

    end
  end
  
  # describe "#get_attacked_tiles" do

  #   context "when bishop is at [3,3]" do
      
  #     position = [3,3]
  #     color = "white"
  #     let(:bishop) {described_class.new(position, color)}
    
  #     it "returns the list of tiles" do
  #       result = bishop.get_tiles_attacked
  #       expect(result.sort).to eq([[2,4], [1,5], [0,6], [4,4], [5,5], [6,6], [7,7], [2,2], [1,1], [0,0], [4,2], [5,1], [6,0]].sort)
  #     end
  #   end

  # end

  # describe "#get_legal_moves" do

  #   context "when there are pieces obstructing" do

  #     it "doesn't include obstructed tiles" do
  #       result = bishop_attack_pieces.get_legal_moves(board, 1)
  #       expect(result.sort).to eq([[2,4], [1,5], [0,6], [4,2], [4,4], [5,5], [2,2], [1,1]].sort)
  #     end
  #   end

  # end

  

end