require "rubygems"
require "daemons"
require "active_record"
require_relative "aspect"
require_relative "item"
require_relative "category"
require_relative "photo"
require "open-uri"
require "nokogiri"
require "rebay"

@options = {
  :dir_mode   => :script,
  :multiple   => false,
  :backtrace  => true,
  :monitor    => true,
  :log_output => true
}

Daemons.run('loop.rb', @options)
