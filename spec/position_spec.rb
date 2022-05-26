require_relative '../lib/position'

describe Position do
  
  it 'returns true' do
    pos1 = Position.new(1,2)
    pos2 = Position.new(1,2)
    expect(pos1).to eq(pos2)
  end

  it 'returns true' do
    pos1 = Position.new(1,2)
    pos2 = Position.new(1,2)
    arr1 = [pos1, pos2]

    pos3 = Position.new(1,2)
    pos4 = Position.new(1,2)
    arr2 = [pos3, pos4]
    
    expect(arr1).to eq(arr2)
  end

  it 'returns true' do
    pos1 = Position.new(1,2)
    
    arr1 = [Position.new(1,3), Position.new(1,2)]
    
    expect(arr1.include?(pos1)).to be true
  end

end