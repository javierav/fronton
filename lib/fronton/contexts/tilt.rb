module Fronton
  module Contexts
    class Tilt
      def javascript_tag(name)
        %(<script src="#{asset_path("#{name}.js")}"></script>\n)
      end

      def stylesheet_tag(name)
        %(<link href="#{asset_path("#{name}.css")}" media="screen" rel="stylesheet" />\n)
      end

      def asset_path(name)
        asset_name = config.use_digest && config.manifest.assets[name] ? config.manifest.assets[name] : name
        "#{config.assets_prefix}/#{asset_name}"
      end

      private

      def config
        Fronton::Config
      end
    end
  end
end
