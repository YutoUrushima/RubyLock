# Virtual Shared Resources
class SharedResources
  attr_accessor :version, :changed_value
  def initialize(name = "shared_resource", version = 1)
    @name = name
    @version = version
    @changed_value = nil
  end
  def is_stale?(version)
    return @version > version
  end
  def increment_version
    @version += 1
  end
end
