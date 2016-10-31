require 'tilt'
require 'fronton/assets_helpers'

module Fronton
  class Page
    attr_reader :name, :url, :config

    def initialize(name, url, options = {})
      @name   = name
      @config = options.fetch(:config)
      @digest = options.fetch(:digest, false)
      @prefix = options.fetch(:prefix, '/assets')
      @url    = url
    end

    def content
      Tilt.new(template_path, template_options).render(AssetsHelpers.new(helpers_options))
    end

    def save
      with_digest do
        with_prefix "#{config.assets_url}/assets" do
          File.open(save_path, 'w') { |f| f.write(content) }
        end
      end
    end

    def exist?
      !template_path.nil?
    end

    private

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

    def helpers_options
      { digest: @digest, manifest: @config.manifest, prefix: @prefix }
    end

    def save_path
      config.output.join("#{File.basename(name, '.*')}.html")
    end

    def with_digest
      @digest = true; yield; @digest = false # rubocop:disable Style/Semicolon
    end

    def with_prefix(prefix)
      old_prefix = @prefix
      @prefix = prefix
      yield
      @prefix = old_prefix
    end
  end
end
