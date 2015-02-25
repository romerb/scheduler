class Parser
  def self.parse input_file
    {}
  end

  def self.convert_range_to_array(day_range)
    from, to = day_range.split(' to ')
    from_hour, from_meridian = from.split(' ')
    to_hour, to_meridian = to.split(' ')

    from = from_hour.to_i
    to = to_hour.to_i + 12

    day = []
    0.upto(from - 1) { |n| day << 0 }
    from.upto(to) { |n| day << 1 }
    (to + 1).upto(23) { |n| day << 0 }

    day
  end
end
