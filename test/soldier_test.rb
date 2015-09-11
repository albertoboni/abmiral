require 'test/unit'
require 'abmiral/soldier'
require 'abmiral/battle_plan'
require 'abmiral/order'

class MyTest < Test::Unit::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    # Do nothing
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
    # Do nothing
  end



  def test_new
    soldier = Abmiral::Soldier.new 'server1', '192.168.1.0', 'path/to/cert.pem'

    assert_equal 'server1',               soldier.name
    assert_equal '192.168.1.0',           soldier.host
    assert_equal 'path/to/cert.pem',      soldier.certificate
  end


  def test_add_battle_plans
    soldier     = Abmiral::Soldier.new 'server1', '192.168.1.0', 'path/to/cert.pem'
    battle_plan = Abmiral::BattlePlan.new 'test1', 'http://www.google.com/', '2015-06-14 10:10', 5

    soldier.add_battle_plan battle_plan
    soldier.add_battle_plan battle_plan

    assert_equal 2,         soldier.battle_plans.length

    out, err = capture_io { soldier.add_battle_plan 'error' }

    assert !err.empty?
    assert_equal 2,         soldier.battle_plans.length
  end

  def test_brief_battle_plans
    soldier     = Abmiral::Soldier.new 'server1', '192.168.1.0', 'path/to/cert.pem'

    # A simple battle plan
    battle_plan = Abmiral::BattlePlan.new 'test1', 'http://www.google.com/', '2015-06-14 10:10', 5
    battle_plan.add_order 10000, 100
    battle_plan.add_order 10000, 50
    battle_plan.add_order 10000, 10

    # add to the soldier
    soldier.add_battle_plan battle_plan

    # Another battle plan with orders
    battle_plan = Abmiral::BattlePlan.new 'test2', 'http://www.google.com/', '2015-06-14 10:40', 5
    battle_plan.add_order 10000, 100
    battle_plan.add_order 10000, 50
    battle_plan.add_order 10000, 10

    # add to the soldier
    soldier.add_battle_plan battle_plan

    briefing = "
#### ABMIRAL BATTLE PLAN test1
10 10 14 6 0 ab -r -e test1.10000-100.csv -n 10000 -c 100 http://www.google.com/
15 10 14 6 0 ab -r -e test1.10000-50.csv -n 10000 -c 50 http://www.google.com/
20 10 14 6 0 ab -r -e test1.10000-10.csv -n 10000 -c 10 http://www.google.com/
#### ABMIRAL BATTLE PLAN END

#### ABMIRAL BATTLE PLAN test2
40 10 14 6 0 ab -r -e test2.10000-100.csv -n 10000 -c 100 http://www.google.com/
45 10 14 6 0 ab -r -e test2.10000-50.csv -n 10000 -c 50 http://www.google.com/
50 10 14 6 0 ab -r -e test2.10000-10.csv -n 10000 -c 10 http://www.google.com/
#### ABMIRAL BATTLE PLAN END"

    assert_equal briefing.squeeze(' '), soldier.brief_battle_plans.squeeze(' ')

  end
end