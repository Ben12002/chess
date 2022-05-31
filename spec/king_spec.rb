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


  let(:board) { instance_double(Board)}
  

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

    let(:black_king) { described_class.new(Position.new(4,7), "black") }
    let(:white_king) { described_class.new(Position.new(4,0), "white") }

    context "black king" do
      context "when king has already moved" do
        it "returns false " do
          black_king.instance_variable_set(:@moved_already, true)
          allow(board).to receive(:rook_moved_already?).with("black", 7, 7).and_return false
          allow(board).to receive(:short_castle_tiles_threatened?).with("black").and_return false
          allow(board).to receive(:short_castle_tiles_obstructed?).with("black").and_return false
          expect(black_king.can_castle_short?(board)).to be false
        end
      end

      context "when rook already moved" do
        it "returns false" do
          allow(board).to receive(:rook_moved_already?).with("black", 7, 7).and_return true
          allow(board).to receive(:short_castle_tiles_threatened?).with("black").and_return false
          allow(board).to receive(:short_castle_tiles_obstructed?).with("black").and_return false
          expect(black_king.can_castle_short?(board)).to be false
        end
      end

      context "when tiles are threatened" do
        it "returns false" do
          allow(board).to receive(:rook_moved_already?).with("black", 7, 7).and_return false
          allow(board).to receive(:short_castle_tiles_threatened?).with("black").and_return true
          allow(board).to receive(:short_castle_tiles_obstructed?).with("black").and_return false
          expect(black_king.can_castle_short?(board)).to be false
        end
      end

      context "when tiles are obstructed" do
        it "returns false" do
          allow(board).to receive(:rook_moved_already?).with("black", 7, 7).and_return false
          allow(board).to receive(:short_castle_tiles_threatened?).with("black").and_return false
          allow(board).to receive(:short_castle_tiles_obstructed?).with("black").and_return true
          expect(black_king.can_castle_short?(board)).to be false
        end
      end

      context "otherwise" do
        it "returns true" do
          allow(board).to receive(:rook_moved_already?).with("black", 7, 7).and_return false
          allow(board).to receive(:short_castle_tiles_threatened?).with("black").and_return false
          allow(board).to receive(:short_castle_tiles_obstructed?).with("black").and_return false
          expect(black_king.can_castle_short?(board)).to be true
        end
      end
    end

    context "white king" do
      context "when king has already moved" do
        it "returns false " do
          white_king.instance_variable_set(:@moved_already, true)
          allow(board).to receive(:rook_moved_already?).with("white", 7, 0).and_return false
          allow(board).to receive(:short_castle_tiles_threatened?).with("white").and_return false
          allow(board).to receive(:short_castle_tiles_obstructed?).with("white").and_return false
          expect(white_king.can_castle_short?(board)).to be false
        end
      end

      context "when rook already moved" do
        it "returns false" do
          allow(board).to receive(:rook_moved_already?).with("white", 7, 0).and_return true
          allow(board).to receive(:short_castle_tiles_threatened?).with("white").and_return false
          allow(board).to receive(:short_castle_tiles_obstructed?).with("white").and_return false
          expect(white_king.can_castle_short?(board)).to be false
        end
      end

      context "when tiles are threatened" do
        it "returns false" do
          allow(board).to receive(:rook_moved_already?).with("white", 7, 0).and_return false
          allow(board).to receive(:short_castle_tiles_threatened?).with("white").and_return true
          allow(board).to receive(:short_castle_tiles_obstructed?).with("white").and_return false
          expect(white_king.can_castle_short?(board)).to be false
        end
      end

      context "when tiles are obstructed" do
        it "returns false" do
          allow(board).to receive(:rook_moved_already?).with("white", 7, 0).and_return false
          allow(board).to receive(:short_castle_tiles_threatened?).with("white").and_return false
          allow(board).to receive(:short_castle_tiles_obstructed?).with("white").and_return true
          expect(white_king.can_castle_short?(board)).to be false
        end
      end

      context "otherwise" do
        it "returns true" do
          allow(board).to receive(:rook_moved_already?).with("white", 7, 0).and_return false
          allow(board).to receive(:short_castle_tiles_threatened?).with("white").and_return false
          allow(board).to receive(:short_castle_tiles_obstructed?).with("white").and_return false
          expect(white_king.can_castle_short?(board)).to be true
        end
      end
    end
  end

  describe "#can_castle_long?" do

    let(:black_king) { described_class.new(Position.new(4,7), "black") }
    let(:white_king) { described_class.new(Position.new(4,0), "white") }

    context "black king" do
      context "when king has already moved" do
        it "returns false " do
          black_king.instance_variable_set(:@moved_already, true)
          allow(board).to receive(:rook_moved_already?).with("black", 0, 7).and_return false
          allow(board).to receive(:long_castle_tiles_threatened?).with("black").and_return false
          allow(board).to receive(:long_castle_tiles_obstructed?).with("black").and_return false
          expect(black_king.can_castle_long?(board)).to be false
        end
      end

      context "when rook already moved" do
        it "returns false" do
          allow(board).to receive(:rook_moved_already?).with("black", 0, 7).and_return true
          allow(board).to receive(:long_castle_tiles_threatened?).with("black").and_return false
          allow(board).to receive(:long_castle_tiles_obstructed?).with("black").and_return false
          expect(black_king.can_castle_long?(board)).to be false
        end
      end

      context "when tiles are threatened" do
        it "returns false" do
          allow(board).to receive(:rook_moved_already?).with("black", 0, 7).and_return false
          allow(board).to receive(:long_castle_tiles_threatened?).with("black").and_return true
          allow(board).to receive(:long_castle_tiles_obstructed?).with("black").and_return false
          expect(black_king.can_castle_long?(board)).to be false
        end
      end

      context "when tiles are obstructed" do
        it "returns false" do
          allow(board).to receive(:rook_moved_already?).with("black", 0, 7).and_return false
          allow(board).to receive(:long_castle_tiles_threatened?).with("black").and_return false
          allow(board).to receive(:long_castle_tiles_obstructed?).with("black").and_return true
          expect(black_king.can_castle_long?(board)).to be false
        end
      end

      context "otherwise" do
        it "returns true" do
          allow(board).to receive(:rook_moved_already?).with("black", 0, 7).and_return false
          allow(board).to receive(:long_castle_tiles_threatened?).with("black").and_return false
          allow(board).to receive(:long_castle_tiles_obstructed?).with("black").and_return false
          expect(black_king.can_castle_long?(board)).to be true
        end
      end
    end

    context "white king" do
      context "when king has already moved" do
        it "returns false " do
          white_king.instance_variable_set(:@moved_already, true)
          allow(board).to receive(:rook_moved_already?).with("white", 0, 0).and_return false
          allow(board).to receive(:long_castle_tiles_threatened?).with("white").and_return false
          allow(board).to receive(:long_castle_tiles_obstructed?).with("white").and_return false
          expect(white_king.can_castle_long?(board)).to be false
        end
      end

      context "when rook already moved" do
        it "returns false" do
          allow(board).to receive(:rook_moved_already?).with("white", 0, 0).and_return true
          allow(board).to receive(:long_castle_tiles_threatened?).with("white").and_return false
          allow(board).to receive(:long_castle_tiles_obstructed?).with("white").and_return false
          expect(white_king.can_castle_long?(board)).to be false
        end
      end

      context "when tiles are threatened" do
        it "returns false" do
          allow(board).to receive(:rook_moved_already?).with("white", 0, 0).and_return false
          allow(board).to receive(:long_castle_tiles_threatened?).with("white").and_return true
          allow(board).to receive(:long_castle_tiles_obstructed?).with("white").and_return false
          expect(white_king.can_castle_long?(board)).to be false
        end
      end

      context "when tiles are obstructed" do
        it "returns false" do
          allow(board).to receive(:rook_moved_already?).with("white", 0, 0).and_return false
          allow(board).to receive(:long_castle_tiles_threatened?).with("white").and_return false
          allow(board).to receive(:long_castle_tiles_obstructed?).with("white").and_return true
          expect(white_king.can_castle_long?(board)).to be false
        end
      end

      context "otherwise" do
        it "returns true" do
          allow(board).to receive(:rook_moved_already?).with("white", 0, 0).and_return false
          allow(board).to receive(:long_castle_tiles_threatened?).with("white").and_return false
          allow(board).to receive(:long_castle_tiles_obstructed?).with("white").and_return false
          expect(white_king.can_castle_long?(board)).to be true
        end
      end
    end
  end

  describe "#get_legal_moves" do

    let(:white_king) { described_class.new(Position.new(4,0), "white") }

    context "when white king, can short castle, cannot long castle, tiles above are threatened, tile to the left is blocked." do

      before do
        allow(white_king).to receive(:can_castle_short?).with(board).and_return true
        allow(white_king).to receive(:can_castle_long?).with(board).and_return false

        allow(board).to receive(:threatened_tile?).with("white", Position.new(3,0)).and_return false
        allow(board).to receive(:threatened_tile?).with("white", Position.new(3,1)).and_return true
        allow(board).to receive(:threatened_tile?).with("white", Position.new(4,1)).and_return true
        allow(board).to receive(:threatened_tile?).with("white", Position.new(5,1)).and_return true
        allow(board).to receive(:threatened_tile?).with("white", Position.new(5,0)).and_return false

        allow(board).to receive(:same_color?).with("white", 3, 0).and_return true
        allow(board).to receive(:same_color?).with("white", 3, 1).and_return false
        allow(board).to receive(:same_color?).with("white", 4, 1).and_return false
        allow(board).to receive(:same_color?).with("white", 5, 1).and_return false
        allow(board).to receive(:same_color?).with("white", 5, 0).and_return false
        
      end
      it "returns a list of legal moves" do
        result = white_king.get_legal_moves(board, 1)
        expect(result).to contain_exactly(Position.new(5,0), Position.new(6,0))
      end
    end
  end
end