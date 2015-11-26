require 'capybara'

module Capybara
  class TimeoutReporter

    @exclude_patterns = [/capybara-timeout_reporter/, /gems\/capybara\//]
    @include_patterns = [/.*/]

    class << self
      attr_accessor :exclude_patterns
      attr_accessor :include_patterns

      def on_timeout(&block)
        @block = block
      end

      def report(seconds, src_line)
        @block.call(seconds, src_line)
      end

      def default_wait_time
        Capybara.respond_to?(:default_max_wait_time) ? Capybara.default_max_wait_time : Capybara.default_wait_time
      end
    end

    on_timeout do |seconds, src_line|
      puts "[WARNING] Capybara find timed out after #{seconds} seconds in #{src_line}"
    end
  end

  module Node
    class Base
      def synchronize_with_warning(seconds=Capybara::TimeoutReporter.default_wait_time, options = {}, &block)
        start_time = Time.now
        synchronize_without_warning(seconds, options, &block)
      rescue Capybara::ElementNotFound => e
        if Time.now-start_time > seconds
          backtrace = Thread.current.backtrace
          Capybara::TimeoutReporter.exclude_patterns.each do |pattern|
            backtrace.reject! { |line| line =~ pattern }
          end
          backtrace.select! do |line|
            Capybara::TimeoutReporter.include_patterns.any? { |pattern| (line =~ pattern) }
          end
          trace_line = backtrace.length > 0 ? backtrace[0] : nil
          src_line = trace_line ? trace_line.match(/(.*):.*/).captures.first : "Can't find line that matches the pattern"
          Capybara::TimeoutReporter.report(seconds, src_line) if src_line
        end
        raise e
      end

      alias_method :synchronize_without_warning, :synchronize
      alias_method :synchronize, :synchronize_with_warning
    end
  end
end
