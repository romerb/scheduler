require "pry"
class Worker
  attr_accessor :preferences, :name
  def initialize name, preferences
    self.name = name
    self.preferences = preferences
  end

  def preference_by_day day, schedule
    (preferences[day] || []).zip(schedule).map{ |arr| arr[0].to_i == 2 && arr[1].to_i == 1 ? 1 : 0 }
  end

  def work_by_day day, schedule
    (preferences[day] || []).zip(schedule).map{ |arr| arr[0].to_i & arr[1].to_i }
  end
end

class Scheduler
  attr_accessor :schedule, :workers

  def initialize input
    self.schedule = input[:schedule]
    self.workers  = input[:workers].map do |name, preferences|
      Worker.new(name, preferences)
    end
  end

  def run
    hash = {}
    workers.each do |worker|
      hash[worker.name] = schedule_worker(worker)
    end
    hash
  end

  def schedule_worker worker
    personal_schedule = {}
    schedule.each do |day, preference|
      day_preference = worker.preference_by_day day, preference
      schedule[day].each_with_index do |val, n|
        schedule[day][n] -= day_preference[n].to_i
      end

      day_schedule = worker.work_by_day day, preference

      schedule[day].each_with_index do |val, n|
        schedule[day][n] -= day_schedule[n].to_i
      end

      personal_schedule[day] = day_schedule.zip(day_preference).map{ |arr| arr[0].to_i | arr[1].to_i }
    end
    Hash[personal_schedule.reject {|k,v| v.empty? || v.inject(&:+) == 0 }]
  end
end
