module Abmiral

  # Each BattlePlan is a group of orders, with a time to start targeting a single url, and a delay
  # between each order to start.
  #
  class BattlePlans

    attr_accessor :name, :url, :orders, :date, :delay

    def initialize(&block)
      self.instance_eval &block
    end

    def process_orders(config)
      self.orders = Array(config).map do |c|

        Abmiral::Orders.new do
          self.requests     = c[:requests]
          self.concurrency  = c[:concurrency]
        end
      end
    end

    def orders



    end


  end
end