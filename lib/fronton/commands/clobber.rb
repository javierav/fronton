require 'fileutils'

module Fronton
  module Commands
    module Clobber
      extend ActiveSupport::Concern

      included do
        desc 'clobber', 'Remove all assets'

        def clobber
          # assets
          config.manifest.clobber

          # html
          FileUtils.rm Dir.glob(config.output.join('*.html'))
        end
      end
    end
  end
end
