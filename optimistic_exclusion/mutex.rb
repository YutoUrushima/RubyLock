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
    @objects.times { |num| @threads_alias << "threads#{num}" }
  end

  def execute(version)
    shared_resource = SharedResources.new("resource", 0)
    mutex = Mutex.new
    Parallel.map(@threads_alias, in_threads: @object) do |object|
      puts "IS_LOCKING -> Object: #{object}, #{mutex.locked?}"
      mutex.synchronize do
        puts "IS_LOCKING -> Object: #{object}, #{mutex.locked?}"
        puts "INFO -> Object: #{object}, Now: #{Time.now.iso8601(6)}"
        raise "This is stale!" if shared_resource.is_stale?(version)
        shared_resource.increment_version

        shared_resource.is_changed = true
      end
      puts "IS_LOCKING -> Object: #{object}, #{mutex.locked?}"
    end
  end
end

# class OptimisticExclusionMutexs
#   def execute(text1, text2, lock_version)
#     mutex = Mutex.new
#     Parallel.map([text1, text2], in_threads: 2) do |element|
#       puts "PID: #{Process.pid}"
#       # DONE: Ensure that they are working in the same Process
#       mutex.synchronize do
#         puts "In synchronize"
#         puts "Locked?: element#{element} => #{mutex.locked?}"
#         puts "Now: element#{element} -> #{Time.now.iso8601(6)}"
#         puts "Lock Version: #{lock_version}"
#         object = Object.last
#         raise "This is stale" if lock_version != object.version
#         object.version += 1
#         object.text = element
#         object.save!
#       end
#       puts "Locked?: element#{element} => #{mutex.locked?}"
#     end
#   end

#   def check
#     object = object.last
#     puts "text: #{object.text}"
#     puts "lock_version: #{object.version}"
#   end

#   def insert
#     object = object.new(text: "new")
#     object.save!
#   end
# end
