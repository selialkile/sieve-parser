# -*- coding: UTF-8 -*-
# This class implements a parse of sieve filter and returns a object
# to manipulate
# @author Thiago Coutinho<thiago @ osfeio.com>(selialkile)
# @note This code folow de "THE BEER-WARE LICENSE"
module Sieve
  class Filter

    #@note [join] can be: any, allof or anyof
    attr_accessor :name, :type, :join, :text_filter

    # Initialize the class
    #@param [string] String of filter text
    #@return [object] Object of self
    def initialize(text_filter=nil)
      @text_filter = text_filter
      @conditions = []
      @actions = []
      parse unless @text_filter.nil?
    end

    # Return the conditions of filter
    #@return [array] conditions
    def conditions
      @conditions
    end

    # Return the actions of filter
    #@return [array] actions
    def actions
      @actions
    end

    # Return name of filter
    # @return [string] name of filter
    def name
      @name
    end

    # Add object of Condition to filter
    #@param [Sieve::Condition]
    def add_condition(condition)
      raise "the param is not a Condition" unless condition.class.to_s == "Sieve::Action"
      @conditions << condition
    end

    # Return a text of filter
    #@return [string] text of filter
    def to_s
      text = "# #{name}\n"
      text += "#{@type}"
      if conditions.count > 1
        text += " #{@join} (" + conditions.join(", ") + ")"
      else
        text += " " + conditions[0].to_s
      end
      text += "\n{\n    "
      text += actions.join("\n    ")
      text += "\n}\n"
    end

    private
    # Parse conditions, call the parse_common or parse_vacation
    def parse
      @text_filter[/vacation/].nil? ? parse_common : parse_vacation
    end

    private
    # Parse the filter adding contitions and actions to class
    def parse_common
      #regex_rules_params = "(^#.*)\nif([\s\w\:\"\.\;\(\)\,\-]+)\{([\@\<>=a-zA-Z0-9\s\[\]\_\:\"\.\;\(\)\,\-\/]+)\}$"
      #regex_rules_params2 = "(^#.*)\n(\S+)(.+)\n\{\n([\s\S]*)\}"
      parts = @text_filter.scan(/(^#.*)\n(\S+)\s(.+)\n\{\n([\s\S]*)\}/)[0]
      parse_name(parts[0])
      @type = parts[1]
      #if the join is true, dont have conditions...
      if parts[2] =~ /true/
        @conditions << Condition.new(type:"true")
      elsif parts[2] =~ /(anyof|allof)/
        @join = parts[2][/^\S+/]
        @conditions.concat(Condition.parse_all( parts[2].scan(/\(([\S\s]+)\)/)[0][0] ))
      else
        @conditions << Condition.new(parts[2])
      end

      @actions.concat(Action.parse_all(parts[3]))
    end

    private
    # Parse the vacation filter
    def parse_vacation

    end

    def parse_name(text_name)
      @name = text_name.match(/#(.*)/)[1].strip
    end
  end

  class Vacation
    attr_accessor :days, :subject, :content
  end
end