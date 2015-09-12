require 'test/unit'
require 'abmiral/order'

class OrderTest < Test::Unit::TestCase

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

    order = Abmiral::Order.new 'attack_name', 'http://www.google.com/', '2015-06-14 10:50', 1000, 50, '/folder/'

    assert_equal 'attack_name',               order.name
    assert_equal 'http://www.google.com/',    order.url
    assert_equal '2015-06-14 10:50',          order.date.strftime('%F %R')
    assert_equal 1000,                        order.requests
    assert_equal 50,                          order.concurrency
    assert_equal '/folder/',                  order.hq

    assert_equal '/folder/attack_name.1000-50.csv',
                 order.export_file_name
    assert_equal 'ab -r -e /folder/attack_name.1000-50.csv -n 1000 -c 50 http://www.google.com/',
                 order.ab_command
    assert_equal '50 10 14 6 0 ab -r -e /folder/attack_name.1000-50.csv -n 1000 -c 50 http://www.google.com/',
                 order.briefing.squeeze(' ')
  end

  def test_hq=
    order = Abmiral::Order.new 'attack_name', 'http://www.google.com/', '2015-06-14 10:50', 1000, 50, '/folder'
    assert_equal '/folder/', order.hq

    order.hq = '/folder/'
    assert_equal '/folder/', order.hq

    order.hq = '/folder'
    assert_equal '/folder/', order.hq
  end

end