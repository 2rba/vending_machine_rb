# frozen_string_literal: true
require 'product.rb'

class VendingMachine
  COIN_VALUE = {
    '1p' => 1,
    '2p' => 2,
    '5p' => 5,
    '10p' => 10,
    '20p' => 20,
    '50p' => 50,
    '£1' => 100,
    '£2' => 200
  }.freeze
  VALUE_TO_COIN = COIN_VALUE.invert

  attr_reader :balance, :available_coin_counts

  def initialize(balance: 0, available_coin_counts: {})
    @balance = balance
    @available_coin_counts = COIN_VALUE.keys.to_h { |coin| [coin, 0] }.merge(available_coin_counts)
  end

  def accept_coin(coin)
    raise 'Invalid coin' unless COIN_VALUE.key?(coin)

    @balance += COIN_VALUE[coin]
    @available_coin_counts[coin] += 1
  end

  def request_product(product)
    return false if @balance < product.price

    @balance -= product.price
    true
  end

  def give_change
    COIN_VALUE.values.reverse.filter_map do |coin_value|
      next if coin_value > @balance

      coin = VALUE_TO_COIN.fetch(coin_value)
      next if @available_coin_counts[coin] <= 0

      coins_count = [@balance / coin_value, @available_coin_counts[coin]].min

      @balance -= coins_count * coin_value
      @available_coin_counts[coin] -= coins_count
      [coin, coins_count]
    end.to_h
  end
end
