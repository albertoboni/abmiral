module Abmiral
  class Orders

    attr_accessor :requests, :concurrency

    def initialize(&block)
      self.instance_eval &block
    end

  end
end