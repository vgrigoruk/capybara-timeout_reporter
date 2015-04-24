# Capybara::TimeoutReporter

[![Gem Version](https://badge.fury.io/rb/capybara-timeout_reporter.svg)](http://badge.fury.io/rb/capybara-timeout_reporter)

Speed up your Capybara tests by detecting and fixing finders that reach sync timeout.

# Description

Capybara gem is very popular in ruby community for browser-based UI test automation of web apps. Capybara has quite powerful [synchronization mechanism](https://github.com/jnicklas/capybara#asynchronous-javascript-ajax-and-friends) built in, which allows you to write tests that wait automatically until AJAX requests are completed, elements become visible, etc. However, very often engineers do not keep this Capybara feature in mind and write code like this:

```
# this line will be executing for 'Capybara.default_wait_time' seconds
refute page.has_css?('.some-non-existent-class')
```

Or like this:

```
if page.has_css?('.some_class')
  # no timeout occured in this case
else
  # "has_css?(...)" will be executing for 'Capybara.default_wait_time' seconds in this case
end
```   

Wrong usage of Capybara makes your tests slow!

capybara-timeout_reporter gem helps you to detect all places where your finders are reaching a timeout and report them. 


# Installation

```
gem install capybara-timeout_reporter
```
or if you're using bundler, add this line to Gemfile:

```
gem 'capybara-timeout_reporter
```

# Usage

Just load it after capybara gem:

```
require 'capybara'
# load timeout_reporter after capybara
require 'capybara/timeout_reporter'
```

## Basic usage

Default beviour, in case of Capybara sync timeout the following warning will be printed into STDOUT:

```
[WARNING] Capybara find timed out after <number_of_seconds> seconds in </path/to/file.rb>:<line_number> 
```

## Advanced usage

```
# somewhere in your test_helper.rb, spec_helper.rb, evn.rb, etc.
Capybara::TimeoutReporter.on_timeout = Proc.new do |timeout_value, src_line|
  # do whatever you want, for example:
  # - raise an exception, if you want to make this strict 
  # - add an entry to test report, if you have one
  # - write to a log file
  # - collect all timeouts and then report a total time wasted
end
```

## Contributing

1. Fork it `https://github.com/vgrigoruk/capybara-timeout_reporter/fork`
2. Create your feature branch (`git checkout -b new-feature`)
3. Commit your changes (`git commit -am 'Added feature'`)
4. Push to the branch (`git push origin new-feature`)
5. Create a new Pull Request
