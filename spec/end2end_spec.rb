# 0 No
# 1 Si
# 2 Preferito

require 'minitest/autorun'
require_relative '../lib/parser'

class TestParser < Minitest::Test
  def setup
    @input = File.read(File.expand_path('spec/fixture.txt'))
  end

  def test_end_2_end
    data = Parser.parse(@input)
    expected = {
      days: {
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
