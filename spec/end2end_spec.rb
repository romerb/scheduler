# 0 No
# 1 Si
# 2 Preferito

require 'minitest/autorun'
require_relative '../lib/parser'

class TestParser < Minitest::Test
  def setup
    @input = File.read(File.expand_path('spec/fixture.txt'))
  end


  def test_range_conversion_to_array
    day_range = "9 AM to 6 PM"
    day_array = Parser.convert_range_to_array(day_range)
    expected = [0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0]
    assert_equal expected, day_array

    day_range = "10 AM to 7 PM"
    day_array = Parser.convert_range_to_array(day_range)
    expected = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0]
    assert_equal expected, day_array

    day_range = "6 PM to 7 PM"
    day_array = Parser.convert_range_to_array(day_range)
    expected = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0]
    assert_equal expected, day_array

    day_range = "9 AM to 11 AM"
    day_array = Parser.convert_range_to_array(day_range)
    expected = [0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    assert_equal expected, day_array

    day_range = "9 AM to 12 PM"
    day_array = Parser.convert_range_to_array(day_range)
    expected = [0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    assert_equal expected, day_array
  end

  def test_end_2_end
    skip "lauch later"
    data = Parser.parse(@input)
    expected = {
      schedule: {
        wednesday: [0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0]
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
