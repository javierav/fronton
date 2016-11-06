module Fronton
  module Commands
    module Info
      extend ActiveSupport::Concern

      included do
        desc 'info', 'Display relevant information about a project'

        def info # rubocop:disable Metrics/AbcSize
          say 'Dependencies', :bold

          @dependencies = config.dependencies.map do |dep|
            status = dep.available? ? 'Installed' : 'Not Installed'
            [dep.name, dep.version, status]
          end

          print_table @dependencies

          puts ''

          say 'Assets Paths', :bold
          config.assets_paths.each do |path|
            say path.to_s, Dir.exist?(path) ? nil : :red
          end

          puts ''

          say 'Pages Paths', :bold
          config.pages_paths.each do |path|
            say path.to_s, Dir.exist?(path) ? nil : :red
          end

          puts ''

          say 'Sprockets Engines', :bold

          @engines = config.environment.engines.map { |ext, klass| [ext, klass] }
          print_table @engines

          puts ''

          say 'Compressors', :bold

          @available_compressors = []
          @used_compressors = [config.compressor_css.to_sym, config.compressor_js.to_sym]

          config.environment.compressors.each do |mime, list|
            list.each do |id, klass|
              mark = @used_compressors.include?(id) ? '<--' : ''
              @available_compressors << [mime, id, klass, mark]
            end
          end

          print_table @available_compressors

          puts ''

          say "Powered by Fronton v#{Fronton.version} - https://github.com/javierav/fronton", :bold
        end
      end
    end
  end
end
