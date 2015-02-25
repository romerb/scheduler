require 'spec_helper'

describe Scheduler do
  let(:scheduler) { Scheduler.new }
  let(:workday) { [0]*8 + [1]*8 + [0]*8 }
  let(:preferences) { [0]*8 + [1]*8 + [0]*8 }

  xit 'has to have correct interface' do
    expect(scheduler).to respond_to(:schedule).with.no_arguments
  end

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
    let(:multi_days) do
      input[:schedule].merge!(tuesday: workday)
      input[:workers][:paul].merge!(tuesday: preferences)
      input
    end
    let(:schedule) { Scheduler.new(multi_days) }

    it 'returns correct ouput' do
      expect(schedule.run).to eq(paul: {monday: workday, tuesday: workday})
    end
  end

end
