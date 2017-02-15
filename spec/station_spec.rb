require 'station'

describe Station do
  subject { Station.new :name, :zone }
  it 'returns the station name' do
    expect(subject.name).to eq :name
  end

  it 'returns the station zone' do
    expect(subject.zone).to eq :zone
  end
end
