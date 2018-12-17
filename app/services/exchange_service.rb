class ExchangeService < ApplicationService

  class InvalidExchange < StandardError; end

  def initialize(atm, amount)
    @atm = atm
    @amount = amount
  end

  def call
    change = exchange
    available_change = change.inject(0){|sum, h| sum + h[0].to_i * h[1]}
    raise InvalidExchange.new("There is no possible exchange. Try another amount.") if available_change < @amount
    @atm.dispenser.merge!(change){|key, oldval, newval| oldval - newval}
    @atm.save
    change
  end

  private

  def exchange
    dispenser = @atm.dispenser.map{|k,v| [k.to_i ,v]}.sort.reverse
    amount = @amount
    dispenser.map do |bill, quantity|
      change_quantity = [quantity, amount / bill].min
      next if amount == 0 || change_quantity == 0
      amount -= bill * change_quantity
      [bill.to_s, change_quantity]
    end.compact.to_h
  end

end
