require_relative '../lib/AlgebraicNotationMove'

describe AlgebraicNotationMove do
  describe "#valid_format?" do

    context "pawn move" do
  
      context "regular move" do
        it "c5 returns true" do
          input = "c5"
          result = AlgebraicNotationMove.valid_format?(input)
          expect(result).to be true
        end
  
        it "h8 returns true" do
          input = "h8"
          result = AlgebraicNotationMove.valid_format?(input)
          expect(result).to be true
        end
  
        it "a1 returns true" do
          input = "a1"
          result = AlgebraicNotationMove.valid_format?(input)
          expect(result).to be true
        end
  
        it "a9 returns false" do
          input = "a9"
          result = AlgebraicNotationMove.valid_format?(input)
          expect(result).to be false
        end
  
        it "j9 returns false" do
          input = "j9"
          result = AlgebraicNotationMove.valid_format?(input)
          expect(result).to be false
        end

        it "j5 returns false" do
          input = "j5"
          result = AlgebraicNotationMove.valid_format?(input)
          expect(result).to be false
        end
      end
  
      context "capture" do
        
        # axg5 is not possible in reality, since pawns can only capture pieces in adjacent columns.
        # do we ignore this here and leave it to Board.legal_move? ?

        # How about inputs like axb9 or zxf5? these would crash board, since 9 is out of array bounds.
        # Can we use Move.convert to filter out moves like this? e.g: if it converts to [x,y] where x or y > 7,
        # Then it is invalid?
  
        xit "axg5 returns true" do
          input = "axg5"
          result = AlgebraicNotationMove.valid_format?(input)
          expect(result).to be true
        end
  
        xit "gxh8 returns true" do
          input = "gxh8"
          result = AlgebraicNotationMove.valid_format?(input)
          expect(result).to be true
        end
  
        xit "a1 returns true" do
          input = "a1"
          result = AlgebraicNotationMove.valid_format?(input)
          expect(result).to be true
        end
      end
    end

    context "invalid format" do

      context "it has extra letters" do

        xit "returns false" do
          input = "cc5"
          result = AlgebraicNotationMove.valid_format?(input)
          expect(result).to be false
        end
      end
    end
    
  end
end
