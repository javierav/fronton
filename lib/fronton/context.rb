module Fronton
  module Context
    def self.included(klass)
      klass.class_eval do
        class_attribute :assets_prefix, :digest_assets
      end
    end

    def asset_url(path, _options = {})
      "url(#{asset_path(path)})"
    end
    alias_method :'asset-url', :asset_url

    def asset_path(path, _options = {})
      asset = link_asset(path)
      digest_path = asset.digest_path
      path = digest_path if digest_assets
      File.join(assets_prefix || "/", path)
    end
    alias_method :'asset-path', :asset_path
  end
end
