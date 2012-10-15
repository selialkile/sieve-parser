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

class SieveErrors
  class FilterNotFound < StandardError;end
  class InvalidParam < StandardError;end
end

module Sieve

  class FilterSet
    attr_accessor :text_sieve, :auto_require
    
    #Create FilterSet
    #@param [String] text of sieve
    #@return [FilterSet]
    def initialize(text_sieve=nil)
      @text_sieve = text_sieve
      @requires = []
      @filters = []
      @auto_require = true
      parse unless @text_sieve.nil?
    end

    # Return all filters of script.
    #@return [array] array of filters
    def filters
      @filters
    end

    # Return filter by name
    # @param [String] name of filter
    # @return [integer] index of filter
    def find_filter_by_name(name)
      @filters[filter_index_by_name(name)]
    end

    # Return filter index by name
    # @param [String] name of filter
    # @return [Sieve::Filter]
    def filter_index_by_name(name)
      key = @filters.index{|f| f.name==name}
      raise SieveErrors::FilterNotFound unless key
      key
    end

    # Remove filter by name
    # @param [String] name of filter
    # @return [Array] @filter array
    def remove_filter_by_name(name)
      filter_index_by_name(name)
      @filters.delete_if {|f| f.name == name }
    end

    # Add filter to filters of filterset
    #@param [Filter] filter object
    def add_filter(filter)
      raise Exception.new("The param is not a Filter!") unless filter.class.to_s == "Sieve::Filter"
      load_requires(filter) if @auto_require == true
      @filters << filter
    end

    # Requires inside the script
    #@return [array] names of requires
    def requires
      @requires.uniq!
      @requires
    end

    # Add require to requires of filterset
    #@param [string] name of require
    def add_require(req)
      #TODO: Implement config of requires allowed
      raise Exception.new("Is not a require valid!") unless req =~ /\S+/ 
      @requires << req
      @requires.uniq!
    end

    # Return a text of filterset
    #@return [string] text of filterset
    def to_s
      text = ""
      text = "require [\"#{requires.join('","')}\"];\n" if @requires.count > 0
      text += filters.join("") if filters.count > 0
      text
    end

    # Return a array of filters by select with all given params
    #@param [{:name=>String, :disabled => Boolean, :text => String}] 
    #@note The :text only have text to search
    #@return [Array<Sieve::Filter>]
    def where
      entries =[]
      @filters.each do |filter| 
        cond = false
        cond = filter.name == args[:name] unless args[:name].nil?
        cond = filter.disabled? == args[:disabled] unless args[:disabled].nil?
        cond = filter.to_s =~ /#{args[:text]}/ unless args[:text].nil? 
        entries << filter if cond
      end
      entries
    end

    private
    # Make de parse and put results in variables
    def parse
      #return a array with string of elements: "xxxx", "yyyyyy"
      @text_sieve.scan(/^require\s\["(\S+)"\];$/).each do |r| 
        @requires.concat(r[0].split('","'))
      end

      @text_sieve.scan(/(^#.*\nif[\s\w\:\"\.\;\(\)\,\-]*\n\{[a-zA-Z0-9\s\@\<>=\:\[\]\_\"\.\;\(\)\&\,\-\/]*\n\}$)/).each do |f| 
        @filters << Sieve::Filter.new(text:f[0])
      end

    end

    #Load requires by filter
    #@param [Sieve::Filter] object of filter
    def load_requires(filter)
      text_requires =  "fileinto reject envelope encoded-character vacation "
      text_requires += "subaddress comparator-i;ascii-numeric relational regex "
      text_requires += "imap4flags copy include variables body enotify environment mailbox date"
      text_requires.split(" ").each do |search|
        if filter.to_s.index(search)
          add_require(search)
        end
      end
    end
  end
end