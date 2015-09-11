require 'abmiral/battle_plan'

module Abmiral

  # Each soldier is a representation of a server instance to receive a battle plan, with multiple orders.
  # Each battle plan is essentially a cronjob with multiple entries to run with a certain delay time
  class Soldier

    attr_reader :name, :host, :certificate, :battle_plans

    # Initializes
    def initialize(name, host, certificate)
      @name         = name
      @host         = host
      @certificate  = certificate
      @battle_plans = []
    end


    # Shortcut to call self#add_battle_plan
    #
    # @param [Array] battle_plans   An array of Abmiral::BattlePlan instances
    # @return [self]
    def add_battle_plans(battle_plans)
      battle_plans.each { |b| add_battle_plan(b) }
      self
    end


    # Adds the battle plans and validate
    #
    # @param [Abmiral::BattlePlan]  battle_plan
    #
    # @return [Array]
    def add_battle_plan(battle_plan)
      if battle_plan.is_a? Abmiral::BattlePlan
        @battle_plans << battle_plan
      else
        warn 'Sir, invalid battle plan sir!'
      end
    end


    # Fetches all cron entries for every battle plan
    #
    # @return [String]
    def brief_battle_plans
      @battle_plans.map { |battle_plan| battle_plan.complete_briefing }.join("\n")
    end


    def deploy

    end




  end
end