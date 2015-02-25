class Parser
  def self.parse input_file
    {}
  end

  def self.convert_range_to_array(day_range)
    from, to = day_range.split(' to ')
    from_hour, from_meridian = from.split(' ')
    to_hour, to_meridian = to.split(' ')

    from = twelve_to_twentyfour(from_hour, from_meridian)
    to = twelve_to_twentyfour(to_hour, to_meridian)

    day = []
    0.upto(from - 1) { |n| day << 0 }
    from.upto(to - 1) { |n| day << 1 }
    to.upto(23) { |n| day << 0 }

    day
  end

  private

  def self.twelve_to_twentyfour(hour, meridian)
    meridian == "AM" ? hour.to_i : hour.to_i + 12
  end
end
