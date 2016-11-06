require 'pathname'
require 'logger'
require 'yaml'
require 'sprockets'
require 'active_support/core_ext/hash/indifferent_access'
require 'fronton/dependency'
require 'fronton/contexts/sprockets'

module Fronton
  class Config
    class YAMLNotFound < StandardError; end

    PRECOMPILE_CRITERIA = lambda do |logical_path, filename|
      filename.start_with?(Dir.pwd) && !['.js', '.css', ''].include?(File.extname(logical_path))
    end

    class << self
      attr_reader :logger
      attr_writer :use_base, :use_digest, :assets_path

      def load!
        file = working_dir.join('fronton.yml')

        if file.exist?
          @config       = YAML.load_file(file).with_indifferent_access
          @logger       = Logger.new($stderr)
          @logger.level = Logger::INFO
        else
          raise YAMLNotFound, "File 'fronton.yml' not found in #{Dir.pwd}"
        end
      end

      #
      ## ACCESSORS
      #

      def use_base
        @use_base.nil? ? false : @use_base
      end

      def use_digest
        @use_digest.nil? ? false : @use_digest
      end

      def assets_path
        @assets_path.nil? ? 'assets' : @assets_path
      end

      def assets_prefix
        use_base ? "#{base_url}/#{assets_path}" : assets_path
      end

      #
      ## YAML CONFIG
      #

      def assets
        @assets ||= begin
          assets_conf = @config[:assets].is_a?(Array) ? @config[:assets] : []
          [PRECOMPILE_CRITERIA, %r{(?:/|\\|\A)application\.(css|js)$}] + assets_conf
        end
      end

      def assets_paths
        @assets_paths ||= begin
          if @config[:assets_paths].is_a?(Array)
            @config[:assets_paths].map { |p| working_dir.join(p) }
          else
            []
          end
        end
      end

      def base_url
        @config[:base_url]
      end

      def output
        @output ||= working_dir.join(@config[:output] || 'public')
      end

      def dependencies
        @dependencies ||= begin
          dep = @config[:dependencies].is_a?(Array) ? @config[:dependencies] : []

          dep.map do |d|
            Dependency.new(d.keys.first, d.values.first)
          end
        end
      end

      def fallback_page
        if @config[:fallback_page]
          Page.new(@config[:fallback_page], '/')
        end
      end

      def pages
        @pages ||= begin
          pages = @config[:pages].is_a?(Array) ? @config[:pages] : []

          pages.map do |page|
            Page.new(page.keys.first, page.values.first)
          end
        end
      end

      def pages_paths
        @pages_paths ||= begin
          if @config[:pages_paths].is_a?(Array)
            @config[:pages_paths].map { |p| working_dir.join(p) }
          else
            []
          end
        end
      end

      def compressor_js
        @config[:compressors] && @config[:compressors][:js]
      end

      def compressor_css
        @config[:compressors] && @config[:compressors][:css]
      end

      def environment
        @environment ||= begin
          env = Sprockets::Environment.new

          # logger
          env.logger = logger

          # fronton.yml assets paths
          assets_paths.each { |path| env.append_path path }

          # rails assets paths
          if defined? RailsAssets
            RailsAssets.load_paths.each { |path| env.append_path path }
          end

          # context helpers
          env.context_class.send :include, ::Fronton::Contexts::Sprockets

          env
        end
      end

      def manifest
        @manifest ||= Sprockets::Manifest.new environment, File.join(output, assets_path, 'manifest.json')
      end

      #
      ## METHODS
      #

      def install_dependencies
        dependencies.map(&:install_dependency)
      end

      def require_dependencies
        dependencies.map(&:require_dependency)
      end

      private

      def working_dir
        Pathname.pwd
      end
    end
  end
end
