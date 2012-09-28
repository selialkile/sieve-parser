# -*- coding: UTF-8 -*-

module Sieve
    
  # This class contains the attributes of action 
  class Action
    attr_accessor :type, :copy, :target, :text

    # Create Action object by text of action
    #@param [string] text of action 
    #@note Example:
    #  fileinto :copy "INBOX.lixo"
    #@return [Action] action object parsed
    def initialize(text=nil)
      @text = text
      @type=nil
      @copy=nil
      @target=nil
      parse unless @text.nil?
    end

    # Return a array of actions after parse the text
    #@note Example:
    #  fileinto "INBOX";
    #  fileinto :copy "INBOX.lixo";
    #  stop;
    #@param [string] text of actions
    #@return [Array(Action)] array of Actions
    def self.parse_all(text)
      lines = text.scan(/^[\s]*(.+;)$|^[\s]*(.+\n\S+.*;\s*.*\n\.\n\;)/)
      actions = []
      lines.each do |line|
        if !line[0].nil?
          actions << self.new(line[0])
        else
          actions << Sieve::Vacation.parse_text(line[1])
        end
      end
      actions
    end

    # Return a text of action
    #@return [string] text of action
    def to_s
      text =""
      {'type'=>@type, 'copy'=>(@copy) ? ":copy" : nil, 'target'=>@target}.each do |name,item|
        if ['target'].index(name)
          text += "\"#{item}\" " unless item.nil?
        else
          text += "#{item} " unless item.nil?
        end

      end
      text[text.length-1] = ";" if text.length > 0
      text
    end

    private
    # Parse text actions to variables of object
    #@note Example:
    #  @text = %q{fileinto :copy "INBOX.lixo"};
    def parse
      [';', '"'].each{|d| @text.delete!(d)}
      params = @text.split(" ")
      @type = params[0]
      if params[1]==":copy"
        @copy = true
        @target = params[2]
      else
        @target = params[1]
      end
    end
  end
end