# Mutex Optimistic Exclusion

## Execution method
1. Load the executable file.
```ruby
  require '/file/to/path/RubyLock/optimistic_exclusion/mutex/mutex.rb'
```

2. Create an instance of the class.
```ruby
  # Try with two threads
  controller = CacheMutexLock.new(2)
```

3. Execute.
```ruby
  controller.execute(1)
```

## Example results
```bash
  INFO -> Object: threads1, PID: 1505, Now: 2022-12-29T18:11:25.615255+09:00, Is Locked: true, Lock Version: 1
  IS_LOCKING -> Object: threads1, Value: threads1, Is Locked: false
  INFO -> Object: threads2, PID: 1505, Now: 2022-12-29T18:11:25.616391+09:00, Is Locked: true, Lock Version: 2
  /file/to/path/RubyLock/optimistic_exclusion/mutex/mutex.rb:23:in `block (2 levels) in execute': This is stale! (RuntimeError)
    ...
```