require 'oystercard'

describe Oystercard do

  subject(:oystercard) {Oystercard.new}
  let(:max_balance) {Oystercard::DEFAULT_LIMIT}
  let(:max_balance_error) {Oystercard::MAX_BALANCE_ERROR}
  let(:min_balance_error) {Oystercard::MIN_BALANCE_ERROR}
  let(:fare) {Oystercard::FARE}
  let(:rand_num) {rand(1..40)}
  let(:station) {double :station}


  describe '#initialize' do
    it 'has balance = 0' do
      expect(oystercard.balance).to eq 0
    end
  end


  describe '#top_up' do

    it 'allows user to top up' do
      expect{ oystercard.top_up(rand_num)}.to change { oystercard.balance }.by rand_num
    end

    it 'raises an error when balance exceeds £90' do
      oystercard.top_up(max_balance)
      expect{ oystercard.top_up(rand_num) }.to raise_error max_balance_error
    end

  end

  describe '#touch_in' do
    it 'allows to start journey' do
      oystercard.top_up(rand_num)
      expect(oystercard).to respond_to(:touch_in)
    end

    it'raises an error if balance is 0' do
      expect {oystercard.touch_in(station)}.to raise_error min_balance_error
    end

    it 'allows to record start of journey station' do
      expect(oystercard).to respond_to(:touch_in).with(1).argument
    end

    it 'stores the entry station' do
      oystercard.top_up(rand_num)
      oystercard.touch_in(station)
      expect(oystercard.entry_station).to eq station
    end
  end

  describe '#touch_out' do
    it 'allows to end journey' do
      oystercard.top_up(rand_num)
      expect(oystercard).to respond_to(:touch_out)
    end

    it 'deducts fare from card' do
      oystercard.top_up(rand_num)
      expect {oystercard.touch_out}.to change{oystercard.balance}.by (-fare)
    end
  end

  context '#in_journey' do
    it 'returns status for touch in' do
      oystercard.top_up(rand_num)
      oystercard.touch_in(station)
      expect(oystercard.in_journey?).to eq station
    end

    it 'retuns status for touch_out' do
      oystercard.top_up(rand_num)
      oystercard.touch_in(station)
      oystercard.touch_out
      expect(oystercard.in_journey?).to eq nil
    end
  end




end
