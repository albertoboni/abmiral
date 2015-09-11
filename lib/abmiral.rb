require "abmiral/version"

require 'abmiral/soldier'
require 'abmiral/battle_plan'
require 'abmiral/order'

module Abmiral

  def self.battle_plans(config)
    Array(config).map do |c|

      Abmiral::BattlePlan.new do
        self.name    = c[:name]
        self.url     = c[:url]
        self.date    = c[:date]
        self.delay   = c[:delay]
        self.orders  = c[:orders]
      end

    end
  end

  def self.soldiers(config, battlefields)
    Array(config).map do |c|
      Abmiral::Soldier.new do
        self.name         = c[:name]
        self.host         = c[:host]
        self.battle_plans = battlefields
        self.certificate  = c[:certificate]
      end
    end
  end



  #
  # class Benchmark
  #
  #   attr_accessor :soldiers
  #
  #   attr_reader :battlefields
  #
  #   def initialize(&block)
  #     self.instance_eval &block
  #   end
  #
  #
  #
  #   def schedule_attack(soldiers)
  #
  #     config = YAML::load File.expand_path '../config/config.yaml', __dir__
  #
  #     #   Load the config
  #     #   Load the soldiers
  #     #   Load the battlefields
  #     #   Assign the battlefields for each soldier
  #     #   Schedule the attack
  #     #
  #     #   Backup the cron
  #     #   Install the cron
  #     #   - Check for previous Abmiral entries and updates on the cron
  #     #   - Create one entry for each yaml entry
  #     #   - Create one entry to compile the data
  #     #
  #   end
  #
  #
  #
  #   private
  #
  #
  #
  # end

end
