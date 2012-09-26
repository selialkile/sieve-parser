module Sieve
  %w(filterset filter action condition vacation).each do |entity|
    require_relative "sieve-parser/#{entity}"
  end
end