require 'questionnaire'
require 'stringio'

RSpec.describe Questionnaire do  
  describe '#prompt' do 
    it 'starts the questionnaire' do
      allow($stdin).to receive(:gets) { 'Yes' }
      expect(described_class).to receive(:run)

      described_class.prompt
    end

    it 'initiates a fresh run' do 
      allow($stdin).to receive(:gets) { 'Fresh start' }
      expect(described_class).to receive(:fresh_run)

      described_class.prompt
    end

    it 'exits the program' do 
      allow($stdin).to receive(:gets) { 'No' }

      output = <<~OUTPUT
        Do you wish to run the questionnaire? [Yes/Fresh start/No]
        Goodbye
      OUTPUT

      expect { described_class.prompt }.to output(output).to_stdout
    end
  end

  describe '#run' do     
    let(:inputs) { ['Yes', 'Yes', 'No', 'Yes', 'No'] }
    let(:all_runs) { ["30", "50", "60"] }
    let(:redis_double) { double(RedisHandler, all_runs: all_runs, push: ["60"]) }
    
    before do 
      $stdin = StringIO.new(inputs.join("\n") + "\n") 
      allow(described_class).to receive(:redis).and_return(redis_double)
    end

    it 'calculates the current score' do 
      expect(described_class).to receive(:rating_for_current_run).with(inputs)
      described_class.run
    end

    it 'calculates the average score' do
      expect(described_class).to receive(:get_average_rating)
      described_class.run
    end

    it 'returns the correct scores' do 
      expected_output = <<~OUTPUT
        Can you code in Ruby?
        Can you code in Javascript?
        Can you code in Swift (iOS)?
        Can you code in Java (Android)?
        Can you code in C#?
        Rating for current run is 60.0/100
        Rating for all runs is 46.67/100
      OUTPUT

      expect { described_class.run }.to output(expected_output).to_stdout
    end
    
    after { $stdin = STDIN }
  end

  describe '#get_average_rating' do
    let(:redis_double) { double(RedisHandler, all_runs: all_runs) }
    
    before do 
      allow(described_class).to receive(:redis).and_return(redis_double)
    end

    context 'when only one test has been run' do 
      let(:all_runs) { ["60"] }

      it 'returns the same number' do 
        expect(described_class.get_average_rating).to be(60.0)
      end
    end

    context 'when the user runs the test multiple times' do 
      let(:all_runs) {  ["20", "80", "60"] }

      it 'returns the correct average score' do 
        expect(described_class.get_average_rating).to be(53.33)
      end
    end
  end
end
