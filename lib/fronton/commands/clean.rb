module Fronton
  module Commands
    module Clean
      extend ActiveSupport::Concern

      included do
        desc 'clean', 'Remove old assets'
        method_option :keep, type: :numeric, default: 2, banner: 'KEEP assets versions to keep'

        def clean
          config.manifest.clean(options[:keep])
        end
      end
    end
  end
end
