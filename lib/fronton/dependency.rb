module Fronton
  class Dependency
    attr_reader :name, :version

    def initialize(name, version)
      @name = name
      @version = version
    end

    def available?
      Gem::Specification.find_by_name(@name, @version) && true
    rescue Gem::LoadError => _
      false
    end

    def install_dependency
      Gem.install @name, @version unless available?
    end

    def require_dependency
      # activate gem
      gem @name, @version
      # require gem
      require @name
    end
  end
end
