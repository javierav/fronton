require 'rack'
require 'rack/livereload'
require 'fronton/server'

module Fronton
  module Commands
    module Server
      extend ActiveSupport::Concern

      included do
        desc 'server', 'Preview your app in a browser'
        method_option :host, type: :string, default: '127.0.0.1', banner: 'HOST the host address to bind to'
        method_option :port, type: :numeric, default: 3000, banner: 'PORT the port to bind to'
        method_option :livereload, type: :boolean, default: false, banner: 'BOOLEAN enable or disable livereload support'

        def server # rubocop:disable Metrics/AbcSize
          # install dependencies for rails assets
          config.install_dependencies

          # require dependencies for rails assets
          config.require_dependencies

          conf = config
          opts = options

          app = Rack::Builder.new do
            map('/assets') { run conf.environment }
            map('/') do
              use Rack::LiveReload if opts[:livereload]
              run Fronton::Server.new
            end
          end

          Rack::Server.start(
            app: app,
            environment: 'development',
            Host: options[:host],
            Port: options[:port]
          )
        end
      end
    end
  end
end
