require "abmiral/version"

require 'abmiral/soldier'
require 'abmiral/battle_plan'
require 'abmiral/order'

module Abmiral

  def self.battle_plans(config)
    Array(config).map { |c| Abmiral::BattlePlan.new c[:name], c[:url], c[:date], c[:delay], c[:orders] }
  end

  def self.soldiers(config)
    Array(config).map { |c| Abmiral::Soldier.new(c[:name], c[:host], c[:certificate]) }
  end


  # def


end
