require "time"

class OptimisticExclusionMutexs
  def execute(text1, text2, lock_version)
    mutex = Mutex.new
    Parallel.map([text1, text2], in_threads: 2) do |element|
      puts "PID: #{Process.pid}"
      # DONE: Ensure that they are working in the same Process
      mutex.synchronize do
        puts "In synchronize"
        puts "Locked?: element#{element} => #{mutex.locked?}"
        puts "Now: element#{element} -> #{Time.now.iso8601(6)}"
        puts "Lock Version: #{lock_version}"
        object = Object.last
        raise "This is stale" if lock_version != object.version
        object.version += 1
        object.text = element
        object.save!
      end
      puts "Locked?: element#{element} => #{mutex.locked?}"
    end
  end

  def check
    object = object.last
    puts "text: #{object.text}"
    puts "lock_version: #{object.version}"
  end

  def insert
    object = object.new(text: "new")
    object.save!
  end
end
