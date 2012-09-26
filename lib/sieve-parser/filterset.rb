# -*- coding: UTF-8 -*-

# This class implements a parse of sieve and returns a object
# to manipulate
# ONLY ACCEPTY THE "IF" conditions
#@see http://www.faqs.org/rfcs/rfc3028.html
#@see http://www.faqs.org/rfcs/rfc5804.html
#@see http://www.faqs.org/rfcs/rfc5230.html
#@see http://www.faqs.org/rfcs/rfc5229.html
# @author Thiago Coutinho<thiago @ osfeio.com>(selialkile)
# @author Thiago Coutinho<thiago.coutinho@locaweb.com.br>
# @note This code folow de "THE BEER-WARE LICENSE"

module Sieve
  class FilterSet
    attr_accessor :text_sieve
    
    #Create FilterSet
    #@param [String] text of sieve
    #@return [FilterSet]
    def initialize(text_sieve=nil)
      @text_sieve = text_sieve
      @requires = []
      @filters = []
      parse unless @text_sieve.nil?
    end

    # Return all filters of script.
    #@return [array] array of filters
    def filters
      @filters
    end

    # Add filter to filters of filterset
    #@param [Filter] filter object
    def add_filter(filter)
      raise Exception.new("The param is not a Filter!") unless filter.class.to_s == "Sieve::Filter"
      @filters << filter
    end

    # Requires inside the script
    #@return [array] names of requires
    def requires
      @requires
    end

    # Add require to requires of filterset
    #@param [string] name of require
    def add_require(req)
      #TODO: Implement config of requires allowed
      raise Exception.new("Is not a require valid!") unless req =~ /\S+/ 
      @requires << req
    end

    # Return a text of filterset
    #@return [string] text of filterset
    def to_s
      text = "require [\"#{requires.join('","')}\"];\n"
      text += filters.join("")
    end

    private
    # Make de parse and put results in variables
    def parse
      #return a array with string of elements: "xxxx", "yyyyyy"
      @text_sieve.scan(/^require\s\["(\S+)"\];$/).each do |r| 
        @requires.concat(r[0].split('","'))
      end

      @text_sieve.scan(/(^#.*\nif[\s\w\:\"\.\;\(\)\,\-]*\n\{[a-zA-Z0-9\s\@\<>=\:\[\]\_\"\.\;\(\)\,\-\/]*\n\}$)/).each do |f| 
        @filters << Sieve::Filter.new(text:f[0])
      end

    end
  end
end