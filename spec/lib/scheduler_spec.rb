require 'spec_helper'

def workday
  [0]*8 + [1]*8 + [0]*8
end

def freeday
  [0]*24
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

  WEEK = [:monday, :tuesday, :wednesday, :thursday, :friday, :saturday, :sunday]

  def workweek(*days)
    WEEK.reduce({}) { |result, day| result[:day] = ( days.include?(day) ? workday : freeday )  }
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
      expect(schedule.run).to eq(paul: {monday: workday, tuesday: workday}, marc: {monday: freeday, tuesday: freeday})
    end
  end

  describe "different availability" do
    let (:alternating_days) do
      input[:schedule].merge!({tuesday: workday})
      input[:workers][:marc] = {monday: freeday, tuesday: workday}
      input[:workers][:paul][:tuesday]  = freeday
      input
    end
    let (:schedule) { Scheduler.new(alternating_days) }
    it "returns correct output" do
      expect(schedule.run).to eq(paul: {monday: workday, tuesday: freeday}, marc: {monday: freeday, tuesday: workday})
    end
  end

  context "with preference" do
    let (:crazy_days) do
      {
        schedule: {
          monday: [0]*5 + [1]*10 + [0]*9,
          friday: [0]*10 + [1]*8 + [0]*6,
          sunday: [0]*15 + [1]*3 + [0]*6
        },
        workers: {
          paul: {
            monday: [0]*12 + [2]*2 + [1]*6 + [0]*4,
            tuesday: freeday,
            wednesday: workday,
            friday: workday
          },
          alberto: {
            monday: [0]*4 + [1]*12 + [0]*8,
            sunday: freeday,
            friday: [0]*8 + [1]*12 + [0]*4
          },
          kuba: {
            sunday: [0]*12 + [2]*5 + [1]*3 + [0]*4
          }
        }
      }
    end
    let (:schedule) { Scheduler.new(crazy_days) }

    let (:expectation) do
      {
        paul:{
          monday: [0]*12 + [1]*3 + [0]*9,
          tuesday: freeday,
          wednesday: freeday,
          friday: freeday,
          sunday: freeday
        },
        alberto: {
          monday: [0]*5 + [1]*7 + [0]*12,
          friday: [0]*10 + [1]*8 + [0]*6,
          sunday: freeday
        },
        kuba: {
          monday: freeday,
          friday: freeday,
          sunday: [0]*15 + [1]*3 + [0]*6
        }
      }
    end

    it "returns correct output" do
      result = schedule.run
      expect(result[:paul]).to eq(expectation[:paul])
      expect(result[:alberto]).to eq(expectation[:alberto])
      expect(result[:kuba]).to eq(expectation[:kuba])
    end
  end

end
