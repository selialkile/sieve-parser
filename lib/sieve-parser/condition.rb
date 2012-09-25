# -*- coding: UTF-8 -*-

module Sieve
  # This class contains the attributes of conditions/tests 
  class Condition
    attr_accessor :test,:not,:arg1,:arg2,:type, :text

    # Create Condition object by text of condition
    #@note Example:
    #  header :contains "Subject" "teste"
    #@param [string] text of condition 
    #@return [Condition] Condition object parsed
    def initialize(text=nil)
      @text = text
      @test=nil
      @not=nil
      @arg1=nil
      @arg2=nil
      @type=nil
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
      text.scan(/([\s\w:]*\"\S+\"\s\"[\sa-zA-Z0-9,ÁÀÃÂÇÉÈÊÍÌÓÒÔÕÚÙÜÑáàãâçéèêíìóòôõúùüñ]*\")/).each do |item|
        contitions << self.new(item[0])
      end
      contitions
    end

    # Return a text of action
    #@return [string] text of action
    def to_s
      text =""
      {"not"=>@not,'test'=>@test,'type'=>@type,'arg1'=>@arg1,'arg2'=>@arg2}.each do |name, item|
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

      res = @text.scan(/(([\s\w:]+)\"(\S+)\"\s\"([\sa-zA-Z0-9,ÁÀÃÂÇÉÈÊÍÌÓÒÔÕÚÙÜÑáàãâçéèêíìóòôõúùüñ]*)\"|true)/)

      params = res[0][1].strip.split(" ")
      params += [res[0][2]] + [res[0][3]]
      
      if params[0] == "not"
        @not = params[0]
        @test = params[1]
        @type = params[2]
        @arg1 = params[3]
        @arg2 = params[4]
      else
        @test = params[0]
        @type = params[1]
        @arg1 = params[2]
        @arg2 = params[3]
      end
    end
  end
end