require 'cache'

describe Cache do
  before do
    @cash = Cache.new
  end

  describe '#set' do
    it 'saves a value in the cache' do
      @cash.set 'hello', 'world'

      expect(@cash.cache['hello']).to eq 'world'
    end
  end

  describe '#get' do
    context 'when a key exists in cache' do
      it 'returns the value for that key' do
        @cash.set 'hi', 'mom'
        response = @cash.get 'hi'

        expect(response).to eq 'mom'
      end
    end

    context 'when a key does not exist in cache' do
      it 'returns nil' do
        response = @cash.get 'hi'

        expect(response).to eq nil
      end
    end
  end

  describe '#key?' do
    context 'when a key exists in cache' do
      it 'returns true' do
        @cash.set 'hi', 'mom'
        response = @cash.key? 'hi'

        expect(response).to eq true
      end
    end

    context 'when a key does not exist in cache' do
      it 'returns false' do
        response = @cash.key? 'hi'

        expect(response).to eq false
      end
    end
  end

  describe '#clear' do
    it 'clears the cache' do
      @cash.set 'hi', 'mom'
      @cash.clear

      expect(@cash.cache.empty?).to eq true
    end
  end
end
