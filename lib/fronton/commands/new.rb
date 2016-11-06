module Fronton
  module Commands
    module New
      extend ActiveSupport::Concern

      included do
        desc 'new APP_NAME', 'Creates new frontend app'

        def new(name)
          if Dir.exist? name
            say_status 'create', "#{name} directory already exists. Abort!", :red
            exit 1
          else
            directory 'template', name
          end
        end
      end
    end
  end
end
