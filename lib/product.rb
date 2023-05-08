# frozen_string_literal: true

class Product
  def initialize(price)
    @price = price
  end

  attr_reader :price
end
