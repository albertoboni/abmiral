require "abmiral/version"

require 'abmiral/soldier'
require 'abmiral/battle_plan'
require 'abmiral/order'

require 'net/ssh'

module Abmiral

  def self.battle_plans(config)
    Array(config).map { |c| Abmiral::BattlePlan.new c[:name], c[:url], c[:date], c[:delay], c[:orders] }
  end


  def self.soldiers(config)
    Array(config).map { |c| Abmiral::Soldier.new(c[:name], c[:host], c[:user], c[:certificate], c[:hq]) }
  end


  def self.deploy_troops(config)
    # prepare the troops
    battle_plans = Abmiral.battle_plans config[:battle_plans]
    soldiers     = Abmiral.soldiers     config[:soldiers]

    # assign mission
    soldiers.map! { |soldier| soldier.add_battle_plans(battle_plans) }


    soldiers.each do |soldier|
      Net::SSH.start(soldier.host, soldier.user, :keys_only => true, :keys => [soldier.certificate]) do |ssh|

        # makes a dir for the deployment
        puts ssh.exec! "mkdir #{soldier.hq}"

        # make a backup of the crontab
        crontab_bkp_file = "#{soldier.hq}crontab-bkp"
        ssh.exec! "crontab -l > #{crontab_bkp_file}"

        # make a copy of the crontab and add the complete briefing
        deployment_file  = "#{soldier.hq}abmiral-deployment"
        puts ssh.exec! "cp #{crontab_bkp_file} #{deployment_file}"

        # add the deployment to the new file and install it
        soldier.brief_battle_plans.split("\n").each do |line|
          ssh.exec! "echo #{line} >> #{deployment_file}"
        end

        # add the crontab
        puts ssh.exec! "crontab #{deployment_file}"

      end
    end
  end


end
