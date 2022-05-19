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
  
  let(:bishop_attack_pieces) {described_class.new([3,3], "white")}
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
    array[6][6] = Pawn.new([6,6], "white")
    array[4][2] = Knight.new([4,2], "black")
    array[1][1] = Rook.new([1,1], "black")
    array[0][6] = Queen.new([0,6], "black")
    # array[6][0] = King.new([6,0], "white")
    # array[7][7] = King.new([7,7], "black")
    array[3][3] = bishop_attack_pieces
    board.instance_variable_set(:@arr, array)
  end

  describe "#get_tiles_attacked" do

    context "when bishop is at [3,3]" do
      
      position = [3,3]
      color = "white"
      let(:bishop) {described_class.new(position, color)}
    
      it "returns the list of tiles" do
        result = bishop.get_tiles_attacked
        expect(result.sort).to eq([[2,4], [1,5], [0,6], [4,4], [5,5], [6,6], [7,7], [2,2], [1,1], [0,0], [4,2], [5,1], [6,0]].sort)
      end
    end

    # context "when bishop is at [1,2]" do

    #   position = [1,2]
    #   color = "white"
    #   let(:bishop) {described_class.new(position, color)}

    #   it "returns the list of tiles" do
    #     result = bishop.get_tiles_attacked
    #     expect(result.sort).to eq([].sort)
    #   end
    # end

    # context "when bishop is at [7,7]" do

    #   position = [7,7]
    #   color = "black"
    #   let(:bishop) {described_class.new(position, color)}

    #   it "returns the list of tiles" do
    #     result = bishop.get_tiles_attacked
    #     expect(result.sort).to eq([].sort)
    #   end
    # end

    # context "when bishop is at [3,4]" do

    #   position = [3,4]
    #   color = "white"
    #   let(:bishop) {described_class.new(position, color)}

    #   it "returns the list of tiles" do
    #     result = bishop.get_tiles_attacked
    #     expect(result.sort).to eq([].sort)
    #   end
    # end

  end

  describe "#get_legal_moves" do

    context "when there are pieces obstructing" do

      it "doesn't include obstructed tiles" do
        result = bishop_attack_pieces.get_legal_moves(board, 1)
        expect(result.sort).to eq([[2,4], [1,5], [0,6], [4,2], [4,4], [5,5], [2,2], [1,1]].sort)
      end
    end

  end

  describe "#pieces_in_range" do

    it "returns a list of coordinates" do
      result = bishop_attack_pieces.get_pieces_in_range(board)
        expect(result.sort).to eq([[0,6], [4,2], [6,6], [1,1]].sort)
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

      it "returns false" do
        expect(bishop_attack_pieces.diagonally_obstructed_tile?(board, [4,2])).to be false
      end

      it "returns false" do
        expect(bishop_attack_pieces.diagonally_obstructed_tile?(board, [0,6])).to be false
      end

      it "returns false" do
        expect(bishop_attack_pieces.diagonally_obstructed_tile?(board, [5,5])).to be false
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

end