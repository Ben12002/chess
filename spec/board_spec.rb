require_relative '../lib/board'


describe Board do

  subject(:board) { described_class.new(Array.new(8) { Array.new(8, " ") }) }

  describe '#create_piece' do
    context 'when piece type is queen' do
      let(:white_queen) { instance_double(Queen, position: Position.new(3,7), color: "white") }
      it 'sends a message to Queen' do
        allow(Queen).to receive(:new).with(Position.new(3,7), "white").and_return(white_queen)
        expect(Queen).to receive(:new).with(Position.new(3,7), "white")
        expect(board.create_piece("queen", "white", Position.new(3,7))).to eq(white_queen)

      end
    end

    context 'when piece type is bishop' do
      let(:black_bishop) { instance_double(Bishop, position: Position.new(4,0), color: "black") }
      it 'sends a message to Bishop' do
        allow(Bishop).to receive(:new).with(Position.new(4,0), "black").and_return(black_bishop)
        expect(Bishop).to receive(:new).with(Position.new(4,0), "black")
        expect(board.create_piece("bishop", "black", Position.new(4,0))).to eq(black_bishop)
      end
    end

    context 'when piece type is rook' do
      let(:black_rook) { instance_double(Rook, position: Position.new(7,0), color: "black") }
      it 'sends a message to Rook' do
        allow(Rook).to receive(:new).with(Position.new(7,0), "black").and_return(black_rook)
        expect(Rook).to receive(:new).with(Position.new(7,0), "black")
        expect(board.create_piece("rook", "black", Position.new(7,0))).to eq(black_rook)
      end
    end

    context 'when piece type is knight' do
      let(:white_knight) { instance_double(Knight, position: Position.new(7,7), color: "white") }
      it 'sends a message to Knight' do
        allow(Knight).to receive(:new).with(Position.new(7,7), "white").and_return(white_knight)
        expect(Knight).to receive(:new).with(Position.new(7,7), "white")
        expect(board.create_piece("knight", "white", Position.new(7,7))).to eq(white_knight)
      end
    end
  end

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
    context 'when a white pawn is promoted to queen' do

      let(:white_pawn) { instance_double(Pawn, position: Position.new(3,6), color: "white") }
      let(:queen) { instance_double(Queen, position: Position.new(3,7), color: "white" ) } 
    
      it 'has a queen in the correct square' do
        board_arr = board.instance_variable_get(:@arr)
        board_arr[3][6] = white_pawn

        allow(board).to receive(:get_square).with(3,6).and_return(white_pawn)
        allow(white_pawn).to receive(:is_a?).with(Pawn).and_return(true)
        allow(queen).to receive(:is_a?).with(Queen).and_return true
        allow(board).to receive(:create_piece).and_return(queen)

        board.promote(Position.new(3,6), Position.new(3,7), "queen")
        expect(board_arr[3][7].is_a?(Queen)).to be true
        expect(board_arr[3][6]).to eq(" ")
      end
    end

    context 'when a black pawn is promoted to knight' do
      let(:black_pawn) { instance_double(Pawn, position: Position.new(4,1), color: "black") }
      let(:knight) { instance_double(Knight, position: Position.new(4,0), color: "black" ) } 
    
      it 'has a queen in the correct square' do
        board_arr = board.instance_variable_get(:@arr)
        board_arr[4][1] = black_pawn

        allow(board).to receive(:get_square).with(4,1).and_return(black_pawn)
        allow(black_pawn).to receive(:is_a?).with(Pawn).and_return(true)
        allow(knight).to receive(:is_a?).with(Knight).and_return true
        allow(board).to receive(:create_piece).and_return(knight)

        board.promote(Position.new(4,1), Position.new(4,0), "knight")
        expect(board_arr[4][0].is_a?(Knight)).to be true
        expect(board_arr[4][1]).to eq(" ")
      end
    end
  end

  describe '#capture_piece' do
    let(:black_pawn) { instance_double(Pawn, position: Position.new(5,6), color: "black") }
    context 'when capturing a piece at 5,6' do
      it 'removes that piece from 5,6, replacing it with an empty string, and deletes it from its piece array' do
        board_arr = board.instance_variable_get(:@arr)
        board_black_pieces = board.instance_variable_get(:@black_pieces)
        board_arr[5][6] = black_pawn
        board_black_pieces.push(black_pawn)
        
        expect { board.capture_piece(Position.new(5,6)) }.to change { board_black_pieces.length}.by(-1)
        expect(board_arr[5][6]).to eq(" ")
      end
    end
  end

  describe '#castle?'do
  let(:black_king) { instance_double(King, position: Position.new(4,7), color: "black") }
  let(:white_king) { instance_double(King, position: Position.new(4,0), color: "white") }

  before do
    allow(black_king).to receive(:is_a?).with(King).and_return true
    allow(white_king).to receive(:is_a?).with(King).and_return true
  end
    context 'when white king is castling long' do
      it 'returns true' do
        expect(board.castle?(white_king, Position.new(4,0), Position.new(2,0))).to be true
      end
    end

    context 'when white king is castling short' do
      it 'returns true' do
        expect(board.castle?(white_king, Position.new(4,0), Position.new(6,0))).to be true
      end
    end

    context 'when black king is castling long' do
      it 'returns true' do
        expect(board.castle?(black_king, Position.new(4,7), Position.new(2,7))).to be true
      end
    end

    context 'when black king is castling long' do
      it 'returns true' do
        expect(board.castle?(black_king, Position.new(4,7), Position.new(6,7))).to be true
      end
    end

    context 'when black king is not castling' do
      it 'returns false' do
        expect(board.castle?(black_king, Position.new(4,7), Position.new(5,7))).to be false
      end
    end

  end

  describe '#all_attacked_tiles' do
    context "when there is a white rook and bishop on the board" do
      let(:white_rook) { instance_double(Rook, position: Position.new(1,1), color: "white") }
      let(:white_bishop) { instance_double(Bishop, position: Position.new(4,2), color: "white") }

      before do
        allow(white_rook).to receive(:get_attacked_tiles).with(board).and_return([Position.new(0,1), Position.new(1,0), Position.new(1,2), Position.new(2,1)])
        allow(white_bishop).to receive(:get_attacked_tiles).with(board).and_return([Position.new(3,3), Position.new(3,1), Position.new(5,1), Position.new(5,3)])
      end

      it 'returns a list containing all the tiles attacked by either of them' do 
        board_white_pieces = board.instance_variable_get(:@white_pieces)
        board_white_pieces.push(white_rook)
        board_white_pieces.push(white_bishop)
        expect(board.all_attacked_tiles("white")).to contain_exactly(Position.new(0,1), Position.new(1,0), Position.new(1,2), Position.new(2,1),
                                                                     Position.new(3,3), Position.new(3,1), Position.new(5,1), Position.new(5,3))
      end
    end
  end

  describe '#player_in_check?' do
    context "when black king in check" do
      let(:black_rook) { instance_double(Rook, position: Position.new(1,1), color: "black") }
      let(:black_bishop) { instance_double(Bishop, position: Position.new(4,2), color: "black") }
      let(:black_king) { instance_double(King, position: Position.new(0,1), color: "black") }
      before do
        allow(black_bishop).to receive(:is_a?).with(King).and_return false
        allow(black_rook).to receive(:is_a?).with(King).and_return false
        allow(black_king).to receive(:is_a?).with(King).and_return true
        allow(black_king).to receive(:in_check?).with(board).and_return true
        board_black_pieces = board.instance_variable_get(:@black_pieces)
        board_black_pieces.push(black_rook)
        board_black_pieces.push(black_bishop)
        board_black_pieces.push(black_king)
      end
      it "returns true" do
        expect(board.player_in_check?("black")).to be true
      end
    end

    context "when white king not in check" do
      let(:white_rook) { instance_double(Rook, position: Position.new(1,1), color: "white") }
      let(:white_king) { instance_double(King, position: Position.new(0,1), color: "white") }
      before do
        allow(white_rook).to receive(:is_a?).with(King).and_return false
        allow(white_king).to receive(:is_a?).with(King).and_return true
        allow(white_king).to receive(:in_check?).with(board).and_return false
        board_white_pieces = board.instance_variable_get(:@white_pieces)
        board_white_pieces.push(white_rook)
        board_white_pieces.push(white_king)
      end
      it "returns true" do
        expect(board.player_in_check?("white")).to be false
      end
    end
  end

  describe '#king_and_knight_vs_king?' do
    context "when white king and knight vs black king" do
      let(:white_knight) { instance_double(Knight, position: Position.new(1,1), color: "white") }
      let(:white_king) { instance_double(King, position: Position.new(0,1), color: "white") }
      let(:black_king) { instance_double(King, position: Position.new(5,5), color: "black") }
      before do
        allow(white_knight).to receive(:is_a?).with(King).and_return false
        allow(white_knight).to receive(:is_a?).with(Knight).and_return true
        allow(white_king).to receive(:is_a?).with(King).and_return true
        allow(white_king).to receive(:is_a?).with(Knight).and_return false
        allow(black_king).to receive(:is_a?).with(King).and_return true
        allow(black_king).to receive(:is_a?).with(Knight).and_return false
        board_white_pieces = board.instance_variable_get(:@white_pieces)
        board_white_pieces.push(white_knight)
        board_white_pieces.push(white_king)
        board_black_pieces = board.instance_variable_get(:@black_pieces)
        board_black_pieces.push(black_king)
      end
      it "returns true" do
        expect(board.king_and_knight_vs_king?).to be true
      end
    end

    context "when black king and rook vs white king" do
      let(:white_king) { instance_double(King, position: Position.new(0,1), color: "white") }
      let(:black_rook) { instance_double(Rook, position: Position.new(4,4), color: "black") }
      let(:black_king) { instance_double(King, position: Position.new(5,5), color: "black") }
      before do
        allow(white_king).to receive(:is_a?).with(King).and_return true
        allow(white_king).to receive(:is_a?).with(Knight).and_return false
        allow(black_rook).to receive(:is_a?).with(King).and_return false
        allow(black_rook).to receive(:is_a?).with(Knight).and_return false
        allow(black_king).to receive(:is_a?).with(King).and_return true
        allow(black_king).to receive(:is_a?).with(Knight).and_return false
        board_white_pieces = board.instance_variable_get(:@white_pieces)
        board_white_pieces.push(white_king)
        board_black_pieces = board.instance_variable_get(:@black_pieces)
        board_black_pieces.push(black_king)
        board_black_pieces.push(black_rook)
      end
      it "returns false" do
        expect(board.king_and_knight_vs_king?).to be false
      end
    end
    
  end

  describe '#king_and_bishop_vs_king?' do
    context 'when black bishop and king vs white king' do
      let(:black_bishop) { instance_double(Bishop, position: Position.new(4,2), color: "black") }
      let(:black_king) { instance_double(King, position: Position.new(0,1), color: "black") }
      let(:white_king) { instance_double(King, position: Position.new(6,1), color: "white") }
      before do
        allow(white_king).to receive(:is_a?).with(King).and_return true
        allow(white_king).to receive(:is_a?).with(Bishop).and_return false
        allow(black_king).to receive(:is_a?).with(King).and_return true
        allow(black_king).to receive(:is_a?).with(Bishop).and_return false
        allow(black_bishop).to receive(:is_a?).with(King).and_return false
        allow(black_bishop).to receive(:is_a?).with(Bishop).and_return true
        board_white_pieces = board.instance_variable_get(:@white_pieces)
        board_black_pieces = board.instance_variable_get(:@black_pieces)
        board_white_pieces.push(white_king)
        board_black_pieces.push(black_king)
        board_black_pieces.push(black_bishop)
      end
      it 'returns true' do
        expect(board.king_and_bishop_vs_king?).to be true
      end
    end

    context 'when 2 white bishops and king vs black king' do
      let(:white_bishop_one) { instance_double(Bishop, position: Position.new(4,2), color: "white") }
      let(:white_bishop_two) { instance_double(Bishop, position: Position.new(5,2), color: "white") }
      let(:white_king) { instance_double(King, position: Position.new(0,1), color: "black") }
      let(:black_king) { instance_double(King, position: Position.new(1,1), color: "black") }
      before do
        allow(white_king).to receive(:is_a?).with(King).and_return true
        allow(white_king).to receive(:is_a?).with(Bishop).and_return false
        allow(black_king).to receive(:is_a?).with(King).and_return true
        allow(black_king).to receive(:is_a?).with(Bishop).and_return false
        allow(white_bishop_one).to receive(:is_a?).with(King).and_return false
        allow(white_bishop_one).to receive(:is_a?).with(Bishop).and_return true
        allow(white_bishop_two).to receive(:is_a?).with(King).and_return false
        allow(white_bishop_two).to receive(:is_a?).with(Bishop).and_return true
        board_white_pieces = board.instance_variable_get(:@white_pieces)
        board_black_pieces = board.instance_variable_get(:@black_pieces)
        board_white_pieces.push(white_king)
        board_white_pieces.push(white_bishop_one)
        board_white_pieces.push(white_bishop_two)
        board_black_pieces.push(black_king)
      end
      it 'returns false' do
        expect(board.king_and_bishop_vs_king?).to be false
      end
    end
  end

  describe '#same_color_bishop_draw?' do
    context 'when white dark square bishop and king vs black dark square bishop and black king' do
      let(:white_bishop) { instance_double(Bishop, position: Position.new(4,2), color: "white", file: 4, rank: 2) }
      let(:white_king) { instance_double(King, position: Position.new(0,1), color: "black", file: 0, rank: 1) }
      let(:black_bishop) { instance_double(Bishop, position: Position.new(6,2), color: " black", file: 6, rank: 2) }
      let(:black_king) { instance_double(King, position: Position.new(1,1), color: "black", file: 1, rank: 1) }
      before do
        allow(white_king).to receive(:is_a?).with(King).and_return true
        allow(white_king).to receive(:is_a?).with(Bishop).and_return false
        allow(black_king).to receive(:is_a?).with(King).and_return true
        allow(black_king).to receive(:is_a?).with(Bishop).and_return false
        allow(white_bishop).to receive(:is_a?).with(King).and_return false
        allow(white_bishop).to receive(:is_a?).with(Bishop).and_return true
        allow(black_bishop).to receive(:is_a?).with(King).and_return false
        allow(black_bishop).to receive(:is_a?).with(Bishop).and_return true
        board_white_pieces = board.instance_variable_get(:@white_pieces)
        board_black_pieces = board.instance_variable_get(:@black_pieces)
        board_white_pieces.push(white_king)
        board_white_pieces.push(white_bishop)
        board_black_pieces.push(black_king)
        board_black_pieces.push(black_bishop)
      end
      it 'returns true' do
        expect(board.same_color_bishop_draw?).to be true
      end
    end

    context 'when white dark square bishop and king vs black light square bishop and black king' do
      let(:white_bishop) { instance_double(Bishop, position: Position.new(4,2), color: "white", file: 4, rank: 2) }
      let(:white_king) { instance_double(King, position: Position.new(0,1), color: "black", file: 0, rank: 1) }
      let(:black_bishop) { instance_double(Bishop, position: Position.new(5,2), color: " black", file: 5, rank: 2) }
      let(:black_king) { instance_double(King, position: Position.new(1,1), color: "black", file: 1, rank: 1) }
      before do
        allow(white_king).to receive(:is_a?).with(King).and_return true
        allow(white_king).to receive(:is_a?).with(Bishop).and_return false
        allow(black_king).to receive(:is_a?).with(King).and_return true
        allow(black_king).to receive(:is_a?).with(Bishop).and_return false
        allow(white_bishop).to receive(:is_a?).with(King).and_return false
        allow(white_bishop).to receive(:is_a?).with(Bishop).and_return true
        allow(black_bishop).to receive(:is_a?).with(King).and_return false
        allow(black_bishop).to receive(:is_a?).with(Bishop).and_return true
        board_white_pieces = board.instance_variable_get(:@white_pieces)
        board_black_pieces = board.instance_variable_get(:@black_pieces)
        board_white_pieces.push(white_king)
        board_white_pieces.push(white_bishop)
        board_black_pieces.push(black_king)
        board_black_pieces.push(black_bishop)
      end
      it 'returns true' do
        expect(board.same_color_bishop_draw?).to be false
      end
    end
  end
end
