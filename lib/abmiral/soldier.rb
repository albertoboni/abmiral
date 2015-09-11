module Abmiral
  class Soldier

    attr_accessor :name, :host, :certificate, :battle_plans

    def initialize(&block)
      self.instance_eval &block
    end


    def get_attack
      attacks = []
      attacks << {}

    end

  end
end