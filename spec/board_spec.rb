require_relative '../lib/board'


describe Board do

  subject(:board) { described_class.new(Array.new(8) { Array.new(8, " ") }) }

  describe '#promotion?' do
    context 'When it is a promotion' do

      context 'when white pawn promotion' do
        let(:white_pawn) { instance_double(Pawn, position: Position.new(3,6), color: "white") }
        it 'returns true' do
          allow(board).to receive(:get_square).with(3,6).and_return(white_pawn)
          allow(white_pawn).to receive(:is_a?).with(Pawn).and_return(true)
          expect(board.promotion?(Position.new(3,6), Position.new(3,7))).to be true
        end
      end

      context 'when black pawn promotion' do
        let(:black_pawn) { instance_double(Pawn, position: Position.new(3,1), color: "black") }
        it 'returns true' do
          allow(board).to receive(:get_square).with(3,1).and_return(black_pawn)
          allow(black_pawn).to receive(:is_a?).with(Pawn).and_return(true)
          expect(board.promotion?(Position.new(3,1), Position.new(3,0))).to be true
        end
      end
    end

    context 'When it is not a promotion' do
      context 'when not a pawn' do
        let(:white_rook) { instance_double(Rook, position: Position.new(3,6), color: "white") }
        it 'returns false' do
          allow(board).to receive(:get_square).with(3,6).and_return(white_rook)
          allow(white_rook).to receive(:is_a?).with(Pawn).and_return(false)
          expect(board.promotion?(Position.new(3,6), Position.new(3,7))).to be false
        end
      end

      context 'when not a pawn promotion' do
        let(:black_pawn) { instance_double(Pawn, position: Position.new(3,2), color: "black") }
        it 'returns false' do
          allow(board).to receive(:get_square).with(3,2).and_return(black_pawn)
          allow(black_pawn).to receive(:is_a?).with(Pawn).and_return(true)
          expect(board.promotion?(Position.new(3,2), Position.new(3,1))).to be false
        end
      end
    end
  end

  describe '#promote' do
    context 'when white pawn promotion to queen' do

      let(:white_pawn) { instance_double(Pawn, position: Position.new(3,6), color: "white") }
      let(:queen) { instance_double(Queen, position: Position.new(3,7), color: "white" ) } 

      before do
        board.instance_variable_set(:@white_pieces, [])
        board.instance_variable_set(:@black_pieces, [])
      end
    
      it 'returns true' do
        board_arr = board.instance_variable_get(:@arr)
        board_arr[3][6] = white_pawn

        allow(board).to receive(:get_square).with(3,6).and_return(white_pawn)
        allow(white_pawn).to receive(:is_a?).with(Pawn).and_return(true)
        allow(queen).to receive(:is_a?).with(Queen).and_return true
        allow(Queen).to receive(:new).and_return(queen)

        board.promote(Position.new(3,6), Position.new(3,7), "queen")
        expect(board_arr[3][7].is_a?(Queen)).to be true
      end
    end
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
