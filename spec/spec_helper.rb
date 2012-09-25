require 'rubygems'
require 'pry'
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
#%w(filterset filter action condition).each do |entity|
# %w(filterset).each do |entity|
#   require_relative "../lib/"+entity
# end
require "sieve-parser"

RSpec.configure do |config|
  config.filter_run_excluding :broken => true
  config.mock_with :rspec
end