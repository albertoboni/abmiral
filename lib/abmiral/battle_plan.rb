require 'abmiral/order'


module Abmiral

  # Each BattlePlan is a group of orders, with a time to start targeting a single url, and a delay
  # between each order to start.
  class BattlePlan

    attr_reader   :name, :url, :date, :delay, :orders, :hq


    # @param [String] name        The test name
    # @param [String] url         The url to be requested
    # @param [String] date        The DateTime to run the test on
    # @param [Fixnum] delay       The delay in minutes between each order
    # @param [String] orders      The number of concurrent requests to be made
    def initialize(name, url, date, delay, orders_config = [])
      date = Time.parse(date) unless date.is_a? Time

      @name   = name
      @url    = url
      @date   = date
      @delay  = delay
      @orders = []

      self.add_orders(orders_config)
    end


    # Shortcut to add_orders from the config
    #
    # @param [Array] orders   Array o hashes with the format {:requests => Fixnum, :concurrency => Fixnum }
    # @return [Array]
    def add_orders(orders)
      orders.each { |c| add_order c[:requests], c[:concurrency], @hq }
      @orders
    end


    # Instantiates each order and stores in @orders
    #
    # @param [Fixnum] requests    The total of requests to be made
    # @param [Fixnum] concurrency The number of concurrent requests to be made
    #
    # @return [Array]
    def add_order(requests, concurrency, hq)
      order_delayed_date = date + (delay * @orders.length * 60)

      @orders << Abmiral::Order.new(name, url, order_delayed_date, requests, concurrency, hq)
    end


    # The setter for the operations hq
    #
    # @param [String] hq
    def hq=(hq)
      @hq = hq
      @orders.map! do |order|
        order.hq = @hq
        order
      end
    end


    # Returns the complete crontab insertion for all orders for this battle plan
    #
    # @return [String]
    def complete_briefing
      output  = "\n"
      output << "#### ABMIRAL BATTLE PLAN #{name}\n"
      output << self.orders.map { |order| order.briefing }.join("\n") + "\n"
      output << "#### ABMIRAL BATTLE PLAN END"
      output
    end


  end
end