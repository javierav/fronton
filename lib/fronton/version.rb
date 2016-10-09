module Fronton
  module VERSION
    MAJOR = 0
    MINOR = 4
    TINY  = 3
    PRE   = nil

    STRING = [MAJOR, MINOR, TINY, PRE].compact.join('.')
  end

  def self.version
    VERSION::STRING
  end

  def self.gem_version
    Gem::Version.new VERSION::STRING
  end
end
