require 'tilt'
require 'fronton/contexts/tilt'

module Fronton
  class Page
    attr_reader :name, :url

    def initialize(name, url)
      @name   = name
      @url    = url
    end

    def content
      Tilt.new(template_path, template_options).render(Fronton::Contexts::Tilt.new)
    end

    def save
      File.open(save_path, 'w') { |f| f.write(content) }
    end

    def exist?
      !template_path.nil?
    end

    private

    def config
      Fronton::Config
    end

    def template_path
      found_path = config.pages_paths.find do |path|
        File.exist?(path.join(name))
      end

      found_path = found_path.join(name) if found_path

      found_path
    end

    def template_options
      { disable_escape: true, pretty: true }
    end

    def save_path
      config.output.join("#{File.basename(name, '.*')}.html")
    end
  end
end
