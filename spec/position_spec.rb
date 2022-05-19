require_relative '../lib/position'

describe Position do
  
  it 'returns true' do
    pos1 = Position.new(1,2)
    pos2 = Position.new(1,2)
    expect(pos1).to eq pos2
  end

end