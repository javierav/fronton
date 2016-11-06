module Fronton
  module Commands
    module Compile
      extend ActiveSupport::Concern

      included do
        desc 'compile', 'Compile assets'
        method_option :digest, type: :boolean, default: true, banner: 'BOOLEAN enable or disable assets digest'
        method_option :compress, type: :boolean, default: true, banner: 'BOOLEAN enable or disable assets compression'
        method_option :base, type: :boolean, default: true, banner: 'BOOLEAN enable or disable use of base_url in assets paths'

        def compile # rubocop:disable Metrics/AbcSize
          # install dependencies for rails assets
          config.install_dependencies

          # require dependencies for rails assets
          config.require_dependencies

          # configure environment
          if config.compressor_js && options[:compress]
            config.environment.js_compressor = config.compressor_js.to_sym
          end

          if config.compressor_css && options[:compress]
            config.environment.css_compressor = config.compressor_css.to_sym
          end

          # configuration
          config.use_base   = options[:base]
          config.use_digest = options[:digest]

          # compile assets
          require 'non-stupid-digest-assets' unless options[:digest]

          config.manifest.compile(config.assets)

          # compile html pages
          config.pages.each(&:save)
        end
      end
    end
  end
end
