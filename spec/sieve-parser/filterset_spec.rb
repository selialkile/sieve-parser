# -*- encoding : utf-8 -*-
require 'spec_helper'

module Sieve
  describe FilterSet do
    let(:filterset_text) {
%Q{require ["fileinto","relational","comparator-i;ascii-numeric","copy","vacation"];
# rule:[nome_teste]
if header :contains "Subject" "teste"
{
\tfileinto "INBOX.rascunho";
\tstop;
}
# rule:[nome2]
if anyof (header :contains "Subject" "lala", not header :contains "Subject" "popo", header :count "gt" :comparator "i;ascii-numeric" "Subject" "4", not exists "Subject", exists "Subject", header :count "ge" :comparator "i;ascii-numeric" "Subject" "2")
{
\tfileinto "INBOX";
\tfileinto :copy "INBOX.lixo";
\tstop;
}
# rule:[nome_all]
if anyof (header :contains "From" "all", header :contains "aaaaa" "333")
{
\tfileinto :copy "INBOX.lixo";
\tredirect :copy "lala@teste.com";
\tredirect "eduardo.lipolis@locaweb.com.br";
\tstop;
}
# rule:[nome all rules]
if allof (header :contains "Subject" "asdf", header :contains "From" "vvvvv", header :contains "To" "vvvvv")
{
\tfileinto :copy "INBOX.rascunho";
\tredirect :copy "lala@teste.com";
\tdiscard;
\tstop;
}
# rule:[autoresposta]
if true
{
\tvacation :days 1 :subject "nao estou..." :mime text:
Content-Type: text/html;

<p>se precisar de mim, chama o <span style="text-decoration: underline;"><em><strong>batman</strong></em></span>...</p><p>eu realmente nao estou.. chama outro...</p><p>para de me amolar...xD</p>
.
;
}
}
    }
    context ".new" do
      context "given a success" do
        subject{Sieve::FilterSet.new(filterset_text)}
        it "should return a object of filterset" do
          subject.class.to_s.should == "Sieve::FilterSet"
        end

        it "should have requires" do
          subject.requires.count.should == 5
        end

        it "should have filters" do
          subject.filters.count.should == 5
        end
      end

      context "given a failure" do
        xit "should return a error if use a bad text of sieve" do
        end
      end
    end

    context "#to_s" do
          let(:filterset_text_to_s) {
%Q{require ["fileinto","relational","comparator-i;ascii-numeric","copy","vacation"];
# rule:[nome_teste]
if header :contains "Subject" "teste"
{
\tfileinto "INBOX.rascunho";
\tstop;
}
# rule:[nome_all]
if anyof (header :contains "From" "all", header :contains "aaaaa" "333")
{
\tfileinto :copy "INBOX.lixo";
\tredirect :copy "lala@teste.com";
\tredirect "eduardo.lipolis@locaweb.com.br";
\tstop;
}
# rule:[nome all rules]
if allof (header :contains "Subject" "asdf", header :contains "From" "vvvvv", header :contains "To" "vvvvv")
{
\tfileinto :copy "INBOX.rascunho";
\tredirect :copy "lala@teste.com";
\tdiscard;
\tstop;
}
}
}
      context "given a success with get text of filterset" do
        subject{Sieve::FilterSet.new(filterset_text_to_s)}
        it "should return a text" do
          subject.to_s.should == filterset_text_to_s
        end
      end
    end

    context "#add_filter" do
      context "given a success" do
        subject{Sieve::FilterSet.new()}

        it "should add new filter" do
          subject.add_filter(Sieve::Filter.new())
          subject.filters.count.should == 1
        end
      end

      context "given a failure" do
        subject{Sieve::FilterSet.new()}

        it "should raise" do
          expect{subject.add_filter(Sieve::Action.new())}.to raise_error("The param is not a Filter!")
        end
      end
    end

    context "#add_require" do
      context "given a success" do
        subject{Sieve::FilterSet.new()}

        it "should add new filter" do
          subject.add_require("fileinto")
          subject.requires.count.should == 1
        end
      end

      context "given a failure" do
        subject{Sieve::FilterSet.new()}

        it "should raise" do
          expect{subject.add_require(0435)}.to raise_error("Is not a require valid!")
        end
      end
    end

  end
end