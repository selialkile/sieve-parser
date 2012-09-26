# -*- coding: UTF-8 -*-

module Sieve
    
  # This class contains the attributes of vacation/autoreplay(action) 
  class Vacation
    attr_accessor :days, :subject, :content, :type

    # New object
    #@param [String](:subject) subject of vacation
    #@param [String](:content) content of vacation
    #@param [Integer](:days) days of recurrence message for same From
    def initialize params={}
      @days = (params[:days] ? params[:days].to_i : 1)
      @subject = params[:subject]
      @content = params[:content]
      @type = "vacation"
    end

    # Parse text and return self with params
    #@param [string] text of vacation action
    #@return [Vacation] object of vacation
    def self.parse_text(text)
      params = text.scan(/vacation :days (\d+) :subject "(.*)".*\n.*\s*(.*)/)[0]
      Vacation.new(:days=>params[0],:subject => params[1],:content => params[2])
    end

    # Return text of vacation action
    #@return [string] text of vacation formated
    def to_s
      %Q{vacation :days #{@days} :subject "#{@subject}" :mime text:
Content-Type: text/html;

#{@content}
.
;}
    end
  end
end