require 'fronton/page'

module Fronton
  class HTMLServer
    def initialize(options = {})
      @config = options.fetch(:config)
    end

    # Rack entrypoint
    def call(env)
      if page = requested_page(env) # rubocop:disable Lint/AssignmentInCondition

        if page.exist?
          render_page(page)
        else
          error_404
        end
      else
        error_404
      end
    end

    private

    def requested_page(env)
      @config.pages.find { |page| page.url == env['PATH_INFO'] }
    end

    def render_page(page)
      [200, { 'Content-Type' => 'text/html' }, [page.content]]
    end

    def error_404
      [404, { 'Content-Type' => 'text/plain' }, ['Not Found']]
    end
  end
end
