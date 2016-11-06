module Fronton
  module Contexts
    module Sprockets
      def asset_url(path, _options = {})
        "url(#{asset_path(path)})"
      end
      alias_method :'asset-url', :asset_url

      def asset_path(path, _options = {})
        asset = link_asset(path)
        digest_path = asset.digest_path
        path = digest_path if config.use_digest

        if current_prefix.empty?
          path
        else
          "#{current_prefix}/#{path}"
        end
      end
      alias_method :'asset-path', :asset_path

      private

      # TODO, revisar esto para no tener logica aqui metida
      def current_prefix
        if !config.use_base && content_type == 'text/css'
          ''
        else
          config.assets_prefix
        end
      end

      def config
        Fronton::Config
      end
    end
  end
end
