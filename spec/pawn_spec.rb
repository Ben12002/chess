require_relative '../lib/bishop'
require_relative '../lib/piece'
require_relative '../lib/board'
require_relative '../lib/pawn'
require_relative '../lib/knight'
require_relative '../lib/bishop'
require_relative '../lib/king'
require_relative '../lib/queen'
require_relative '../lib/position'


describe Pawn do

  subject(:white_pawn) { described_class.new(Position.new(3,4), "white") }
  subject(:black_pawn) { described_class.new(Position.new(6,6), "black") }
  let(:board) { instance_double(Board) }

  describe "#get_attacked_tiles" do
    context "when white pawn" do
      it "returns a list of tiles" do
        result = white_pawn.get_attacked_tiles(board)
        expect(result).to contain_exactly(Position.new(2,5), Position.new(4,5))
      end
    end

    context "when black pawn" do
      it "returns a list of tiles" do
        result = black_pawn.get_attacked_tiles(board)
        expect(result).to contain_exactly(Position.new(5,5), Position.new(7,5))
      end
    end
  end

  describe "#get_vertical_moves" do
    context "when white pawn" do
      it "returns a list of moves" do
        result = white_pawn.get_vertical_moves
        expect(result).to contain_exactly(Position.new(3,5), Position.new(3,6))
      end
    end

    context "when black pawn" do
      it "returns a list of moves" do
        result = black_pawn.get_vertical_moves
        expect(result).to contain_exactly(Position.new(6,5), Position.new(6,4))
      end
    end
  end

  describe "#get_legal_capture_moves" do

    context "Can capture to the left, can enpassant to the right" do
      before do
        allow(board).to receive(:same_color?).with("white", 2,5).and_return(false)
        allow(board).to receive(:square_empty?).with(2,5).and_return(false)
        allow(board).to receive(:can_en_passant?).with("white", 1, Position.new(2,5)).and_return(false)
        allow(white_pawn).to receive(:in_check_if_move?).with(board, Position.new(2,5), 1).and_return(false)

        allow(board).to receive(:same_color?).with("white", 4,5).and_return(false)
        allow(board).to receive(:square_empty?).with(4,5).and_return(true)
        allow(board).to receive(:can_en_passant?).with("white", 1, Position.new(4,5)).and_return(true)
        allow(white_pawn).to receive(:in_check_if_move?).with(board, Position.new(4,5), 1).and_return(false)
      end
      it "returns a list of moves" do
        result = white_pawn.get_legal_capture_moves(board, 1)
        expect(result).to contain_exactly(Position.new(2,5), Position.new(4,5))
      end
    end
  end

  describe "#get_legal_vertical_moves" do

    context "Can double move, but a piece stands 2 tiles in front" do
      before do

        white_pawn.instance_variable_set(:@moved_already, false)

        allow(board).to receive(:square_empty?).with(3,5).and_return(true)
        allow(white_pawn).to receive(:in_check_if_move?).with(board, Position.new(3,5), 1).and_return(false)

        allow(board).to receive(:square_empty?).with(3,6).and_return(false)
        allow(white_pawn).to receive(:in_check_if_move?).with(board, Position.new(3,6), 1).and_return(false)
      end
      it "returns a list of moves" do
        result = white_pawn.get_legal_vertical_moves(board, 1)
        expect(result).to contain_exactly(Position.new(3,5))
      end
    end
  end
end