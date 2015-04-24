require 'capybara'

module Capybara
  class TimeoutReporter
    @@on_timeout = Proc.new do |seconds, src_line|
      puts "[WARNING] Capybara find timed out after #{seconds} seconds in #{src_line}"
    end

    def self.on_timeout=(proc)
      @@on_timeout = proc
    end
  end

  module Node
    class Base
      def synchronize_with_warning(seconds=Capybara.default_wait_time, options = {}, &block)
        start_time = Time.now
        synchronize_without_warning(seconds, options, &block)
      rescue Capybara::ElementNotFound => e
        if Time.now-start_time > seconds
          trace_line = Thread.current.backtrace.find { |l| !l.include?('gems/capybara')}
          src_line = trace_line.match(/(.*):.*/).captures.first
          Capybara::TimeoutReporter.call(:on_timeout, seconds, src_line)
        end
        raise e
      end

      alias_method :synchronize_without_warning, :synchronize
      alias_method :synchronize, :synchronize_with_warning
    end
  end
end