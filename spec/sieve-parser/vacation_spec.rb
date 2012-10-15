# -*- encoding : utf-8 -*-
require 'spec_helper'

module Sieve
  describe Vacation do
    let(:filter_text_vacation){
%q{vacation :days 1 :subject "sou um assunto..." :mime text:
Content-Type: text/html;

<p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p><p>se precisar de mim, chama o <span style="text-decoration: underline;"><em><strong>batman</strong></em></span>...</p><p>eu realmente nao estou.. chama outro...</p><p>para de me amolar...xD</p>
.
;}
}
    context ".parse_text" do
      context "given a success" do
        subject{Vacation.parse_text(filter_text_vacation)}

        it "should return a object of Vacation" do
          subject.class.to_s.should == "Sieve::Vacation"
        end

        it "should have a subject" do
          subject.subject.should == "sou um assunto..."
        end

        it "should have days" do
          subject.days.should == 1
        end

        it "should have content" do
          content = %q{<p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p><p>se precisar de mim, chama o <span style="text-decoration: underline;"><em><strong>batman</strong></em></span>...</p><p>eu realmente nao estou.. chama outro...</p><p>para de me amolar...xD</p>}
          subject.content.should == content
        end
      end
    end
    context "#to_s" do
      context "given a success" do
        subject{Vacation.parse_text(filter_text_vacation)}

        it "should return a object of Vacation" do
          subject.to_s.should == filter_text_vacation
        end
      end
    end
  end 
end