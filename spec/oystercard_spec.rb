require 'oystercard'

describe Oystercard do
  let(:entry_station){ double :station }
  let(:exit_station){ double :station }

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

  describe '#in_journey?' do
    it { is_expected.not_to be_in_journey }

    it 'is in journey after touching in' do
      subject.top_up Oystercard::MIN_BALANCE
      subject.touch_in(entry_station)
      expect(subject).to be_in_journey
    end

    it 'is not in journey after touching in then out' do
      subject.top_up Oystercard::MIN_BALANCE
      subject.touch_in(entry_station)
      subject.touch_out(exit_station)
      expect(subject).not_to be_in_journey
    end
  end

  describe '#touch_in' do
    it { is_expected.to respond_to(:touch_in) }

    it 'refuses to touch in below minimum balance' do
      min_balance = Oystercard::MIN_BALANCE
      subject.top_up min_balance - 1
      expect { subject.touch_in(entry_station) }.to raise_error "Below min balance of #{min_balance}"
    end
  end

  describe '#touch_out' do
    it { is_expected.to respond_to(:touch_out) }

    it 'deducts the minimum charge when touching out' do
      min_balance = Oystercard::MIN_BALANCE
      subject.top_up min_balance
      subject.touch_in(entry_station)
      expect{ subject.touch_out(exit_station) }.to change{ subject.balance }.by -min_balance
    end
  end

  describe '#entry_station' do
    it 'stores the entry station' do
      min_balance = Oystercard::MIN_BALANCE
      subject.top_up min_balance
      subject.touch_in(entry_station)
      expect(subject.entry_station).to eq entry_station
    end

    it 'removes the entry station after touching out' do
      min_balance = Oystercard::MIN_BALANCE
      subject.top_up min_balance
      subject.touch_in(entry_station)
      subject.touch_out(exit_station)
      expect(subject.entry_station).to eq nil
    end
  end

  describe '#exit_station' do
    it 'stores exit station on touching out' do
      min_balance = Oystercard::MIN_BALANCE
      subject.top_up min_balance
      subject.touch_in(entry_station)
      subject.touch_out(exit_station)
      expect(subject.exit_station).to eq exit_station
    end
  end

  describe '#journeys' do
    let (:journey){ { entry_station: entry_station, exit_station: exit_station } }

    it 'has a list of empty journeys by default' do
      expect(subject.journeys).to be_empty
    end

    it 'can store and retrieve a single journey' do
      min_balance = Oystercard::MIN_BALANCE
      subject.top_up min_balance
      subject.touch_in(entry_station)
      subject.touch_out(exit_station)
      expect(subject.journeys).to include journey
    end
  end
end
