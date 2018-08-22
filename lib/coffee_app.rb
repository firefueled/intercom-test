require "json"

class CoffeeApp
  def initialize(prices, orders, payments)
    # parse json
    begin
      json_prices = JSON.parse prices
      json_orders = JSON.parse orders
      json_payments = JSON.parse payments
    rescue
      raise ArgumentError.new("Bad JSON data")
    end

    # no way to calculate without prices
    raise ArgumentError.new("No prices") if json_prices.length.zero?

    # no point in proceeding without orders and payments
    if [json_orders.length, json_payments.length].all? &:zero?
      raise ArgumentError.new("No orders and no payments. why bother? it's zero")
    end

    # indexes prices by drink name
    @drink_prices = indexData json_prices, "drink_name", false

    # indexes orders by user
    @user_orders = indexData json_orders

    # indexes payments by user
    @user_payments = indexData json_payments

    # users list
    @users = @user_orders.keys + @user_payments.keys
    @users.uniq!
  end

  def calculate
    total_payed = get_total_payed
    total_spent = get_total_spent

    result = @users.map do |user|
      order_total = (total_spent[user] || 0).round 2
      payment_total = (total_payed[user] || 0).round 2
      balance = order_total - payment_total
      balance = 0 if balance < 0
      balance = balance.round 2
      {
        "user": user,
        "order_total": order_total,
        "payment_total": payment_total,
        "balance": balance
      }
    end

    result.to_json
  end

  private

  # obtain the total payed by each user
  def get_total_payed
    payed = {}
    @user_payments.each do |user, payments|
      payed[user] = payments.reduce(0) do |sum, x|
        amount = x["amount"]
        amount = 0 if amount < 0
        sum + amount
      end
    end
    payed
  end

  # obtain the total spent by each user
  def get_total_spent
    costs = {}

    @user_orders.each do |user, orders|
      user_cost = 0
      orders.each do |order|
        # it's possible for drinks and sizes to not exist in the database
        drink = @drink_prices[order["drink"]]
        next unless drink

        size_price = drink["prices"][order["size"]]
        next unless size_price

        user_cost += size_price if size_price > 0
      end
      costs[user] = user_cost
    end
    costs
  end

  # indexes data by a prop value
  # is_accumulator defines whether each key corresponds to an array of values or not
  # there may be a way to use reduce for both cases?
  def indexData data, key_accessor = "user", is_accumulator = true
    indexed_data = {}
    data.each do |datum|
      key = datum[key_accessor]
      indexed_data[key] = [] unless indexed_data.has_key? key

      other_data = {}
      other_keys = datum.keys - [key_accessor]
      other_keys.each { |o| other_data[o] = datum[o] }

      if is_accumulator
        indexed_data[key].push(other_data)
      else
        indexed_data[key] = other_data
      end
    end
    indexed_data
  end
end
