require 'redis_handler'
require 'mock_redis'

RSpec.describe RedisHandler do
  before do  
    allow(Redis).to receive(:new).and_return(MockRedis.new) 
    described_class.new.push(50)
    described_class.new.push(60)
  end
  
  describe '#all_runs' do 
    it 'returns all the previous scores' do
      expect(described_class.new.all_runs).to eq(["50", "60"])
    end
  end

  describe '#delete_all_keys' do 
    it 'deletes all information' do
      described_class.new.delete_all_keys

      expect(Redis.new.keys.length).to eq(0)
    end
  end
end