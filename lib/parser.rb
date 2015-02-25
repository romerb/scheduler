require 'yaml'

class Parser
  def self.parse input_file
    input = YAML.load input_file
    {
      schedule: convert_days_range_to_array(input["Schedule"])
    }
  end

  def self.convert_days_range_to_array(days_range)
    {}.tap do |days_ranges|
      days_range.each do |day, range|
        days_ranges.merge!(convert_day_range_to_array(day => range))
      end
    end
  end

  def self.convert_day_range_to_array day_range
    days = { "Sun" => :sunday, "Mon" => :monday, "Tue" => :tuesday,
             "Wed" => :wednesday, "Thu" => :thursday, "Fri" => :friday,
             "Sat" => :saturday }

    day, range = Array(day_range).flatten

    { days[day] => convert_range_to_array(range) }
  end

  def self.convert_range_to_array(day_range)
    from, to = day_range.split(' to ')
    from_hour, from_meridian = from.split(' ')
    to_hour, to_meridian = to.split(' ')

    from = twelve_to_twentyfour(from_hour.to_i, from_meridian)
    to = twelve_to_twentyfour(to_hour.to_i, to_meridian)

    return ([1] * 24).flatten if all_day_long?(from_hour.to_i, to_hour.to_i, from_meridian, to_meridian)

    day = []
    0.upto(from - 1) { |n| day << 0 }
    from.upto(to - 1) { |n| day << 1 }
    to.upto(23) { |n| day << 0 }

    day
  end

  private

  def self.twelve_to_twentyfour(hour, meridian)
    return 12 if hour == 12 && meridian == "PM"
    return 0 if hour == 12 && meridian == "AM"
    meridian == "AM" ? hour : hour + 12
  end

  def self.all_day_long?(from, to, from_meridian, to_meridian)
    from == 12 && to == 12 && from_meridian == "AM" && to_meridian == "AM"
  end
end
