require 'abmiral/order'


module Abmiral

  # Each BattlePlan is a group of orders, with a time to start targeting a single url, and a delay
  # between each order to start.
  class BattlePlan

    attr_reader :name, :url, :date, :delay, :orders


    # @param [String] name        The test name
    # @param [String] url         The url to be requested
    # @param [String] date        The DateTime to run the test on
    # @param [Fixnum] delay       The delay in minutes between each order
    # @param [String] orders      The number of concurrent requests to be made
    def initialize(name, url, date, delay, orders_config = [])
      date = Time.parse(date) unless date.is_a? Time

      @name  = name
      @url   = url
      @date  = date
      @delay = delay

      Array(orders_config).each { |c| add_order(c[:requests], c[:concurrency]) }
    end


    # Instantiates each order and stores in @orders
    #
    # @param [String] requests    The total of requests to be made
    # @param [String] concurrency The number of concurrent requests to be made
    #
    # @return [Array]
    def add_order(requests, concurrency)
      @orders     ||= []
      order_delayed_date = date + (delay * @orders.length * 60)

      @orders << Abmiral::Order.new(name, url, order_delayed_date, requests, concurrency)
    end



  end
end