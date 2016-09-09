require 'pathname'
require 'logger'
require 'yaml'
require 'sprockets'
require 'fronton/dependency'

module Fronton
  class Config
    class YAMLNotFound < StandardError; end

    def self.load!
      file = Pathname.pwd.join('fronton.yml')

      if file.exist?
        self.new( YAML.load_file(file) )
      else
        raise YAMLNotFound, "File 'fronton.yml' not found in #{Dir.pwd}"
      end
    end

    def initialize(parsed_yaml)
      @config       = parsed_yaml
      @logger       = Logger.new($stderr)
      @logger.level = Logger::INFO
    end

    #
    ## ACCESSORS
    #

    def assets
      @assets ||= @config['assets'].is_a?(Array) ? @config['assets'] : []
    end

    def assets_paths
      @assets_paths ||= begin
        if @config['assets_paths'].is_a?(Array)
          @config['assets_paths'].map { |p| working_dir.join(p) }
        else
          []
        end
      end
    end

    def assets_url
      @config['assets_url'] || '/assets'
    end

    def output
      @output ||= working_dir.join(@config['output'] || 'public')
    end

    def dependencies
      @dependencies ||= begin
        dep = @config['dependencies'].is_a?(Array) ? @config['dependencies'] : []

        dep.map do |d|
          Dependency.new(d.keys.first, d.values.first)
        end
      end
    end

    def pages
      @pages ||= begin
        pages = @config['pages'].is_a?(Array) ? @config['pages'] : []

        pages.map do |page|
          Page.new(page.keys.first, page.values.first, config: self)
        end
      end
    end

    def pages_paths
      @pages_paths ||= begin
        if @config['pages_paths'].is_a?(Array)
          @config['pages_paths'].map { |p| working_dir.join(p) }
        else
          []
        end
      end
    end

    def compressor_js
      @config['compressors'] && @config['compressors']['js']
    end

    def compressor_css
      @config['compressors'] && @config['compressors']['css']
    end

    def environment
      @environment ||= begin
        env = Sprockets::Environment.new

        # logger
        env.logger = @logger

        # fronton.yml assets paths
        assets_paths.each { |path| env.append_path path }

        # rails assets paths
        if defined? RailsAssets
          RailsAssets.load_paths.each { |path| env.append_path path }
        end

        env
      end
    end

    def manifest
      @manifest ||= Sprockets::Manifest.new environment, File.join(output, 'assets', 'manifest.json')
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
