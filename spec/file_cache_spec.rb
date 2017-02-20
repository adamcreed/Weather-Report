require 'byebug'
require 'file_cache'

describe FileCache do
  before do
    File.delete 'cache.txt' if File.exists? 'cache.txt'
    @cash = FileCache.new 'cache.txt'
  end

  describe '#set' do
    context 'when a key is not in the hash' do
      it 'saves a value to the file cache' do
        @cash.set 'hello', 'world'
        file = JSON.parse(File.read('cache.txt'))
        expect(file).to eq({"hello" => "world"})
      end
    end

    context 'when a key is in the hash' do
      it 'overwrtes the existing value in the file cache' do
        @cash.set 'hello', 'world'
        @cash.set 'hello', 'mother'
        file = JSON.parse(File.read('cache.txt'))
        expect(file).to eq({"hello" => "mother"})
      end
    end

    context 'when setting multiple values' do
      it 'saves all values to the file cache' do
        @cash.set 'hello', 'world'
        @cash.set 'hi', 'friend'
        @cash.set 'ahoy', 'matey'
        file = JSON.parse(File.read('cache.txt'))
        expect(file).to eq({"hello" => "world", "hi" => "friend", "ahoy" => "matey"})
      end
    end
  end

  describe '#get' do
    context 'when a key exists in cache' do
      it 'returns the value from memory' do
        @cash.set 'hi', 'mom'

        response = @cash.get 'hi'

        expect(response).to eq 'mom'
      end
    end

    context 'when a key exists in the file cache' do
      it 'returns the value from file' do
        test_hash = {'hey' => 'everyone'}
        file_cache = File.open 'cache.txt', 'w'
        file_cache.write test_hash.to_json
        file_cache.flush

        response = @cash.get 'hey'

        expect(response).to eq 'everyone'
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

    context 'when a key exists in the file cache' do
      it 'returns true' do
        test_hash = {'hey' => 'everyone'}
        file_cache = File.open 'cache.txt', 'w'
        file_cache.write test_hash.to_json
        file_cache.flush

        response = @cash.key? 'hey'

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
      expect(File.read('cache.txt').empty?).to eq true
    end
  end
end
