require 'spec_helper'

def workday
  [0]*8 + [1]*8 + [0]*8
end



describe Scheduler do
  let(:scheduler) { Scheduler.new }

  let(:preferences) { [0]*8 + [1]*8 + [0]*8 }

  let(:input) do
    {
      schedule: {
        monday: workday
      },
      workers: {
        paul: {
          monday: preferences
        }
      }
    }
  end

  let(:multi_days) do
    input[:schedule].merge!(tuesday: workday)
    input[:workers][:paul].merge!(tuesday: preferences)
    input
  end

  let(:multi_workers) do
    multi_days[:workers].merge!(marc: {monday: preferences, tuesday: preferences})
    multi_days
  end

  describe "easiest" do
    let(:schedule) { Scheduler.new(input) }
    it 'returns correct output' do
      expect(schedule.run).to eq(paul: {monday: workday})
    end
  end

  describe "multiple days" do

    let(:schedule) { Scheduler.new(multi_days) }

    it 'returns correct output' do
      expect(schedule.run).to eq(paul: {monday: workday, tuesday: workday})
    end
  end

  describe "multiple days and workers" do
    let(:schedule) { Scheduler.new(multi_workers) }

    it 'returns correct ouput' do
      expect(schedule.run).to eq(paul: {monday: workday, tuesday: workday}, marc: {monday: [0]*24, tuesday: [0]*24})
    end
  end


end
