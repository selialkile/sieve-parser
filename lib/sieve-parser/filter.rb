# -*- coding: UTF-8 -*-
# This class implements a parse of sieve filter and returns a object
# to manipulate
# 
# @author Thiago Coutinho<thiago @ osfeio.com>(selialkile)
# @note This code folow de "THE BEER-WARE LICENSE"
module Sieve
  #TODO:For future, Filter will be has a children, and make more complex filter
  class Filter

    #@note [join] can be: any, allof or anyof
    attr_accessor :name, :type, :join, :disabled, :text, :children

    # Initialize the class
    #@param [String](:text) String of filter text
    #@param [Array](:conditions) Array of Conditions
    #@param [Array](:actions) Array of Actions
    #@return [object] Object of self
    def initialize params={}
      @text = params[:text]
      @type = (params[:type]) ? params[:name] : "if"
      @name = params[:name]
      @join = params[:join]
      @disabled = params[:disabled]
      @conditions = (params[:conditions]) ? params[:conditions] : []
      @actions = (params[:actions]) ? params[:actions] : []
      @children = []
      parse unless @text.nil?
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

    # Add object of Action to filter
    #@param [Sieve::Action]
    def add_action(action)
      types = ["Sieve::Action", "Sieve::Vacation"]
      raise "the param is not a Action" unless types.index(action.class.to_s)
      @actions << action
    end

    # Add object of Condition to filter
    #@param [Sieve::Condition]
    def add_condition(condition)
      raise "the param is not a Condition" unless condition.class.to_s == "Sieve::Condition"
      @conditions << condition
    end

    # Return a text of filter
    #@return [string] text of filter
    def to_s
      text = "# #{name}\n"
      text += "#{@type}" + ((disabled?) ? " false #" : "")
      if conditions.count > 1
        text += " #{@join} (" + conditions.join(", ") + ")"
      else
        text += " " + conditions[0].to_s
      end
      text += "\n{\n"
      text += "\t" + actions.join("\n\t") if actions.count > 0
      text += "\n}\n"
    rescue => e
      puts e.to_s
    end

    # Is disabled or not? Return the status of filter
    #@return [boolean] true for disabled and false for enabled
    def disabled?
      @disabled == true
    end

    def disable!
      @disabled = true
    end

    # Return if filter have a children
    def children?
      (@children.count > 0) ? true : false
    end

    private
    # Parse conditions, call the parse_common or parse_vacation
    def parse
      begin
        #regex_rules_params = "(^#.*)\nif([\s\w\:\"\.\;\(\)\,\-]+)\{([\@\<>=a-zA-Z0-9\s\[\]\_\:\"\.\;\(\)\,\-\/]+)\}$"
        #regex_rules_params2 = "(^#.*)\n(\S+)(.+)\n\{\n([\s\S]*)\}"
        parts = @text.scan(/(^#.*)\n(\S+)\s(.+)\n\{\n([\s\S]*)\n\}/)[0]
        parse_name(parts[0])
        @type = parts[1]

        self.disable! if parts[2] =~ /.*false #/
        #if the join is true, dont have conditions...
        if parts[2] =~ /true/
          @conditions << Condition.new(type:"true")
        elsif parts[2] =~ /(anyof|allof)/
          @join = parts[2][/^\S+/]
          @conditions.concat(Condition.parse_all( parts[2].scan(/\(([\S\s]+)\)/)[0][0] ))
        else
          @conditions << Condition.new(text:parts[2])
        end

        @actions.concat(Action.parse_all(parts[3]))
      rescue => e
        puts e.to_s + " - text: #{@text}"
      end
    end

    def parse_name(text_name)
      @name = text_name.match(/#(.*)/)[1].strip
    end

    # Parse the children of filters(else/elseif)
    def parse_children(text)
    end
  end

end