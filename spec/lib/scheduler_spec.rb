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

  describe "easiest" do
    it 'returns correct output' do
      s = Scheduler.new(input)
      expect(s.run).to eq(paul: {monday: workday})
    end
  end
end
