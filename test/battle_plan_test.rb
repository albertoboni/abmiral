require 'test/unit'
require 'yaml'
require 'abmiral/battle_plan'

class BattlePlanTest < Test::Unit::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    @config_test1 = YAML.load_file File.expand_path('fixtures/test1.yaml', __dir__)

    # Do nothing
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
    # Do nothing
  end

  # Fake test
  def test_new

    orders = [{:requests=>1000, :concurrency=>100},
              {:requests=>1000, :concurrency=>200},
              {:requests=>1000, :concurrency=>300}]

    battle_plan = Abmiral::BattlePlan.new 'test1', 'http://www.google.com/', '2015-06-14 10:10', 5, orders

    assert_equal 'test1',                     battle_plan.name
    assert_equal 'http://www.google.com/',    battle_plan.url
    assert_equal '2015-06-14 10:10',          battle_plan.date.strftime('%F %R')
    assert_equal 5,                           battle_plan.delay
    assert_equal 3,                           battle_plan.orders.length
    assert_equal 'Abmiral::Order',            battle_plan.orders.first.class.name
  end


  def test_add_order
    battle_plan = Abmiral::BattlePlan.new 'test1', 'http://www.google.com/', '2015-06-14 10:10', 5

    battle_plan.add_order 10000, 100
    battle_plan.add_order 10000, 50
    battle_plan.add_order 10000, 10

    assert_equal '2015-06-14 10:10',          battle_plan.orders[0].date.strftime('%F %R')
    assert_equal '2015-06-14 10:15',          battle_plan.orders[1].date.strftime('%F %R')
    assert_equal '2015-06-14 10:20',          battle_plan.orders[2].date.strftime('%F %R')
  end

end