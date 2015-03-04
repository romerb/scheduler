require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/parser'

class TestParser < Minitest::Test
  def setup
    @input = File.read(File.expand_path('spec/fixture.txt'))
  end

  def test_days_range_conversion
    days_range = {
      "Mon" => "9 AM to 6 PM",
      "Sat" => "6 PM to 7 PM"
    }

    expected = { monday: [0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0],
                 saturday:    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0]}
    days_array = Parser.convert_days_range_to_array(days_range)
    assert_equal expected, days_array
  end

  def test_day_range_conversion
    day_range = { "Wed" => "9 AM to 6 PM" }
    expected = { wednesday: [0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0] }
    day_array = Parser.convert_day_range_to_array(day_range)
    assert_equal expected, day_array

    day_range = { "Fri" => "9 AM to 6 PM" }
    expected = { friday: [0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0] }
    day_array = Parser.convert_day_range_to_array(day_range)
    assert_equal expected, day_array
  end

  def test_day_worker_preference_conversion
    day_worker_preference = { "Wed" => "any" }
    expected = { wednesday: [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1] }
    day_array = Parser.convert_day_worker_preference_to_array(day_worker_preference)
    assert_equal expected, day_array
  end

  def test_days_worker_preferences_conversion
    days_range = {
      "Mon" => "any",
      "Sat" => "not available"
    }

    expected = { monday: [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
                 saturday:    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]}
    days_array = Parser.convert_days_worker_preferences_to_array(days_range)
    assert_equal expected, days_array
  end

  def test_worker_preference_conversion_to_array
    worker_day_preference = "any"
    expected = ([1] * 24).flatten
    worker_day = Parser.convert_worker_preference_to_array(worker_day_preference)
    assert_equal expected, worker_day

    worker_day_preference = "not available"
    expected = ([0] * 24).flatten
    worker_day = Parser.convert_worker_preference_to_array(worker_day_preference)
    assert_equal expected, worker_day

    worker_day_preference = "after 1 PM"
    expected = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
    worker_day = Parser.convert_worker_preference_to_array(worker_day_preference)
    assert_equal expected, worker_day

    worker_day_preference = "before 2 PM"
    expected = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    worker_day = Parser.convert_worker_preference_to_array(worker_day_preference)
    assert_equal expected, worker_day

    worker_day_preference = "6 PM to 7 PM"
    expected = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0]
    worker_day = Parser.convert_worker_preference_to_array(worker_day_preference)
    assert_equal expected, worker_day

    worker_day_preference = "any (prefers before 5 PM)"
    expected = [2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1]
    worker_day = Parser.convert_worker_preference_to_array(worker_day_preference)
    assert_equal expected, worker_day

    worker_day_preference = "any (prefers before 6 PM)"
    expected = [2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 1, 1, 1, 1, 1]
    worker_day = Parser.convert_worker_preference_to_array(worker_day_preference)
    assert_equal expected, worker_day

    worker_day_preference = "before 6 PM (prefers before 12 PM)"
    expected = [2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0]
    worker_day = Parser.convert_worker_preference_to_array(worker_day_preference)
    assert_equal expected, worker_day

    worker_day_preference = "any (prefers 8 AM to 6 PM)"
    expected = [1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 1, 1, 1, 1, 1]
    worker_day = Parser.convert_worker_preference_to_array(worker_day_preference)
    assert_equal expected, worker_day
  end

  def test_range_conversion_to_array
    day_range = "9 AM to 6 PM"
    day_array = Parser.convert_range_to_array(day_range)
    expected = [0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0]
    assert_equal expected, day_array

    day_range = "6 PM to 7 PM"
    day_array = Parser.convert_range_to_array(day_range)
    expected = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0]
    assert_equal expected, day_array

    day_range = "9 AM to 11 AM"
    day_array = Parser.convert_range_to_array(day_range)
    expected = [0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    assert_equal expected, day_array

    day_range = "12 AM to 12 PM"
    day_array = Parser.convert_range_to_array(day_range)
    expected = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    assert_equal expected, day_array

    day_range = "12 AM to 12 AM"
    day_array = Parser.convert_range_to_array(day_range)
    expected = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
    assert_equal expected, day_array
  end

  def test_end_2_end
    data = Parser.parse(@input)
    expected = {
      schedule: {
        wednesday: [0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0]
      },
      workers: {
        James: {
          wednesday: [2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0]
        }
      }
    }
    assert_equal expected, data
  end
end
