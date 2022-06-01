require_relative '../lib/game'
require_relative '../lib/board'
require_relative '../lib/player'


describe Game do

  subject(:game){ described_class.new }

  before do
    game.instance_variable_set(:@board, instance_double(Board))
    game.instance_variable_set(:@white, instance_double(Player, name: "hello"))
  end

  describe "#get_name_input" do
  
    context "when valid name" do
      it "returns the name" do
        valid_name = "ben"
        allow(game).to receive(:gets).and_return(valid_name)
        result = game.get_name_input
        expect(result).to eq(valid_name)
      end
    end

    context "when name too long, then valid" do
      it "it prints an error message, then returns the name" do
        invalid_name = "aojfbaoejbfoabfeobfoeabfjoasbfoaubfojasbfoabasffsasfasfasfa"
        valid_name = "ben"
        allow(game).to receive(:gets).and_return(invalid_name, valid_name)
        expect(game).to receive(:print).with("Please enter your name: ").twice
        expect(game).to receive(:print).with("Please enter less than 20 characters: ").once
        result = game.get_name_input
        expect(result).to eq(valid_name)
      end
    end
  end

  describe "#ply" do

    context "when given a promotion move" do
      it "calls methods on board" do
        board = game.instance_variable_get(:@board)
        move_input = [Position.new(3,6), Position.new(3,7)]
        white = game.instance_variable_get(:@white)

        allow(game).to receive(:get_move_input).and_return(move_input)
        allow(board).to receive(:promotion?).with(move_input[0], move_input[1]).and_return true
        allow(game).to receive(:get_promotion_input).and_return("queen")
        allow(board).to receive(:promote).with(move_input[0], move_input[1], "queen")

        expect(board).to receive(:promotion?).with(move_input[0], move_input[1]).and_return true
        expect(board).to receive(:promote).with(move_input[0], move_input[1], "queen")

        game.ply(white)
      end
    end

    context "when given a regular move" do
      it "calls methods on board" do
        board = game.instance_variable_get(:@board)
        ply = game.instance_variable_get(:@ply)
        move_input = [Position.new(3,1), Position.new(3,3)]
        white = game.instance_variable_get(:@white)

        allow(game).to receive(:get_move_input).and_return(move_input)
        allow(board).to receive(:promotion?).with(move_input[0], move_input[1]).and_return false
        allow(board).to receive(:move).with(move_input[0], move_input[1], ply)

        expect(board).to receive(:promotion?).with(move_input[0], move_input[1]).and_return false
        expect(board).not_to receive(:promote).with(move_input[0], move_input[1], "queen")
        expect(board).to receive(:move).with(move_input[0], move_input[1], ply)

        game.ply(white)
      end
    end
  end

  describe "#get_promotion_input" do
    context "when valid name" do
      it "returns the input" do
        allow(game).to receive(:gets).and_return("queen")
        result = game.get_promotion_input
        expect(result).to eq("queen")
      end
    end

    context "when invalid, then valid" do
      it "puts an error message, then returns the input" do
        invalid_input = "hello"
        valid_input = "knight"
        allow(game).to receive(:gets).and_return(invalid_input, valid_input)
        allow(game).to receive(:puts).with("please enter a valid input. ").once
        result = game.get_promotion_input
        expect(result).to eq(valid_input)
      end
    end
  end

  describe "#valid_move_format?" do
    context "when valid" do
      it "returns true" do
        expect(game.valid_move_format?("3,3")).to be true
      end
    end

    context "when invalid" do
      context "when out of bounds" do
        it "returns true" do
          expect(game.valid_move_format?("8,7")).to be false
        end
      end

      context "when wrong format" do
        it "returns true" do
          expect(game.valid_move_format?("333fqs")).to be false
        end
      end
    end
  end

  describe "#get_from_input" do
  
    context "when valid move" do
      it "returns the position" do
        board = game.instance_variable_get(:@board)
        ply = game.instance_variable_get(:@ply)
        move_input = [Position.new(3,1), Position.new(3,3)]
        white = game.instance_variable_get(:@white)
        valid_input = "3,1"

        allow(game).to receive(:gets).and_return(valid_input)
        allow(board).to receive(:valid_from?).with(white, 3, 1, ply).and_return true
        result = game.get_from_input(white)
        expect(result).to eq(Position.new(3,1))
      end
    end

    context "when valid command" do
      it "returns the command" do
        board = game.instance_variable_get(:@board)
        ply = game.instance_variable_get(:@ply)
        move_input = [Position.new(3,1), Position.new(3,3)]
        white = game.instance_variable_get(:@white)
        valid_input = "help"

        allow(game).to receive(:gets).and_return(valid_input)
        result = game.get_from_input(white)
        expect(result).to eq(valid_input)
      end
    end

    context "when invalid, then valid" do
      it "puts an error message, then returns the position" do
        board = game.instance_variable_get(:@board)
        ply = game.instance_variable_get(:@ply)
        move_input = [Position.new(3,1), Position.new(3,3)]
        white = game.instance_variable_get(:@white)
        valid_input = "3,1"
        invalid_input = "8,8"

        allow(game).to receive(:gets).and_return(invalid_input, valid_input)
        allow(board).to receive(:valid_from?).with(white, 8, 8, ply).and_return false
        allow(board).to receive(:valid_from?).with(white, 3, 1, ply).and_return true

        expect(game).to receive(:puts).with("Please enter a valid move")
        result = game.get_from_input(white)
        expect(result).to eq(Position.new(3,1))
      end
    end
  end

  describe "#get_to_input" do
  
    context "when valid move" do
      it "returns the position" do
        board = game.instance_variable_get(:@board)
        ply = game.instance_variable_get(:@ply)
        move_input = [Position.new(3,1), Position.new(3,3)]
        white = game.instance_variable_get(:@white)
        from = Position.new(3,1)
        valid_input = "3,3"

        allow(game).to receive(:gets).and_return(valid_input)
        allow(board).to receive(:legal_move?).with(from, Position.new(3,3), ply).and_return true
        result = game.get_to_input(white, from)
        expect(result).to eq(Position.new(3,3))
      end
    end

    context "when valid command" do
      it "returns the command" do
        board = game.instance_variable_get(:@board)
        ply = game.instance_variable_get(:@ply)
        move_input = [Position.new(3,1), Position.new(3,3)]
        white = game.instance_variable_get(:@white)
        from = Position.new(3,1)
        valid_input = "resign"

        allow(game).to receive(:gets).and_return(valid_input)
        result = game.get_to_input(white, from)
        expect(result).to eq("resign")
      end
    end

    context "when invalid, then valid" do
      it "returns the command" do
        board = game.instance_variable_get(:@board)
        ply = game.instance_variable_get(:@ply)
        move_input = [Position.new(3,1), Position.new(3,3)]
        white = game.instance_variable_get(:@white)
        from = Position.new(3,1)
        invalid_input = "3,4"
        valid_input = "resign"

        allow(game).to receive(:gets).and_return(invalid_input, valid_input)
        allow(board).to receive(:legal_move?).with(from, Position.new(3,4), ply).and_return false
        expect(game).to receive(:puts).with("Please enter a valid move")
        result = game.get_to_input(white, from)
        expect(result).to eq("resign")
      end
    end
  end
end