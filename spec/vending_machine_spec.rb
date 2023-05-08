# frozen_string_literal: true

describe VendingMachine do
  let(:vending_machine) { VendingMachine.new }

  describe '#accept_coin' do
    it 'accepts a 10p coin' do
      expect { vending_machine.accept_coin('10p') }.to change { vending_machine.balance }.by(10)
    end

    context 'when coin is invalid' do
      it 'raises an error' do
        expect { vending_machine.accept_coin('pp') }.to raise_exception RuntimeError, 'Invalid coin'
      end
    end
  end

  describe '#request_product' do
    let(:product) { Product.new(50) }

    context 'when balance is less than product price' do
      it 'returns false' do
        expect(vending_machine.request_product(product)).to eq false
      end
    end

    context 'when balance is greater than product price' do
      before do
        vending_machine.accept_coin('£1')
      end

      it 'returns true' do
        expect(vending_machine.request_product(product)).to eq true
      end

      it 'reduces the balance by the product price' do
        expect { vending_machine.request_product(product) }.to change { vending_machine.balance }.from(100).to(50)
      end
    end
  end

  describe '#give_change' do
    let(:vending_machine) do
      VendingMachine.new(balance: 588, available_coin_counts: {
                           '1p' => 1,
                           '2p' => 1,
                           '5p' => 1,
                           '10p' => 10,
                           '20p' => 1,
                           '50p' => 1,
                           '£1' => 1,
                           '£2' => 2
                         })
    end

    it 'returns the correct change' do
      expect(vending_machine.give_change).to eq({
                                                  '1p' => 1,
                                                  '2p' => 1,
                                                  '5p' => 1,
                                                  '10p' => 1,
                                                  '20p' => 1,
                                                  '50p' => 1,
                                                  '£1' => 1,
                                                  '£2' => 2
                                                })
    end

    it 'reduces the balance by the change amount' do
      expect { vending_machine.give_change }.to change { vending_machine.balance }.from(588).to(0)
    end

    it 'reduces the available coin counts by the change amount' do
      expect { vending_machine.give_change }.to change { vending_machine.available_coin_counts }.to(
        '1p' => 0,
        '2p' => 0,
        '5p' => 0,
        '10p' => 9,
        '20p' => 0,
        '50p' => 0,
        '£1' => 0,
        '£2' => 0
      )
    end

    context 'when there is not enough change' do
      let(:vending_machine) do
        VendingMachine.new(balance: 188, available_coin_counts: {
                             '1p' => 100,
                             '2p' => 0,
                             '5p' => 0,
                             '10p' => 0,
                             '20p' => 0,
                             '50p' => 0,
                             '£1' => 0,
                             '£2' => 10
                           })
      end

      it 'returns available change' do
        expect(vending_machine.give_change).to eq({
                                                    '1p' => 100
                                                  })
      end

      it 'partially reduces the balance by the change amount' do
        expect { vending_machine.give_change }.to change { vending_machine.balance }.from(188).to(88)
      end

      it 'reduces the available coin counts by the change amount' do
        expect { vending_machine.give_change }.to change { vending_machine.available_coin_counts }.to(
          '1p' => 0,
          '2p' => 0,
          '5p' => 0,
          '10p' => 0,
          '20p' => 0,
          '50p' => 0,
          '£1' => 0,
          '£2' => 10
        )
      end
    end
  end
end
