require 'fileutils'
require 'rack'
require 'rack/livereload'
require 'thor'
require 'fronton/config'
require 'fronton/html_server'

module Fronton
  class CLI < Thor # rubocop:disable Metrics/ClassLength
    include Thor::Actions

    def self.source_root
      File.expand_path('../../..', __FILE__)
    end

    no_commands do
      def config
        if !@config.is_a?(Fronton::Config) && @config.respond_to?(:call)
          @config = @config.call
        else
          @config
        end
      end
    end

    def initialize(*args)
      super(*args)
      @config = -> { Fronton::Config.load! }
    end

    desc 'new APP_NAME', 'Creates new frontend app'
    def new(name)
      if Dir.exist? name
        say_status 'create', "#{name} directory already exists. Abort!", :red
        exit 1
      else
        directory 'template', name
      end
    end

    desc 'server', 'Preview your app in browser'
    method_option :host, type: :string, default: '127.0.0.1', banner: 'HOST the host address to bind to'
    method_option :port, type: :numeric, default: 3000, banner: 'PORT the port to bind to'
    method_option :livereload, type: :boolean, default: false, banner: 'BOOLEAN enable or disable livereload support'
    def server # rubocop:disable Metrics/AbcSize
      # install dependencies for rails assets
      config.install_dependencies

      # require dependencies for rails assets
      config.require_dependencies

      # assets helpers
      config.environment.context_class.digest_assets = false
      config.environment.context_class.assets_prefix = '/assets'

      conf = config
      opts = options

      app = Rack::Builder.new do
        map('/assets') { run conf.environment }
        map('/') do
          use Rack::LiveReload if opts[:livereload]
          run Fronton::HTMLServer.new(config: conf)
        end
      end

      Rack::Server.start(
        app: app,
        environment: 'development',
        Host: options[:host],
        Port: options[:port]
      )
    end

    desc 'compile', 'Compiles assets using digest and minification'
    def compile # rubocop:disable Metrics/AbcSize
      # install dependencies for rails assets
      config.install_dependencies

      # require dependencies for rails assets
      config.require_dependencies

      # configure environment
      if config.compressor_js
        config.environment.js_compressor  = config.compressor_js.to_sym
      end

      if config.compressor_css
        config.environment.css_compressor = config.compressor_css.to_sym
      end

      # assets helpers
      prefix = "#{config.assets_url}/assets"
      config.environment.context_class.digest_assets = true
      config.environment.context_class.assets_prefix = prefix

      # compile assets
      config.manifest.compile(config.assets)

      # compile html pages
      config.pages.map(&:save)
    end

    desc 'clean', 'Remove old assets'
    method_option :keep, type: :numeric, default: 2, banner: 'KEEP assets versions to keep'
    def clean
      config.manifest.clean(options[:keep])
    end

    desc 'clobber', 'Remove all assets'
    def clobber
      # assets
      config.manifest.clobber

      # html
      FileUtils.rm Dir.glob(config.output.join('*.html'))
    end

    desc 'info', 'Information about project'
    def info # rubocop:disable Metrics/AbcSize
      say 'Dependencies', :bold

      @dependencies = config.dependencies.map do |dep|
        status = dep.available? ? 'Installed' : 'Not Installed'
        [dep.name, dep.version, status]
      end

      print_table @dependencies

      puts ''

      say 'Assets Paths', :bold
      config.assets_paths.each do |path|
        say path.to_s, Dir.exist?(path) ? nil : :red
      end

      puts ''

      say 'Pages Paths', :bold
      config.pages_paths.each do |path|
        say path.to_s, Dir.exist?(path) ? nil : :red
      end

      puts ''

      say 'Sprockets Engines', :bold

      @engines = config.environment.engines.map { |ext, klass| [ext, klass] }
      print_table @engines

      puts ''

      say 'Compressors', :bold

      @available_compressors = []
      @used_compressors = [config.compressor_css.to_sym, config.compressor_js.to_sym]

      config.environment.compressors.each do |mime, list|
        list.each do |id, klass|
          mark = @used_compressors.include?(id) ? '<--' : ''
          @available_compressors << [mime, id, klass, mark]
        end
      end

      print_table @available_compressors

      puts ''

      say "Powered by Fronton v#{Fronton.version} - https://github.com/javierav/fronton", :bold
    end
  end
end
