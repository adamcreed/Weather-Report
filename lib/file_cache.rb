require 'json'
require_relative 'cache'

class FileCache < Cache
  def initialize(cache_file)
    super()

    @cache_file = cache_file
  end

  def set(key, value)
    read_or_create_file

    super

    file_cache = File.open @cache_file, 'w'
    file_cache.write @cache.to_json
    file_cache.flush
  end

  def get(key)
    the_thing = super

    return the_thing unless the_thing.nil?

    read_or_create_file
    read_cached_file

    super
  end

  def key?(key)
    the_thing = super

    return the_thing unless the_thing == false

    read_or_create_file
    read_cached_file

    super
  end

  def clear
    super

    File.open @cache_file, 'w'
  end

  def read_cached_file
    unless file_is_empty?
      @cache = JSON.parse(File.read(@cache_file))
    end
  end

  def file_is_empty?
    File.read(@cache_file).empty?
  end

  def read_or_create_file
    if File.exists?(@cache_file)
      read_cached_file
    else
      File.open @cache_file, 'w'
    end
  end
end
