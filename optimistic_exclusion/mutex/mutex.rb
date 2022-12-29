require "time"
require "bundler/inline"
require File.expand_path("../shared_resource", __FILE__)

gemfile do
  source "https://rubygems.org"
  gem "parallel"
end

class CacheMutexLock
  def initialize(objects)
    @objects = objects
    @threads_alias = []
    @objects.times { |num| @threads_alias << "threads#{num + 1}" }
  end

  def execute(version)
    shared_resource = SharedResources.new()
    mutex = Mutex.new
    Parallel.map(@threads_alias, in_processes: 1, in_threads: @object) do |object|
      mutex.synchronize do
        puts "INFO -> Object: #{object}, PID: #{Process.pid}, Now: #{Time.now.iso8601(6)}, Is Locked: #{mutex.locked?}, Lock Version: #{shared_resource.version}"
        raise "This is stale!" if shared_resource.is_stale?(version)
        shared_resource.increment_version

        shared_resource.changed_value = object
      end
      puts "IS_LOCKING -> Object: #{shared_resource.changed_value}, Value: #{shared_resource.changed_value}, Is Locked: #{mutex.locked?}"
    end
  end
end
