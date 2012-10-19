# -*- coding: UTF-8 -*-

module Sieve
  # This class contains the attributes of conditions/tests 
  class Condition
    attr_accessor :test,:not,:arg1,:arg2,:type,:type_value, :comparator, :text

    # Create Condition object by text of condition or params
    #@note Example:
    #  header :contains "Subject" "teste"
    #@param [String](:text) text of condition 
    #@param [String](:test) test of condition 
    #@param [String](:not) not of condition 
    #@param [String](:arg1) arg1 of condition 
    #@param [String](:arg2) arg2 of condition 
    #@param [String](:type) type of condition 
    #@return [Condition] Condition object parsed
    def initialize params={}
      @text = params[:text]
      @test=params[:test]
      @not=params[:not]
      @arg1=params[:arg1]
      @arg2=params[:arg2]
      @type= params[:type]
      @comparator= params[:comparator] ? params[:comparator] : "i;ascii-numeric"
      parse unless @text.nil?
    end
    # Return a array of conditions after parse the text
    #@param [string] text of conditions
    #@note Example:
    #  header :contains "From" "all", header :contains "aaaaa" "333"
    # the text of conditions are splited by ','
    #@return [Array(Contition)] array of Condition
    def self.parse_all(text)
      contitions = []
      #text.scan(/([\s\w:]*\"\S+\"\s\"[\sa-zA-Z0-9,\.\-\@ÁÀÃÂÇÉÈÊÍÌÓÒÔÕÚÙÜÑáàãâçéèêíìóòôõúùüñ]*\")/).each do |item|
      text.split_where(value:",",outside:'"').each do |item| 
        contitions << self.new(text:item.strip)
      end
      contitions
    end

    # Return a text of action
    #@return [string] text of action
    def to_s
      text =""
      {
      'not'=>@not,
      'test'=>@test,
      'type'=>@type, 
      'type_value'=>@type_value, 
      'comparator_name'=>(":comparator" if [":count", ":value"].index(@type)),
      'comparator'=>(@comparator if [":count", ":value"].index(@type)),
      'arg1'=>@arg1,
      'arg2'=>@arg2
      }.each do |name, item|
        if ['arg1','arg2'].index(name)
          text += "\"#{item}\" " unless item.nil?
        else
          text += "#{item} " unless item.nil?
        end
      end
      text[text.length-1] = ""
      text
    end

    private
    # Parse text condition to variables of object
    #@note Example:
    # header :contains "From" "all"
    def parse
      if @text =~ /^true/
        @test = "true"
        return
      end

      #res = @text.scan(/(([\s\w:]+)\"(\S+)\"\s\"([\sa-zA-Z0-9,\.\-\@ÁÀÃÂÇÉÈÊÍÌÓÒÔÕÚÙÜÑáàãâçéèêíìóòôõúùüñ]*)\"|true)/)
      params = @text.split_where(value:" ",outside:'"')

      # header :contains "Subject" "lala"
      # not header :contains "Subject" "popo"
      # not exists "Subject"
      # exists "Subject"
      # header :count "ge" :comparator "i;ascii-numeric" "Subject" "1"
      # header :count "gt" :comparator "i;ascii-numeric" "Subject" "3"
      # header :count "lt" :comparator "i;ascii-numeric" "Subject" "5"
      # header :count "eq" :comparator "i;ascii-numeric" "Subject" "7"
      # header :value "gt" :comparator "i;ascii-numeric" "Subject" "9"
      # header :value "eq" :comparator "i;ascii-numeric" "Subject" "11"
      x = -1
      if params[0] == "not"
        @not = params[x+=1]
      end

      if @text =~ /contains/
        @test = params[x+=1]
        @type = params[x+=1]
        @arg1 = params[x+=1].delete('"')
        @arg2 = params[x+=1].delete('"')
      elsif @text =~ /exists/
        @test = params[x+=1]
        @arg1 = params[x+=1].delete('"')
      elsif @text =~ /count/ && @text =~ /comparator/
        @test = params[x+=1]
        @type = params[x+=1]
        @type_value = params[x+=1]
        @comparator = params[x+=2]
        @arg1 = params[x+=1].delete('"')
        @arg2 = params[x+=1].delete('"')
      end
    end
  end
end