require 'yaml'

class Parser
  def self.parse(input_file)
    input = YAML.load input_file
    {
      schedule: convert_days_range_to_array(input['Schedule'])
    }
  end

  def self.convert_days_worker_preferences_to_array(days_worker_preferences)
    {}.tap do |days_preferences|
      days_worker_preferences.each do |day, preference|
        days_preferences.merge!(convert_day_worker_preference_to_array(day => preference))
      end
    end
  end

  def self.convert_day_worker_preference_to_array(day_worker_preference)
    days = { 'Sun' => :sunday, 'Mon' => :monday, 'Tue' => :tuesday,
             'Wed' => :wednesday, 'Thu' => :thursday, 'Fri' => :friday,
             'Sat' => :saturday }

    day, range = Array(day_worker_preference).flatten

    { days[day] => convert_worker_preference_to_array(range) }
  end

  def self.convert_days_range_to_array(days_range)
    {}.tap do |days_ranges|
      days_range.each do |day, range|
        days_ranges.merge!(convert_day_range_to_array(day => range))
      end
    end
  end

  def self.convert_day_range_to_array(day_range)
    days = { 'Sun' => :sunday, 'Mon' => :monday, 'Tue' => :tuesday,
             'Wed' => :wednesday, 'Thu' => :thursday, 'Fri' => :friday,
             'Sat' => :saturday }

    day, range = Array(day_range).flatten

    { days[day] => convert_range_to_array(range) }
  end

  def self.convert_range_to_array(day_range)
    from_hour, from_meridian, to_hour, to_meridian = twelve_hours_notation_parts(day_range)
    from = twelve_to_twentyfour(from_hour.to_i, from_meridian)
    to = twelve_to_twentyfour(to_hour.to_i, to_meridian)

    return any if all_day_long?(from_hour.to_i, to_hour.to_i, from_meridian, to_meridian)

    working_hours(from, to)
  end

  def self.twelve_hours_notation_parts(day_range)
    from, to = day_range.split(' to ')
    from_hour, from_meridian = from.split(' ')
    to_hour, to_meridian = to.split(' ')
    [from_hour, from_meridian, to_hour, to_meridian]
  end

  def self.convert_worker_preference_to_array(worker_preference)
    return any if worker_preference == 'any'
    return none if worker_preference == 'not available'
    return convert_range_to_array(worker_preference) if range? worker_preference
    return preferred_working_hours(*get_ok_and_preferred(worker_preference)) if worker_preference =~ /prefers/

    before_or_after, hour, meridian = worker_preference.split(' ')
    from_or_to = twelve_to_twentyfour(hour.to_i, meridian)

    return working_hours(from_or_to) if before_or_after == 'after'
    working_hours(0, from_or_to)
  end

  def self.preferred_working_hours(is_ok, preferred)
    is_ok = convert_worker_preference_to_array(is_ok)
    preferred = convert_worker_preference_to_array(preferred).map { |x| 2 if x == 1 }
    preferred.each_with_index do |val, index|
      is_ok[index] = 2 if val == 2
    end
    is_ok
  end

  def self.get_ok_and_preferred(worker_preference)
    worker_preference.gsub('(', '').gsub(')', '').split('prefers').map(&:strip)
  end

  def self.range?(worker_preference)
    worker_preference =~ /^\d{1,2}\s(AM|PM)\sto\s\d{1,2}\s(AM|PM)/
  end

  def self.working_hours(from, to = 24)
    [].tap do |day|
      0.upto(from - 1) { day << 0 }
      from.upto(to - 1) { day << 1 }
      to.upto(23) { day << 0 }
    end
  end

  def self.any
    ([1] * 24).flatten
  end

  def self.none
    ([0] * 24).flatten
  end

  def self.twelve_to_twentyfour(hour, meridian)
    return 12 if hour == 12 && meridian == 'PM'
    return 0 if hour == 12 && meridian == 'AM'
    meridian == 'AM' ? hour : hour + 12
  end

  def self.all_day_long?(from, to, from_meridian, to_meridian)
    from == 12 && to == 12 && from_meridian == 'AM' && to_meridian == 'AM'
  end
end
