class Worker
  attr_accessor :preferences, :name
  def initialize name, preferences
    self.name = name
    self.preferences = preferences
  end

  def preference_by_day day, schedule
    preferences[day].zip(schedule).map{ |arr| arr[0]&arr[1] }
  end
end

class Scheduler
  attr_accessor :schedule, :workers

  def initialize input
    self.schedule = input[:schedule]
    self.workers  = input[:workers]
  end

  def run
    hash = {worker.name => {}}
    schedule.each do |day, preference|
      hash[worker.name][day] = worker.preference_by_day day, schedule[day]
    end
    hash
  end

  def worker
    name = workers.keys.first
    @worker ||= Worker.new(name, workers[name])
  end

end
