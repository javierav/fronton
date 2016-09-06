require 'slim'
require 'slim/include'
require 'tilt'
require 'fronton/assets_helpers'

module Fronton
  class Page
    attr_reader :name, :config

    def initialize(name, options = {})
      @name   = name
      @config = options.fetch(:config)
      @digest = options.fetch(:digest, false)
    end

    def content
      Tilt.new(template_path, template_options).render(AssetsHelpers.new(helpers_options))
    end

    def save
      File.open(save_path, 'w') { |f| f.write(content) }
    end

    def exist?
      !template_path.nil?
    end

    private

    def template_path
      found_path = config.pages_paths.find do |path|
        File.exist?(path.join("#{name}.slim"))
      end

      found_path = found_path.join("#{name}.slim") if found_path

      found_path
    end

    def template_options
      { disable_escape: true, pretty: true, include_dirs: partials_paths }
    end

    def helpers_options
      { digest: @digest, manifest: @config.manifest }
    end

    def partials_paths
      config.pages_paths.map { |path| path.join('partials') }
    end

    def save_path
      config.output.join("#{name}.html")
    end
  end
end
