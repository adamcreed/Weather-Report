class MemoryCache
  attr_reader :cache
  def initialize
    @cache = {}
  end

  def set(key, value)
    @cache[key] = value
  end

  def get(key)
    @cache[key]
  end

  def key?(key)
    @cache.key? key
  end

  def clear
    @cache.clear
  end
end
