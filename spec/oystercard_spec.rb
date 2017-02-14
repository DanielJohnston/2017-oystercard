require 'oystercard'

describe Oystercard do
  it 'has a balance of zero' do
    expect(subject.balance).to eq 0
  end

  describe '#top_up' do
    it { is_expected.to respond_to(:top_up).with(1).argument }

    it 'throws an error if exceeding the balance limit' do
      max_balance = Oystercard::MAX_BALANCE
      subject.top_up max_balance
      expect { subject.top_up(1) }.to raise_error "Max balance of #{max_balance} exceeded"
    end
  end
end
