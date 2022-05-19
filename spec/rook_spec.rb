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

  let(:rook_attack_pieces) {described_class.new([3,4], "white")}
  let(:board) {Board.new}

  before do
    allow(board).to receive(:set_up_board)
    array = [[" ", " ", " ", " ", " ", " ", " ", " "],
             [" ", " ", " ", " ", " ", " ", " ", " "],
             [" ", " ", " ", " ", " ", " ", " ", " "],
             [" ", " ", " ", " ", " ", " ", " ", " "],
             [" ", " ", " ", " ", " ", " ", " ", " "],
             [" ", " ", " ", " ", " ", " ", " ", " "],
             [" ", " ", " ", " ", " ", " ", " ", " "],
             [" ", " ", " ", " ", " ", " ", " ", " "]]
    array[2][4] = Pawn.new([2,4], "black")
    array[6][4] = Knight.new([6,4], "white")
    array[3][6] = Bishop.new([3,6], "white")
    array[3][0] = Knight.new([3,0], "black")
    array[6][0] = King.new([6,0], "white")
    array[7][7] = King.new([7,7], "black")
    array[3][4] = rook_attack_pieces
    board.instance_variable_set(:@arr, array)
  end
  
  

  describe "#get_tiles_attacked" do

    context "when rook is at [3,3]" do
      
      position = [3,3]
      color = "white"
      let(:rook) {described_class.new(position, color)}
    
      it "returns the list of tiles" do
        result = rook.get_tiles_attacked
        expect(result.sort).to eq([[0,3], [1,3], [2,3], [4,3], [5,3], [6,3], [7,3], [3,0], [3,1], [3,2], [3,4], [3,5], [3,6], [3,7]].sort)
      end
    end

    context "when rook is at [1,2]" do

      position = [1,2]
      color = "white"
      let(:rook) {described_class.new(position, color)}

      it "returns the list of tiles" do
        result = rook.get_tiles_attacked
        expect(result.sort).to eq([[1,0], [1,1], [1,3], [1,4], [1,5], [1,6], [1,7], [0,2], [2,2], [3,2], [4,2], [5,2], [6,2], [7,2]].sort)
      end
    end

    context "when rook is at [7,7]" do

      position = [7,7]
      color = "black"
      let(:rook) {described_class.new(position, color)}

      it "returns the list of tiles" do
        result = rook.get_tiles_attacked
        expect(result.sort).to eq([[0,7], [1,7], [2,7], [3,7], [4,7], [5,7], [6,7], [7,0], [7,1], [7,2], [7,3], [7,4], [7,5], [7,6]].sort)
      end
    end

    context "when rook is at [3,4]" do

      position = [3,4]
      color = "white"
      let(:rook) {described_class.new(position, color)}

      it "returns the list of tiles" do
        result = rook.get_tiles_attacked
        expect(result.sort).to eq([[0,4], [1,4], [2,4], [4,4], [5,4], [6,4], [7,4], [3,0], [3,1], [3,2], [3,3], [3,5], [3,6], [3,7]].sort)
      end
    end

  end

  describe "#get_legal_moves" do

    context "when there are pieces obstructing" do

      it "doesn't include obstructed tiles" do
        result = rook_attack_pieces.get_legal_moves(board, 1)
        expect(result.sort).to eq([[2,4], [3,5], [3,3], [3,2], [3,1], [3,0], [4,4], [5,4]].sort)
      end
    end

  end

  describe "#pieces_in_range" do

    it "returns a list of coordinates" do
      result = rook_attack_pieces.get_pieces_in_range(board)
      expect(result.sort).to eq([[2,4], [6,4], [3,6], [3,0]].sort)
    end
  end

  describe "#vertically_obstructed_tile?" do

    context "when it is not obstructed vertically" do
      
      it "returns false" do
        expect(rook_attack_pieces.vertically_obstructed_tile?(board, [3,5])).to be false
      end

      it "returns false" do
        expect(rook_attack_pieces.vertically_obstructed_tile?(board, [3,3])).to be false
      end

      it "returns false" do
        expect(rook_attack_pieces.vertically_obstructed_tile?(board, [3,2])).to be false
      end

      it "returns false" do
        expect(rook_attack_pieces.vertically_obstructed_tile?(board, [3,1])).to be false
      end

      it "returns false" do
        expect(rook_attack_pieces.vertically_obstructed_tile?(board, [3,0])).to be false
      end

      it "returns false" do
        expect(rook_attack_pieces.vertically_obstructed_tile?(board, [5,5])).to be false
      end

      it "returns false" do
        expect(rook_attack_pieces.vertically_obstructed_tile?(board, [1,4])).to be false
      end

      it "returns false" do
        expect(rook_attack_pieces.vertically_obstructed_tile?(board, [7,4])).to be false
      end
    end

    context "when it is obstructed vertically" do

      it "returns true" do
        expect(rook_attack_pieces.vertically_obstructed_tile?(board, [3,7])).to be true
      end
    end
    
  end

  describe "#horizontally_obstructed_tile?" do
    
    context "when it is not obstructed horizontally" do

      it "returns false" do
        expect(rook_attack_pieces.horizontally_obstructed_tile?(board, [3,7])).to be false
      end

      it "returns false" do
        expect(rook_attack_pieces.horizontally_obstructed_tile?(board, [3,5])).to be false
      end

      it "returns false" do
        expect(rook_attack_pieces.horizontally_obstructed_tile?(board, [3,2])).to be false
      end

      it "returns false" do
        expect(rook_attack_pieces.horizontally_obstructed_tile?(board, [2,4])).to be false
      end

      it "returns false" do
        expect(rook_attack_pieces.horizontally_obstructed_tile?(board, [4,4])).to be false
      end

      it "returns false" do
        expect(rook_attack_pieces.horizontally_obstructed_tile?(board, [5,4])).to be false
      end
    end

    context "when it is obstructed horizontally" do

      it "returns true" do
        expect(rook_attack_pieces.horizontally_obstructed_tile?(board, [7,4])).to be true
      end

      it "returns true" do
        expect(rook_attack_pieces.horizontally_obstructed_tile?(board, [0,4])).to be true
      end

      it "returns true" do
        expect(rook_attack_pieces.horizontally_obstructed_tile?(board, [1,4])).to be true
      end
    end
  end
end