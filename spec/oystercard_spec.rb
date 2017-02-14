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

  describe '#deduct' do
    it { is_expected.to respond_to(:deduct).with(1).argument }

    it 'deducts a fare from the card balance' do
      subject.top_up 30
      expect{ subject.deduct 5 }.to change{ subject.balance }.by -5
    end
  end

  describe '#in_journey?' do
    it { is_expected.not_to be_in_journey }

    it 'is in journey after touching in' do
      subject.touch_in
      expect(subject).to be_in_journey
    end

    it 'is not in journey after touching in then out' do
      subject.touch_in
      subject.touch_out
      expect(subject).not_to be_in_journey
    end
  end

  describe '#touch_in' do
    it { is_expected.to respond_to(:touch_in) }
  end

  describe '#touch_out' do
    it { is_expected.to respond_to(:touch_out) }
  end
end
