# -*- encoding : utf-8 -*-
require 'spec_helper'

module Sieve
  describe Filter do
    let(:filter_text_anyof){
%Q{# rule:[nome_all]
if anyof (header :contains "From" "all", header :contains "aaaaa" "333")
{
\tfileinto :copy "INBOX.lixo";
\tredirect "eduardo.lipolis@locaweb.com.br";
}
}
    }
    let(:filter_text_allof){
%Q{# rule:[nome all rules]
if allof (header :contains "Subject" "asdf", header :contains "From" "vvvvv", header :contains "To" "vvvvv")
{
\tfileinto :copy "INBOX.rascunho";
\tstop;
}
}
    }
    let(:filter_text_vacation){
%Q{# rule:[autoresposta]
if true
{
\tvacation :days 1 :subject "nao estou..." :mime text:
Content-Type: text/html;

<p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p><p>se precisar de mim, chama o <span style="text-decoration: underline;"><em><strong>batman</strong></em></span>...</p><p>eu realmente nao estou.. chama outro...</p><p>para de me amolar...xD</p>
.
;
}
}
    }
    let(:filter_text_vacation_disabled){
%Q{# rule:[autoresposta]
if false #true
{
\tvacation :days 1 :subject "nao estou..." :mime text:
Content-Type: text/html;

<p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p><p>se precisar de mim, chama o <span style="text-decoration: underline;"><em><strong>batman</strong></em></span>...</p><p>eu realmente nao estou.. chama outro...</p><p>para de me amolar...xD</p>
.
;
}
}
    }

    context ".new" do
      context "given a success with type anyof" do
        subject{Sieve::Filter.new(text:filter_text_anyof)}

        it 'should have a name' do
          subject.name.should == "rule:[nome_all]"
        end

        it "should have conditions" do
          subject.conditions.count.should == 2
        end

        it "should have actions" do
          subject.actions.count.should == 2
        end
      end

      context "given a success with type allof" do
        subject{Sieve::Filter.new(text:filter_text_allof)}

        it 'should have a name' do
          subject.name.should == "rule:[nome all rules]"
        end

        it "should have conditions" do
          subject.conditions.count.should == 3
        end

        it "should have actions" do
          subject.actions.count.should == 2
        end
      end

      context "given a success with vacation action enabled" do
        subject{Sieve::Filter.new(text:filter_text_vacation)}

        it 'should have a name' do
          subject.name.should == "rule:[autoresposta]"
        end

        it "should have conditions" do
          subject.conditions.count.should == 1
        end

        it "should have actions" do
          subject.actions.count.should == 1
        end

        it "should is enabled" do
          subject.disabled?.should be_false
        end

      end

      context "given a success with vacation action disabled" do
        subject{Sieve::Filter.new(text:filter_text_vacation_disabled)}

        it 'should have a name' do
          subject.name.should == "rule:[autoresposta]"
        end

        it "should have conditions" do
          subject.conditions.count.should == 1
        end

        it "should have actions" do
          subject.actions.count.should == 1
        end

        it "should is disabled" do
          subject.disabled?.should be_true
        end
      end

      context "given a failure" do
      end
    end

    context "#to_s" do
      context "given a success with get text of filter" do
        subject{Sieve::Filter.new(text:filter_text_anyof)}
        it "should return a text" do
          subject.to_s.should == filter_text_anyof
        end
      end

      context "given a success with get text of filter with autoreplay" do
        #subject{Sieve::Filter.new(filter_text_anyof)}
        xit "should return a text" do
          subject.to_s.should == filter_text_anyof
        end
      end
    end

    context "#add_action" do
      context "given a success with add actions" do
        subject{Sieve::Filter.new()}
        let(:action){Sieve::Action.new("stop;")}
        let(:vacation){Sieve::Vacation.new(subject:"teste")}


        it "should add action" do
          subject.add_action(action)
          subject.actions.count.should == 1
        end

        it "should add vacation" do
          subject.add_action(vacation)
          subject.actions.count.should == 1
        end
      end
    end

  end
end