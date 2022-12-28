# 仮想共有リソース
class SharedResources
  attr_accessor :version, :is_changed
  def initialize(name = "shared_resource", version = 1)
    @name = name
    @version = version
    @is_changed = false
  end
  def is_stale?(version)
    return @version > version
  end
  def increment_version
    @version += 1
  end
end
