# -*- encoding : utf-8 -*-
require 'spec_helper'

module Sieve
  describe FilterSet do
    let(:filterset_text) {
%q{require ["fileinto","relational","comparator-i;ascii-numeric","copy","vacation"];
# rule:[nome_teste]
if header :contains "Subject" "teste"
{
    fileinto "INBOX.rascunho";
    stop;
}
# rule:[nome2]
if anyof (header :contains "Subject" "lala", not header :contains "Subject" "popo", header :count "gt" :comparator "i;ascii-numeric" "Subject" "4", not exists "Subject", exists "Subject", header :count "ge" :comparator "i;ascii-numeric" "Subject" "2")
{
    fileinto "INBOX";
    fileinto :copy "INBOX.lixo";
    stop;
}
# rule:[nome_all]
if anyof (header :contains "From" "all", header :contains "aaaaa" "333")
{
    fileinto :copy "INBOX.lixo";
    redirect :copy "lala@teste.com";
    redirect "eduardo.lipolis@locaweb.com.br";
    stop;
}
# rule:[nome all rules]
if allof (header :contains "Subject" "asdf", header :contains "From" "vvvvv", header :contains "To" "vvvvv")
{
    fileinto :copy "INBOX.rascunho";
    redirect :copy "lala@teste.com";
    discard;
    stop;
}
# rule:[autoresposta]
if true
{
    vacation :days 1 :subject "nao estou..." :mime text:
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
%q{require ["fileinto","relational","comparator-i;ascii-numeric","copy","vacation"];
# rule:[nome_teste]
if header :contains "Subject" "teste"
{
    fileinto "INBOX.rascunho";
    stop;
}
# rule:[nome_all]
if anyof (header :contains "From" "all", header :contains "aaaaa" "333")
{
    fileinto :copy "INBOX.lixo";
    redirect :copy "lala@teste.com";
    redirect "eduardo.lipolis@locaweb.com.br";
    stop;
}
# rule:[nome all rules]
if allof (header :contains "Subject" "asdf", header :contains "From" "vvvvv", header :contains "To" "vvvvv")
{
    fileinto :copy "INBOX.rascunho";
    redirect :copy "lala@teste.com";
    discard;
    stop;
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
  end
end