require 'thor'
require 'active_support/concern'
require 'fronton/config'
require 'fronton/commands/new'
require 'fronton/commands/server'
require 'fronton/commands/compile'
require 'fronton/commands/clean'
require 'fronton/commands/clobber'
require 'fronton/commands/info'

module Fronton
  class CLI < Thor
    include Thor::Actions
    include Fronton::Commands::New
    include Fronton::Commands::Server
    include Fronton::Commands::Compile
    include Fronton::Commands::Clean
    include Fronton::Commands::Clobber
    include Fronton::Commands::Info

    no_commands do
      def config
        unless @loaded
          @loaded = true
          Fronton::Config.load!
        end

        Fronton::Config
      end
    end

    def self.source_root
      File.expand_path('../../..', __FILE__)
    end
  end
end
