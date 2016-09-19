module Fronton
  class AssetsHelpers
    def initialize(options = {})
      @use_digest = options.fetch(:digest, false)
      @prefix     = options.fetch(:prefix, 'assets')
      @manifest   = options.fetch(:manifest)
    end

    def javascript_tag(name)
      name = asset_path("#{name}.js")
      %(<script src="#{name}"></script>\n)
    end

    def stylesheet_tag(name)
      name = asset_path("#{name}.css")
      %(<link href="#{name}" media="screen" rel="stylesheet" />\n)
    end

    def asset_path(name)
      asset_name = @use_digest && @manifest.assets[name] ? @manifest.assets[name] : name
      "/#{@prefix}/#{asset_name}"
    end
  end
end
