require_relative '../lib/game'
require_relative '../lib/board'
require_relative '../lib/player'


describe Game do

  subject(:game){ described_class.new }

  before do
    game.instance_variable_set(:@board, instance_double(Board))
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
    end

    context "when invalid, then valid" do
    end
  end

  describe "#valid_move_format" do
    context "when valid" do
    end

    context "when invalid" do
      context "when out of bounds" do
      end

      context "when wrong format" do
      end
    end
  end


  describe "#get_move_input" do
  
    context "when valid move" do
    end

    context "when valid command" do
    end

    context "when invalid twice, then valid" do
    end
  end



  
end